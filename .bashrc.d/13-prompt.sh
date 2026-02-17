# Format the prompt with "user@host path (git branch)"
export PS1="\[\e[34m\]\u@\h \[\e[36m\]\w \[\e[91m\]\$(parse_git_branch)\[\e[00m\]$ "

