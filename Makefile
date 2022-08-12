lint:
	luacheck dotfiles

docgen:
	nix run .#""neovim-docgen -- --headless --noplugin -u scripts/minimal_init.vim -c "luafile ./scripts/gendocs.lua" -c 'qa'

