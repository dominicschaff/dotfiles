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
:root {
  --background: #333;
  --header: #212121;
  --text: #E0E0E0;
  --header-text: #CCCCCC;
  --link: #3C92CA;
  --width: 650px;
}

html {
  background-color: var(--background);
}

body {
  line-height: 1.6;
  font-size: 14px;
  font-family: Roboto,Ubuntu,open sans,helvetica neue,sans-serif;
  color: var(--text);
}
.content {
  margin-top: 4em;
  margin-inline: auto;
  width: min(100% - 25px, var(--width));
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

nav {
  background-color: var(--header);
  color: var(--text);
  display: flex;
  justify-content: space-between;
  position: fixed;
  top: 0;
  left: 0px;
  width: 100%;
}
.navbar-links {
  width: min(100% - 25px, var(--width));
  margin-inline: auto;
}

nav > .navbar-links > .home {
  float: left;
  margin: 1em 0em;
}

nav ul {
  /* Make the markers disappear */
  list-style-type: none;
  float: right;
}

nav ul li {
  /* Puts the elements in a single line */
  display: inline-flex;
  margin: 0em 1em;
}

/* These two lines make the checkbox and the label disappear when we are in desktop mode. */
nav input[type="checkbox"], nav label {
  display: none;
}

/* This start to get interesting: we go into mobile phone mode */
@media (max-width: 576px) {
  /* Here is the magic: if the checkbox is not marked, the adjacent list is not displayed */
  input[type="checkbox"]:not(:checked) + ul {
    display: none;
  }

  nav {
    flex-direction: row;
    flex-wrap: wrap;
    margin-left: 0;
    margin-right: 0;
  }

  /* Stlying the menu icon, the checkbox stays hidden */
  nav label {
    text-align: right;
    display: block;
    padding-top: 1em;
    align-self: center;
    cursor: pointer;
  }

  /* Because we are in mobile mode, we want to display it as a vertical list */
  nav ul {
    display: block;
  }

  /* We have two lists: the first one are the always visibile items in the
    menu bar. The second one is the one that will be hidden */
  nav ul:last-child {
    width: 100%;
    flex-basis: 100%;
  }

  nav ul li {
    margin-bottom: 0;
    width: 100%;
    text-align: right;
    padding: 0.5em;
  }
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


def menu(home: dict[str, str], navs: list[dict[str, str]]):
    nav = "".join([f"""<li><a href="{a['url']}">{a["title"]}</a></li>""" for a in navs])

    return f"""
    <nav>
      <div class="navbar-links">
      <a class="home"  href="{home["url"]}">{home["title"]}</a>
      <!-- The hamburger menu -->
      <label for="menu" tabindex="0">
        <svg width="24px" height="24px" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M4 6H20M4 12H20M4 18H20" stroke="#E0E0E0" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
      </label>
      <input id="menu" type="checkbox" />
      <!-- The collapsable menu -->
      <ul>
        {nav}
      </ul>
      </div>
    </nav>
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
    home: dict[str, str]
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
