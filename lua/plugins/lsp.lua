vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
        local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, {
                buffer = event.buf,
                desc = "Lsp: " .. desc,
            })
        end

        map("gd", vim.lsp.buf.definition, "Go to definition")
        map("gD", vim.lsp.buf.declaration, "Go to declaration")
        map("gr", "<cmd>Telescope lsp_references<cr>", "References")
        map("K", vim.lsp.buf.hover, "Hover Documentation")

        map("<leader>rn", vim.lsp.buf.rename, "Rename")
        map("<leader>ca", vim.lsp.buf.code_action, "Code action")
    end,
})
return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "j-hui/fidget.nvim",
                opts = {},
            },
        },
    },
    {
        "mason-org/mason.nvim",
        opts = {
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        },
    },
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {
            automatic_enable = {
                exclude = { "jdtls" },
            },
        },
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
    },
    {
        "mfussenegger/nvim-jdtls",
        ft = "java",
        config = function()
            local jdtls = require("jdtls")
            local function split(inputstr, sep)
                if sep == nil then
                    sep = "%s"
                end
                local t = {}
                for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
                    table.insert(t, str)
                end
                return t
            end
            local os_name = vim.uv.os_uname().sysname
            local versions = {}
            local maxVer = 0
            if os_name == "Linux" then
                local java_versions = vim.trim(vim.fn.system("update-java-alternatives --list"))
                local t = split(java_versions)
                for i = 1, #t / 3 do
                    local ver = tonumber(string.sub(t[3 * i - 1], 1, 3))
                    if ver ~= nil then
                        if ver == 108 then
                            ver = 1.8
                        else
                            ver = math.floor(ver / 10)
                        end
                        versions[ver] = t[3 * i]
                        if ver >= 21 and ver > maxVer then
                            maxVer = ver
                        end
                    end
                end
            elseif os_name == "Darwin" then
                local java_versions = vim.trim(vim.fn.system("/usr/libexec/java_home - V 2>&1 | sed '1d;$d'"))
                local t = split(java_versions)
                for i = 1, #t / 7 do
                    local ver = tonumber(string.sub(t[7 * (i - 1) + 1], 1, 3))
                    if ver ~= nil then
                        versions[ver] = t[7 * i]
                        if ver >= 21 and ver > maxVer then
                            maxVer = ver
                        end
                    end
                end
            end
            if maxVer == 0 then
                print("There is no java version greater than 21, jdtls would fail to start")
            end
            local runtimesConfig = {}
            for key, value in pairs(versions) do
                table.insert(runtimesConfig, {
                    name = "JavaSE-" .. key,
                    path = value,
                })
            end
            local jdtls_group = vim.api.nvim_create_augroup("jdtls_setup", { clear = true })
            vim.api.nvim_create_autocmd("FileType", {
                group = jdtls_group,
                pattern = "java",
                callback = function()
                    local config = {
                        cmd = {
                            "jdtls",
                            "--java-executable=" .. versions[maxVer] .. "/bin/java",
                        },
                        root_dir = jdtls.setup.find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
                        settings = {
                            java = {
                                configuration = {
                                    runtimes = runtimesConfig,
                                },
                            },
                        },
                    }
                    jdtls.start_or_attach(config)
                end,
            })
            vim.cmd("doautocmd FileType java")
        end,
    },
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    { -- optional cmp completion source for require statements and module annotations
        "hrsh7th/nvim-cmp",
        opts = function(_, opts)
            opts.sources = opts.sources or {}
            table.insert(opts.sources, {
                name = "lazydev",
                group_index = 0, -- set group index to 0 to skip loading LuaLS completions
            })
        end,
    },
    { -- optional blink completion source for require statements and module annotations
        "saghen/blink.cmp",
        version = "1.*",
        opts = {
            sources = {
                -- add lazydev to your completion providers
                default = { "lazydev", "lsp", "path", "snippets", "buffer" },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        -- make lazydev completions top priority (see `:h blink.cmp`)
                        score_offset = 100,
                    },
                },
            },
            signature = { enabled = true },
        },
    },
    -- { "folke/neodev.nvim", enabled = false }, -- make sure to uninstall or disable neodev.nvim
}
