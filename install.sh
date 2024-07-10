#!/usr/bin/env bash

set -eo pipefail

STOW_DIR="stow"

function echoerr() {
	echo $@ 1>&2
}

function preconditions() {
	fail=""
	if ! which stow; then
		echoerr "GNU Stow is not installed"
		fail="true"
	fi

	if ! which git; then
		echoerr "Git is not installed"
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

preconditions
install_stowfiles
