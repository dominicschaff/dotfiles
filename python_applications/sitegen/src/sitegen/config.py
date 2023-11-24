"""Configuration for the SiteGenerator."""
from dataclasses import dataclass
from pathlib import Path

from .utils import make_plural

# pylint: disable=too-few-public-methods

TEST_COUNT = 100
PROGRESS_STEP_PERCENTAGE = 10


class Modes:
    """Modes available to the generator."""

    COLLECTION = "collection"
    SITE = "site"
    BLOG = "blog"


DEFAULT_CSS = """
body {
    line-height: 1.6;
    font-size: 14px;
    background: #212121;
    color: #E0E0E0;
    font-family:Roboto,Ubuntu,open sans,helvetica neue,sans-serif;
}
.content {
    margin-top: 50px;
    margin-inline: auto;
    width: min(100% - 25px, 650px);
    padding-bottom: 5em;
}
h1, h2, h3 {
    scroll-margin-top: 4em;
    line-height:1.2
}
a {
  color: #90CAF9;
  text-decoration: none;
}
a:visited {
  color: #90CAF9;
}
a:hover {
  color: #F990CA;
  text-decoration: underline;
}
.muted {
    font-size: 0.8em;
}
.navbar {
  background-color: #333;
  position: fixed;
  top: 0;
  left: 0px;
  width: 100%;
}
.navbar-links {
  width: min(100% - 25px, 650px);
  margin-inline: auto;
}
.navbar a {
  float: left;
  display: block;
  padding: 10px;
}
.tag {
  border-radius: 30px;
  background-color: #333333;
  padding: 0.2em 0.5em;
  border:none;
  white-space: nowrap;
  line-height: 2;
}
img {width:100%; border-radius:10%;}
a>svg {height:52px;width:52px;}

#to_top {
  position: fixed;
  bottom: 0.5em;
  right: 0.5em;
}

#to_top > button {
  background-color: #212121;
  color: white;
  padding: 0.5em 0.5em;
  border-radius: 1em;
  border-color: #F7567C;
}
"""

DEFAULT_CONFIG_FILE = f"""
name = "Site name"
input = "src"
mode = "{Modes.COLLECTION}|{Modes.SITE}|{Modes.BLOG}"
output = "output"
collection_name = "items"
rss = true
clean = false
base_href = "http://localhost:8000"
description = "My Awesome Static Site"
favicon = "data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🏁</text></svg>"
favicon_type = "image/svg+xml"

nav = [
  {{ title = "Home", url = "/index.html" }},
  {{ title = "Google", url = "https://google.com/" }},
]
custom_tags = [
 {{ from = "😊", to = "custom_face" }},
"""


@dataclass
class SiteConfig:
    """Configuration for the Site Generator."""

    name: str
    input: Path
    output: Path
    mode: str
    clean: bool
    collection_name: str
    rss: bool
    base_href: str
    description: str
    _favicon: str
    _favicon_type: str
    nav: list[dict[str, str]]
    custom_tags: list[dict[str, str]]
    wpm: int

    def __post_init__(self):
        if self.base_href[-1] != "/":
            self.base_href += "/"
        self.favicon = ""
        if self._favicon is not None and self._favicon_type is not None:
            self.favicon = (
                '<link rel="shortcut icon" '
                'type="{self._favicon_type}" '
                'href="{self._favicon}">'
            )
        self.collection_name_plural = make_plural(self.collection_name)
