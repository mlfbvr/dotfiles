# ~/.bashrc: executed by bash(2) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

shopt -s histappend
shopt -s cdspell
shopt -s dirspell
shopt -s autocd
shopt -s checkwinsize
shopt -s globstar

# Set the timezone to UTC
export TZ=UTC

export PATH=${PATH}:~/.bin/
