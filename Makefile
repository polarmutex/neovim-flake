lint:
	luacheck dotfiles

docgen:
	#nix run .#""neovim-docgen -- --headless --noplugin -u scripts/minimal_init.vim -c "luafile ./scripts/gendocs.lua" -c 'qa'
	lemmy-help -fact \
		dotfiles/lua/polarmutex/init.lua \
		dotfiles/lua/polarmutex/plugins/beancount.lua \
		> dotfiles/doc/polarmutex.txt
