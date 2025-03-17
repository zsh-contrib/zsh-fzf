#!/usr/bin/env zsh

j() {
	local dir
	# proceed with the zoxide
	dir=$(
		zoxide query --list --score |
			fzf --height 40% --layout reverse --info inline --highlight-line \
				--nth 2.. --no-sort --query "$*" \
				--bind 'enter:become(echo {2..}),alt-enter:become(fzf_open {2..}),alt-O:become(open {2..})'
	)
	# change the cwd
	cd "$dir" || return $?
}
