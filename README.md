# Dot-Files

I was getting annoyed with always keeping my config files in sync on multiple machines,
so here are my configs and a script to install it.

**Note: the installer over writes existing config files**

This dotfiles also contains many utility functions which will get loaded whent he dependancies are met.

## Sample Usage

I would recommend if that if you are going to use my script as is (which is probably a bad idea) then you should make it as a checkout in your home directory i.e. `~/dotfiles` then everything will work as expected.

~~~bash
bash install.sh
~~~

## Configuration

If there is a directory called "bin"/".bin" in your home directory it will be added to your PATH

Instead of changing the `.bashrc` file directly rather make a new file called `bashrc_private` in your home directory, and that will get sourced BEFORE creating the `PS1` variable.

If you do not like my `PS1` output just set a new variable called `PS1_OVERRIDE` in the `bashrc_private` and that will get used instead. If instead you just want to prepend mine then use `PS1_PRE`.

## Notes

The font file in `config/font.tff` is the Hack font.

## Helper functions:

To know what a function/alias done run the alias `h` then the function name to see what it does.

For a list of all defined functions/aliases run `f`

## Shortcuts available:

I have made shortcuts for handbrake, ffmped, various OSX features and Termux features.

And there are utility functions for working with ADB.

For all the rest I highly suggest going through the various scripts.