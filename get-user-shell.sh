#!/usr/bin/env bash

if [[ "$(uname)" == "Darwin" ]]; then
	exec /bin/zsh --login $@
else
	shell=$($(grep "^$USER:" /etc/passwd | cut -f 7 -d ':') || "$SHELL")
	exec $shell --login $@
fi
