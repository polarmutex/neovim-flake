lint:
	luacheck lua

docgen:
	#nix run .#""neovim-docgen -- --headless --noplugin -u scripts/minimal_init.vim -c "luafile ./scripts/gendocs.lua" -c 'qa'
	lemmy-help -fact \
		lua/polarmutex/init.lua \
		lua/polarmutex/plugins/beancount.lua \
		> doc/polarmutex.txt
