local M = {}

M.setup = function()
    vim.filetype.add({
        extension = {
            astro = "astro",
            ejs = "html",
            rasi = "css",
            patch = "patch",
        },
        filename = {
            [".prettierrc"] = "jsonc",
            [".eslintrc"] = "jsonc",
            ["tsconfig.json"] = "jsonc",
            ["jsconfig.json"] = "jsonc",
        },
    })
end

return M
