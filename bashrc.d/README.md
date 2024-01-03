# Bash Setup

This folder gets included from `../bashrc`, and will only include files that
end in `.sh` so to "turn off" a file change the extention to `.sh.off`

## File naming guide

- No spaces should be allowed.
- File names should follow the pattern: `<section>.<name>.sh`

### Section Numbers:

- *0XX*: Global Bash variables
- *1XX*: OS specific settings
- *2XX*: Core system application functions (should almost always include)
- *3XX*: Common system application functions
- *4XX*: Development application functions
- *5XX*: Optional application functions (include if application exists)
- *6XX*: Custom tools
- *9XX*: Run last