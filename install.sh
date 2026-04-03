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
	fail=0
	if ! check_for_command zsh; then
		echoerr "ZSH is not installed"
		fail=1
	fi

	if ! check_for_command stow; then
		echoerr "GNU Stow is not installed"
		fail=1
	fi

	if ! check_for_command git; then
		echoerr "Git is not installed"
		fail=1
	fi
	
	if ! check_for_command lf; then
		echoerr "Lf is not installed. Required for nvim, but proceeding anyway"
	fi

	if [[ "$(uname)" == "Linux" && -z "$(fc-list 'SauceCodePro Nerd Font')" ]]; then
		echoerr "SauceCodePro is not installed"
		fail=1
	elif [[ "$(uname)" == "Darwin" ]]; then
		echo "Please ensure that SauceCodePro Nerd Font is installed and available to the system. Required for alacritty, but proceeding anyway"
	fi

	if [[ $fail -ne 0 ]]; then
		echoerr "Preconditions not satisfied. Please see the above messages."
		exit 1
	fi
}

function install_stowfiles() {
	stow -t "$HOME" "$STOW_DIR"
}

function install_helpers() {
	script_dir=$(dirname $(realpath "${BASH_SOURCE[0]}"))

	if [[ -f "/usr/local/bin/get-user-shell.sh" ]]; then
		echo "get-user-shell.sh already linked in /usr/local/bin, skipping."
		return
	fi

	sudo ln -sf "$script_dir/get-user-shell.sh" "/usr/local/bin/get-user-shell.sh"
}

function install_shellrc() {
	shellrc="$HOME/.shellrc.sh"
	if [[ ! -f "$shellrc" ]]; then
	    echoerr "No .shellrc.sh found at $shellrc"
		exit 1
	fi

	shells=('.bashrc' '.zshrc')

	for shell in "${shells[@]}"; do
		shell_path="$HOME/$shell"
		if [[ ! -f "$shell_path" ]]; then
			echo "shell configuration file $shell_path not found. Skipping."
			continue
		fi

		if ! grep -q "source $shellrc" "$shell_path"; then
			echo $'\n# Custom Configuration\n' "source $shellrc" >> "$shell_path"
			echo "added source line to $shell_path"
		else
			echo "source line already present in $shell_path, skipping."
		fi
	done
}

preconditions
install_helpers
install_stowfiles
install_shellrc
