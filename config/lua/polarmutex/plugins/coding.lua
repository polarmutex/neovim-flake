local harpoon_spec = {
    name = "harpoon",
    dir = "@neovimPlugin.harpoon@",
    event = "CursorHold",
}

harpoon_spec.config = function()
    require("harpoon").setup({})
    require("telescope").load_extension("harpoon")
end

return {
    harpoon_spec,
}
