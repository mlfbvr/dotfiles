#!/bin/bash

# get the current GIT branch for the current directory
function parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

function hello_world() {
  echo "Hello, world!"
}

function get_pwd() {
  echo ${PWD}
}

