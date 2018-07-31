# `psql`

This tool allows you to run queries on any defined DB.

Usage:

```
psql [<db_name>] [<output_format>:-t] "<query>"
```

The `db_name` is what is defined in your `.psql.cfg`.

The output formats that are allowed are:
* `-info` - this is for debugging, don't actually use it. But will print out status updates of the connection.
* `-json` or `-j` - this will output each row in its own JSON object. (But will not combine into a JSON array.)
* `-csv` or `-c` - this will output into a CSV file.
* `-table` or `-t` - this is the default and will output into a MySQL formatted table.
* `-rows` or `-r` - this will output into MySQL `\G` formatted rows
* `-tiny` or `-s` - this will output into a compressed table
* `-insert` or `-i` - this will output into SQL insert statement, will also include a create statement (assumes everything is a string)
* `-write` or `-w` - this is for running queries that need to be committed.
