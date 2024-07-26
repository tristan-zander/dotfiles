#!/usr/bin/env bash

set -eo pipefail

STOW_DIR="stow"

function echoerr() {
	echo $@ 1>&2
}

function check_for_command() {
	which $1 2>/dev/null
	return $?
}

function preconditions() {
	fail=""
	if ! check_for_command stow; then
		echoerr "GNU Stow is not installed"
		fail="true"
	fi

	if ! check_for_command git; then
		echoerr "Git is not installed"
		fail="true"
	fi
	
	if ! check_for_command lf; then
		echoerr "Lf is not installed. Required for nvim, but proceeding anyway"
	fi

	if [[ "$(uname)" == "Linux" && -z "$(fc-list 'SauceCodePro Nerd Font')" ]]; then
		echoerr "SauceCodePro is not installed"
		fail="true"
	fi

	if [[ ! -z "$fail" ]]; then
		echoerr "Preconditions not satisfied. Please see the above messages."
		exit 1
	fi
}

function install_stowfiles() {
	stow -t "$HOME" "$STOW_DIR"
}

function install_helpers() {
	script_dir=$(dirname $(realpath "${BASH_SOURCE[0]}"))
	sudo ln -sf "$script_dir/get-user-shell.sh" "/usr/local/bin/get-user-shell.sh"
}

preconditions
install_helpers
install_stowfiles
