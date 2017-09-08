err()
{
  echo "[$(date +'%Y-%m-%d %T')]: $@" >&2
}
tlog()
{
  echo "[$(date +'%Y-%m-%d %T')]: $@"
}