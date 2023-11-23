import re
from pathlib import Path


def minify_css(css: str) -> str:
    """Minify provided CSS."""

    # remove comments - this will break a lot of hacks :-P
    css = re.sub(r"\s*/\*\s*\*/", "$$HACK1$$", css)  # preserve IE<6 comment hack
    css = re.sub(r"/\*[\s\S]*?\*/", "", css)
    css = css.replace("$$HACK1$$", "/**/")  # preserve IE<6 comment hack

    # url() doesn't need quotes
    css = re.sub(r'url\((["\'])([^)]*)\1\)', r"url(\2)", css)

    # spaces may be safely collapsed
    css = re.sub(r"\s+", " ", css)

    # shorten collapsable colors: #aabbcc to #abc
    css = re.sub(r"#([0-9a-f])\1([0-9a-f])\2([0-9a-f])\3(\s|;)", r"#\1\2\3\4", css)

    # fragment values can loose zeros
    css = re.sub(r":\s*0(\.\d+([cm]m|e[mx]|in|p[ctx]))\s*;", r":\1;", css)

    output = []
    for rule in re.findall(r"([^{]+){([^}]*)}", css):
        # we don't need spaces around operators
        selectors = [
            re.sub(
                r"(?<=[\[\(>+=])\s+|\s+(?=[=~^$*|>+\]\)])",
                r"",
                selector.strip(),
            )
            for selector in rule[0].split(",")
        ]

        # order is important, but we still want to discard repetitions
        properties = {}
        porder = []
        for prop in re.findall("(.*?):(.*?)(;|$)", rule[1]):
            key = prop[0].strip().lower()
            if key not in porder:
                porder.append(key)
            properties[key] = prop[1].strip()

        # output rule if it contains any declarations
        if properties:
            props = "".join([f"{key}:{properties[key]};" for key in porder])[:-1]

            output.append(f"{','.join(selectors)}{{{props}}}")
    return "".join(output)


def make_plural(word: str) -> str:
    """Make input word a plural."""

    # Check if word is ending with s,x,z or is
    # ending with ah, eh, ih, oh,uh,dh,gh,kh,ph,rh,th
    if re.search("[sxz]$", word) or re.search("[^aeioudgkprt]h$", word):
        # Make it plural by adding es in end
        return re.sub("$", "es", word)

    # Check if word is ending with ay,ey,iy,oy,uy
    if re.search("y$", word):
        # Make it plural by removing y from end adding ies to end
        return re.sub("y$", "ies", word)

    # In all the other cases
    # Make the plural of word by adding s in end
    return word + "s"


def strip_empty_lines(string):
    """Remove empty lines from string start and end."""
    lines = string.splitlines()
    while lines and not lines[0].strip():
        lines.pop(0)
    while lines and not lines[-1].strip():
        lines.pop()
    return "\n".join(lines)


def get_text_file_content(file_name) -> str:
    """Get contents of text file."""
    if isinstance(file_name, str):
        file_name = Path(file_name)
    with file_name.open("r", encoding="utf-8") as file_pointer:
        return file_pointer.read()


def seconds_to_string(seconds, include_milliseconds=False):
    """Convert seconds to a nice string."""
    minutes = seconds // 60
    hours = minutes // 60
    days = minutes // 24
    milliseconds = int((seconds - int(seconds)) * 1000)

    hours = int(hours % 24)
    minutes = int(minutes % 60)
    seconds = int(seconds % 60)

    str_seconds = f"{seconds:02}"
    if include_milliseconds:
        str_seconds = f"{str_seconds}.{milliseconds:04}"

    if days > 0:
        return f"{days} days {hours:02}:{minutes:02}:{str_seconds}"
    if hours > 0:
        return f"{hours:02}:{minutes:02}:{str_seconds}"
    if minutes > 0:
        return f"{minutes:02}:{str_seconds}"
    return f"{str_seconds} seconds"
