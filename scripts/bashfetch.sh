#!/bin/bash
getpwname() {
	getent passwd $USER | cut -d ':' -f 5 | cut -d ',' -f 1	
}

getresolutions() {
	resolutions=$(xrandr -q 2>/dev/null| grep '+' | grep -v connected | cut -d" " -f4 | xargs )
	echo ${resolutions:-"N/A"}
}

getvideocard() {
	lspci | egrep -i 'vga|3d' | cut -d' ' -f2- | cut -d: -f2- | sed 's/^\s\+//g'
}

COLUMNS=$(stty size | awk '{ print $2 }')
ROWS=$(stty size | awk '{ print $1 }')
echo "${USER}@$(hostname) ($(getpwname))"
for i in $(seq 1 ${COLUMNS}); do echo -n "="; done
echo HOSTNAME: $(hostname)
echo OS: $(lsb_release -ds)
echo Kernel: $(uname -sr)
echo Shell: ${SHELL}
echo CPU: $(cat /proc/cpuinfo | grep "model name" | cut -d: -f2 | head -n1 | xargs) $(uname -p)
echo GPU: $(getvideocard)
echo WM: ${XDG_SESSION_DESKTOP:-"N/A"}
echo Terminal: ${ROWS}x${COLUMNS}
echo Resolutions: $(getresolutions)