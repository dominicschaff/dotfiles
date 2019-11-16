
from datetime import datetime
from sty import fg, bg, ef, rs
import sys


def error(s):
  print(fg.red + str(datetime.now().time()) + " : " + "[ERROR]" + fg.rs + " " + s, file=sys.stderr)


def info(s):
  print(fg.cyan + str(datetime.now().time()) + " : " + "[INFO]" + fg.rs + " " + s, file=sys.stderr)


def warn(s):
  print(fg.yellow + str(datetime.now().time()) + " : " + "[WARN]" + fg.rs + " " + s, file=sys.stderr)


def show(s):
  print(s, file=sys.stderr)


def convert_java_millis(java_time_millis):
    """Provided a java timestamp convert it into python date time object"""
    s = str(java_time_millis)
    if len(s) > 10:
      if java_time_millis:
        ds = datetime.fromtimestamp(int(s[:10]))
        ds = ds.replace(hour=ds.hour,minute=ds.minute,second=ds.second,microsecond=int(s[10:]) * 1000)
        return ds
      else:
        return datetime.fromtimestamp(0)
    else:
      return datetime.fromtimestamp(0)
