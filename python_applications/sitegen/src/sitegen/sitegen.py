"""Static Generator.

This can generator a static site given a directory of tagged content.
"""

# pylint: disable=broad-except
# pylint: disable=too-many-instance-attributes
# pylint: disable=no-member
# pylint: disable=too-many-arguments
# pylint: disable=too-many-branches
# pylint: disable=too-many-statements
# pylint: disable=too-many-locals
# pylint: disable=line-too-long

import argparse
import logging
import re
import shutil
import sys

try:
    import tomllib
except ImportError:
    import toml as tomllib

from datetime import datetime
from pathlib import Path
from time import time

import html2text
import htmlmin
import markdown
import readtime
from markdown.extensions.wikilinks import WikiLinkExtension

from .config import DEFAULT_CONFIG_FILE, DEFAULT_CSS, Modes, SiteConfig, TEST_COUNT, PROGRESS_STEP_PERCENTAGE
from .utils import get_text_file_content, minify_css, seconds_to_string, strip_empty_lines

# Custome log level:
PROGRESS = logging.WARNING + 1


class SiteGenerator:
    """Static Site Generator, works primarily with tags."""

    def __init__(self, config_file: Path, test_run=False):
        self.logger = logging.getLogger(__name__)

        # Config Setup
        if not config_file.exists():
            self.logger.error("Config file doesn't exist: %s", config_file.name)
            sys.exit(1)
        config = tomllib.loads(get_text_file_content(config_file))

        self.config = SiteConfig(
            name=config.get("name", "Example Site"),
            input=Path(config.get("input", "src")),
            output=Path(config.get("output", "public")),
            mode=config.get("mode", None),
            collection_name=config.get("collection_name", "posts"),
            rss=config.get("rss", False),
            base_href=config.get("base_href", ""),
            description=config.get("description", config.get("name", "Example Site")),
            _favicon=config.get("favicon", None),
            _favicon_type=config.get("favicon_type", None),
            nav=[],
            custom_tags={},
            wpm=config.get("wpm", 265),
            clean=config.get("clean", True),
        )
        self._test_mode = test_run

        # Helper Libraries
        self._markdown = markdown.Markdown(
            extensions=[
                WikiLinkExtension(base_url="", end_url=".html", build_url=self._create_wikilink),
                "markdown_include.include",
                "abbr",
                "sane_lists",
                "smarty",
                "def_list",
                "attr_list",
                "toc",
                "full_yaml_metadata",
            ]
        )
        self._html2text = html2text.HTML2Text()

        # Local variables
        self._css = DEFAULT_CSS

        # Cache
        self._files = {}
        self._tags = {}
        self._authors = {}
        self._author_less = []
        self._tag_less = []
        self._content = {}
        self._file_links = {}
        self._extra_navs = []

        # Common Settings
        self.regex_tag = re.compile(r"[^a-z0-9]")
        self.regex_item = re.compile(r"[^A-Za-z0-9_-]")
        self._tz = datetime.now().astimezone().tzinfo

        # Others

        # Setup for local cache
        custom_tags = config.get("custom_tags", None)
        if isinstance(custom_tags, list):
            for mapping in custom_tags:
                self.config.custom_tags[mapping["from"]] = mapping["to"]

        navigation_links = config.get("nav", None)
        if isinstance(navigation_links, list):
            for nav in navigation_links:
                self.config.nav.append(nav)

        self._nav_out = self._generate_nav_bar()

        if config.get("css", None) is not None:
            css = Path(config["css"])
            if css.exists():
                css_content = get_text_file_content(css)
                if config.get("css_append", False):
                    self._css += "\n" + css_content
                else:
                    self._css = css_content
            else:
                self.logger.warning("CSS file defined, but doesn't exist")
        self._css = minify_css(self._css)

        # Output local setup for info:
        self.logger.info("Site name        : %s", self.config.name)
        self.logger.info("Generation mode  : %s", self.config.mode)
        self.logger.info("Input Directory  : %s", self.config.input)
        self.logger.info("Output Directory : %s", self.config.output)
        self.logger.info("WPM              : %s", self.config.wpm)
        self.logger.info("Base host        : %s", self.config.base_href)
        self.logger.info("Create RSS       : %s", "yes" if self.config.rss else "no")

    def _generate_nav_bar(self):
        nav = "".join(
            [f"""<a href="{a['url']}">{a["title"]}</a>""" for a in self.config.nav]
            + [f"""<a href="{self.link(a['url'])}">{a["title"]}</a>""" for a in self._extra_navs]
        )
        return f"""<div class="navbar"><div class="navbar-links">{nav}</div></div>"""

    def _linkify_file(self, file: Path):
        base_link = self.regex_item.sub("_", file.stem)
        if self.config.mode == Modes.COLLECTION:
            return Path(self.config.collection_name) / base_link

        if self.config.mode == Modes.SITE:
            name = list(file.parts[1:])
            name[-1] = name[-1].replace(".md", "").replace(" ", "_")
            p = Path(name[0])
            for n in name[1:]:
                p = p / n
            return p

        return Path(base_link)

    def _create_wikilink(self, label, base, end):
        """Output the WikiLink."""
        if label in self._file_links:
            return f"{self.config.base_href}{base}{self._file_links[label]}{end}"
        return f"{self.config.base_href}{base}{label.lower().replace(' ', '_')}{end}"

    def _progress(self, message):
        self.logger.log(PROGRESS, message)

    def link(self, uri: str) -> str:
        """Generate an internal link."""
        if uri.startswith("http"):
            return uri
        if uri.startswith(self.config.base_href):
            return uri
        while uri[0] == "/":
            uri = uri[1:]
        return f"{self.config.base_href}{uri}"

    def scan(self, start=None):
        """Scan directory structure, and record all files."""
        if start is None:
            self._files = {"md": [], "static": []}
            start = self.config.input
        for file in start.iterdir():
            if file.is_dir():
                self.scan(file)
            else:
                if file.name.endswith(".md"):
                    self._files["md"].append(file)
                else:
                    self._files["static"].append(file)
                self._file_links[file.stem] = self._linkify_file(file)

    def process_all(self):
        """Process all files."""
        files = self._files["md"][:TEST_COUNT] if self._test_mode else self._files["md"]
        count = len(files)
        steps = len(files)//PROGRESS_STEP_PERCENTAGE
        for index, md_file in enumerate(files):
            if index % steps == 0:
                self._progress(f"Busy... {100*(index+1)/count:.0f} %")
            try:
                self.process(md_file)
            except Exception as e:
                self.logger.error("Error Processing: %s", md_file.name)
                self.logger.exception(e)

    def process(self, md_file: Path):
        """Process a file, and get all meta info on the text"""
        self.logger.info("Processing ... %s", md_file.name)
        data = self.process_file(md_file)
        if data is None:
            return

        if "tags" in data["headers"]:
            if isinstance(data["headers"]["tags"], list):
                for tag_tmp in data["headers"]["tags"]:
                    tag = tag_tmp.lower()
                    tag_link = tag
                    if tag_link in self.config.custom_tags:
                        tag_link = self.config.custom_tags[tag_link]
                    if tag not in self._tags:
                        self._tags[tag] = {
                            "title": tag.title(),
                            "items": [],
                            "link": "tags/" + self.regex_tag.sub("_", tag_link) + ".html",
                        }
                    self._tags[tag]["items"].append(md_file)

                data["tags"] = data["headers"]["tags"]
            else:
                self.logger.error("File %s has the wrong type for 'tags'", md_file.name)
                data["tags"] = []
        else:
            data["tags"] = []
            self._tag_less.append(md_file)

        if "author" in data["headers"] and len(data["headers"]["author"]) > 0:
            author = data["headers"]["author"].lower()
            if author not in self._authors:
                self._authors[author] = []
            self._authors[author].append(md_file)
        else:
            self._author_less.append(md_file)
        data["link"] = str(self._linkify_file(md_file)) + ".html"
        self._content[str(md_file)] = data

    def process_file(self, md_file: Path) -> dict:
        """Process giving MarkDown file."""
        content = get_text_file_content(md_file)

        text = self._markdown.reset().convert(content)
        headers = self._markdown.Meta
        if headers is None:
            headers = {}
        toc = self._markdown.toc
        if toc.replace("\n", "") == """<div class="toc"><ul></ul></div>""":
            toc = ""

        return {
            "title": headers.get("title", md_file.stem),
            "headers": headers,
            "toc": toc,
            "content": text,
            "modified": datetime.fromtimestamp(md_file.stat().st_mtime, tz=self._tz),
            "readtime": readtime.of_html(text, wpm=self.config.wpm),
            "file": md_file,
        }

    def _write(self, filepath, title, body):
        """Write out the content, with adding the surrounding code."""
        self.logger.info("Output: %s [%s]", filepath, title)
        out = self.config.output / filepath

        if out.exists():
            raise ValueError(f"{filepath} already exists")

        content = f"""<!DOCTYPE html>
<html lang="en">
    <head>
        <meta name=viewport content="width=device-width,initial-scale=1,shrink-to-fit=yes">
        <title>{title}</title>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <meta name="description" content="{self.config.description}">
        {self.config.favicon}
        <style>{self._css}</style>
    </head>
    <body>
        {self._nav_out}
        <div class="content">{body}</div>
        <div id="to_top">
            <button onclick="topFunction()">
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
                    <path d="M6 18h12v2H6zm6-14.414-6.707 6.707 1.414 1.414L11 7.414V16h2V7.414l4.293 4.293 1.414-1.414z" fill="#F7567C"></path>
                </svg>
            </button>
        </div>
    </body>
    <script>function topFunction() {{document.body.scrollTop = 0; document.documentElement.scrollTop = 0;}}</script>
</html>"""

        with (self.config.output / filepath).open("w") as outfile:
            outfile.write(htmlmin.minify(content, remove_comments=True, remove_empty_space=True))

    def clean_output(self):
        """Clean the output directory if exists, or create."""
        if not self.config.clean:
            return
        if self.config.output.exists():
            for link in self.config.output.iterdir():
                if link.is_dir():
                    try:
                        shutil.rmtree(link)
                    except Exception:
                        pass
                else:
                    link.unlink()
        else:
            self.config.output.mkdir(exist_ok=True)

    def create_rss(self, output_file, content):
        """Create an RSS feed."""
        if not self.config.rss:
            return
        items = "\n".join(
            [
                f"""<item>
<link>{c['link']}</link>
<description>{strip_empty_lines(c['description'])}</description>
<pubDate>{c['date'].strftime('%a, %d %b %Y %H:%M:%S %Z')}</pubDate>
</item>"""
                for c in content
            ]
        )

        now = datetime.now()

        template = f"""<?xml version="1.0"?>
<rss version="2.0">
      <title>{self.config.name}</title>
      <link>{self.config.base_href}</link>
      <description>{self.config.description}</description>
      <language>en-uk</language>
      <pubDate>{now.strftime('%a, %d %b %Y %H:%M:%S %Z')}</pubDate>
      <lastBuildDate>{now.strftime('%a, %d %b %Y %H:%M:%S %Z')}</lastBuildDate>
      {items}
</rss>
"""
        with output_file.open("w") as outfile:
            outfile.write(template)

    ################################################################################
    # Collection Builder functions
    ################################################################################

    def collection_output_index(self):
        """Create homepage."""
        data = [content for _, content in self._content.items()]
        data.sort(reverse=True, key=lambda d: d["modified"])
        newest = [
            f"""<a href="{self.link(d['link'])}">{d['title']}
            <span class="muted">({d['readtime']})</span></a>"""
            for d in data[:25]
        ]
        self.create_rss(
            self.config.output / "feed.rss",
            [
                {
                    "link": self.link(f"{self.config.collection_name}/{d['link']}"),
                    "description": self._html2text.handle(d["content"])[:250],
                    "date": d["modified"],
                }
                for d in data[:25]
            ],
        )
        popular_tags = [
            {"tag": name, "count": len(tag["items"])} for name, tag in self._tags.items()
        ]
        popular_tags.sort(reverse=True, key=lambda d: d["count"])
        tags = [
            f"""<a href="{self.link(self._tags[d['tag']]['link'])}">{self._tags[d['tag']]['title']}
            <span class="muted">({d['count']})</span></a>"""
            for d in popular_tags[:25]
        ]
        seconds = sum(item["readtime"].seconds for _, item in self._content.items())
        max_seconds = max(item["readtime"].seconds for _, item in self._content.items())
        data = [
            item for _, item in self._content.items() if item["readtime"].seconds == max_seconds
        ]
        longest_stories = [
            f"""<a href="{self.link(d['link'])}">{d['title']}
            <span class="muted">({d['readtime']})</span></a>"""
            for d in data
        ]

        tpl = f"""<h1>Newest {self.config.collection_name_plural.title()}:</h1>
        {"<br />".join(newest)}
        <h1>Popular Tags:</h1>
        {"<br />".join(tags)}
        <h1>Stats:</h1>
        Count of Tags: {len(self._tags)}<br />
        Count of Authors: {len(self._authors)}<br />
        Count of Stories: {len(self._content)}<br />
        Total Read Time: {seconds_to_string(seconds)}<br />
        Average Read time: {seconds_to_string(seconds//len(self._content))}<br />
        Longest Read time: {seconds_to_string(max_seconds)} [{", ".join(longest_stories)}]<br />
        """

        self._write("index.html", "Home", tpl)

    def _output_tag_page(self, tag):
        items = [self._content[str(i)] for i in tag["items"]]
        items.sort(key=lambda i: i["title"])
        links = [
            f"""<a href="{self.link(i['link'])}">{i['title']}
            <span class="muted">({i['readtime']})</span></a>"""
            for i in items
        ]
        tpl = f"""<h1>{tag['title']}
        <span class="muted">({len(tag['items'])})</span></h1>
        {"<br />".join(links)}"""
        return tpl

    def collection_output_tags(self):
        """Create tag list page, and all individual tag pages."""
        tags_all = []
        tags = [v for _, v in self._tags.items()]
        self.logger.debug(tags)
        tags.sort(key=lambda d: d["title"])
        if len(self._tag_less) > 0:
            tags_all.append(
                f"""<a href="{self.link("tags/untagged.html")}">Untagged
                ({len(self._tag_less)})</a>"""
            )
            self._write(
                "tags/untagged.html",
                "Untagged",
                self._output_tag_page({"items": self._tag_less, "title": "Untagged"}),
            )
        custom_tags = []
        for tag in tags:
            if tag["title"] in self.config.custom_tags:
                custom_tags.append(
                    f"""<a href="{self.link(tag['link'])}">{tag['title']}
                    ({len(tag['items'])})</a>"""
                )
            else:
                tags_all.append(
                    f"""<a href="{self.link(tag['link'])}">{tag['title']}
                    ({len(tag['items'])})</a>"""
                )
            self._write(tag["link"], tag["title"], self._output_tag_page(tag))
        self._write(
            "tags.html",
            "Tags",
            f"""<h1>All Tags</h1>{"<br />".join(custom_tags+tags_all)}""",
        )

    def collection_output_authors(self):
        """Create tag list page, and all individual tag pages."""
        authors_all = []
        authors = [a for a, v in self._authors.items()]
        authors.sort()
        if len(self._author_less) > 0:
            authors_all.append(
                f"""<a class="tag" href="{self.link("authors/unauthored.html")}">No Author
                ({len(self._author_less)})</a>"""
            )
            self._write(
                "authors/unauthored.html",
                "No Author",
                self._output_tag_page({"items": self._author_less, "title": "No Author"}),
            )
        for author in authors:
            items = self._authors[author]
            author_link = "authors/" + self.regex_tag.sub("_", author.lower()) + ".html"
            authors_all.append(
                f"""<a href="{self.link(author_link)}">{author}
                ({len(items)})</a>"""
            )
            self._write(
                author_link,
                author,
                self._output_tag_page({"title": author, "items": items}),
            )
        self._write(
            "authors.html",
            "Authors",
            f"""<h1>All Authors</h1>{"<br />".join(authors_all)}""",
        )

    def collection_output_collection(self):
        """Create collection list page, and all inidividual item pages"""
        collection = [c for _, c in self._content.items()]
        collection.sort(key=lambda d: d["title"])
        item_links = [
            f"""<a href="{self.link(item['link'])}">{item['title']}
            <span class="muted">({item['readtime']})</span></a>"""
            for item in collection
        ]
        self._write(
            f"{self.config.collection_name_plural}.html",
            f"All {self.config.collection_name_plural.title()}",
            f"""<h1>All {self.config.collection_name_plural.title()}</h1>
            {"<br />".join(item_links)}""",
        )

        for item in collection:
            tags = [
                f"""<a class="tag"
                href="{self.link(self._tags[tag.lower()]['link'])}">{tag.title()}</a>"""
                for tag in item["tags"]
            ]
            published = item["modified"].strftime("%Y-%m-%d")
            if "published" in item["headers"] and len(item["headers"]["published"]) > 0:
                published = item["headers"]["published"]
            if "date" in item["headers"] and len(item["headers"]["date"]) > 0:
                published = item["headers"]["date"]
            author = ""
            if "author" in item["headers"] and len(item["headers"]["author"]) > 0:
                author_link = self.link(
                    "authors/"
                    + self.regex_tag.sub("_", item["headers"]["author"].lower())
                    + ".html"
                )
                author = f""", Written by: <a class="tag" href="{author_link}">{item['headers']['author']}</a>"""

            source = ""
            if "source" in item["headers"] and len(item["headers"]["source"]) > 0:
                if isinstance(item["headers"]["source"], list):
                    if len(item["headers"]["source"]) == 1:
                        source = f""" | <a target="_blank" href="{item["headers"]["source"][0]}">Source</a>"""
                    else:
                        source = " | Sources: " + (
                            ",".join(
                                [
                                    f"""<a target="_blank" href="{source}">{index+1}</a>"""
                                    for index, source in enumerate(item["headers"]["source"])
                                ]
                            )
                        )
                else:
                    source = (
                        f""", <a target="_blank" href="{item['headers']['source']}">Source</a>"""
                    )
            tags_html = ""
            if len(tags) > 0:
                tags_html = f"""<p>Tags: {", ".join(tags)}</p>"""
            self._write(
                item["link"],
                item["title"],
                f"""<h1>{item['title']}
                <span class="muted">{item['readtime']}</h1>
                <p>Published on <span class="tag">{published.strip()}</span>{author.strip()}{source}</p>
                {tags_html}
                {item['toc']}
                {item['content']}""",
            )

    ################################################################################
    # Blog Builder functions
    ################################################################################

    ################################################################################
    # Site Builder functions
    ################################################################################

    def site_output_static(self):
        """Output a static site."""
        for file in self._files["static"]:
            name = list(file.parts[1:])
            p = self.config.output
            for n in name:
                p = p / n
            p.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy(file, p)

    def site_output_md(self):
        """Output a markdown file."""
        files = self._files["md"][:TEST_COUNT] if self._test_mode else self._files["md"]
        count = len(files)
        steps = len(files)//PROGRESS_STEP_PERCENTAGE
        for index, file in enumerate(files):
            if index % steps == 0:
                self._progress(f"Busy... {100*(index+1)/count:.0f} %")
            name = list(file.parts[1:])
            name[-1] = name[-1].replace(".md", ".html").replace(" ", "_")
            p = Path(name[0])
            for n in name[1:]:
                p = p / n
            (self.config.output / p).parent.mkdir(parents=True, exist_ok=True)
            data = self.process_file(file)
            self._write(p, data["title"], data["content"])

    ################################################################################
    # Generate functions
    ################################################################################

    def generate_collection(self):
        """Generate a collection."""
        self.config.collection_name = self.config.collection_name.lower()
        if "/index.html" not in [u["url"] for u in self.config.nav]:
            self.config.nav.append({"url": "/index.html", "title": "Home"})
        self._progress("Locating Files...")
        self.scan()
        self._progress("Clean Previous Files...")
        self.clean_output()
        self._progress("Processing Files...")
        start = time()
        self.process_all()
        end = time()
        self._progress(f"Took {seconds_to_string(end-start, True)} to process all files")
        self._progress("Make initial directories...")
        if len(self._authors.keys()) > 0:
            self._extra_navs.extend([{"url": "authors.html", "title": "Authors"}])
            (self.config.output / "authors").mkdir(exist_ok=True)
        (self.config.output / "tags").mkdir(exist_ok=True)
        (self.config.output / self.config.collection_name).mkdir(exist_ok=True)

        self._extra_navs.extend(
            [
                {"url": "tags.html", "title": "Tags"},
                {
                    "url": f"{self.config.collection_name_plural}.html",
                    "title": self.config.collection_name_plural.title(),
                },
            ]
        )

        self._nav_out = self._generate_nav_bar()

        start = time()
        self._progress("Output home page...")
        self.collection_output_index()
        self._progress("Output tag page(s)...")
        self.collection_output_tags()
        self._progress("Output author page(s)...")
        if len(self._authors.keys()) > 0:
            self.collection_output_authors()
        self._progress("Output collection pages...")
        self.collection_output_collection()

        end = time()
        self._progress(f"Took {seconds_to_string(end-start, True)} to output all files")

        self._progress(f"Tag count: {len(self._tags)}")
        self._progress(
            f"Author count: {len(self._authors)}",
        )
        self._progress(
            f"Collection count: {len(self._content)}",
        )
        seconds = sum(item["readtime"].seconds for _, item in self._content.items())
        max_seconds = max(item["readtime"].seconds for _, item in self._content.items())
        self._progress(
            f"Total Read time: {seconds_to_string(seconds)}",
        )
        self._progress(
            f"Longest Read time: {seconds_to_string(max_seconds)}",
        )
        self._progress(
            f"Average Read time: {seconds_to_string(seconds//len(self._content))}",
        )

    def generate_site(self):
        """Generate a site."""
        self._progress("Locating Files...")
        self.scan()
        self._progress("Delete Previous Files...")
        self.clean_output()
        self._progress("Output Static Content...")
        self.site_output_static()
        self._progress("Output Markdown Content...")
        self.site_output_md()

    def generate_blog(self):
        """Generate a blog."""
        self.scan()
        self.clean_output()

    def generate(self):
        """Generate output based on given mode."""
        start = time()
        if self.config.mode == Modes.COLLECTION:
            self.generate_collection()
        elif self.config.mode == Modes.SITE:
            self.generate_site()
        elif self.config.mode == Modes.BLOG:
            self.logger.warning("Blog type is not available yet")
            # self.generate_blog()
        else:
            self.logger.error("No such mode %s", self.config.mode)
        end = time()
        self._progress(
            f"We took {seconds_to_string(end-start, True)} for the entire process",
        )


def main():
    """Main function."""
    parser = argparse.ArgumentParser(description="Run the Site Creator")
    parser.add_argument(
        "-c",
        "--config",
        help="Config file to use",
        default="config.toml",
        type=str,
    )
    parser.add_argument(
        "-v",
        "--verbose",
        help="Print Progress",
        action="store_true",
        default=False,
    )
    parser.add_argument(
        "--test",
        help="Do a test run",
        action="store_true",
        default=False,
    )
    parser.add_argument(
        "--debug",
        help="Print Debug",
        action="store_true",
        default=False,
    )

    parser.add_argument(
        "--example_config",
        help="Generate Example Config",
        default=False,
        action="store_true",
    )

    args = parser.parse_args()

    if args.example_config:
        print(DEFAULT_CONFIG_FILE)
        sys.exit(0)

    level = logging.WARNING
    if args.verbose:
        level = logging.INFO
    if args.debug:
        level = logging.DEBUG
    logging.basicConfig(level=level, format="%(asctime)s %(levelname)-8s: %(message)s")
    logging.addLevelName(PROGRESS, "PROGRESS")

    sg = SiteGenerator(config_file=Path(args.config), test_run=args.test)
    sg.generate()


if __name__ == "__main__":
    main()
