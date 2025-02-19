return {
	"neovim/nvim-lspconfig",
	config = function()
		local function on_attach_callback(client, bufnr)
			vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<Cmd>lua show_diagnostics_details()<CR>", { silent = true })
			vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", { silent = true })
			vim.api.nvim_buf_set_keymap(
				bufnr,
				"n",
				"gi",
				"<Cmd>lua vim.lsp.buf.implementation()<CR>",
				{ silent = true }
			)
			vim.api.nvim_buf_set_keymap(bufnr, "n", "gK", "<Cmd>lua vim.lsp.buf.hover()<CR>", { silent = true })
			vim.api.nvim_buf_set_keymap(
				bufnr,
				"n",
				"gh",
				"<Cmd>lua vim.lsp.buf.signature_help()<CR>",
				{ silent = true }
			)
			vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<Cmd>lua vim.lsp.buf.references()<CR>", { silent = true })
			vim.api.nvim_buf_set_keymap(bufnr, "n", "gF", "<Cmd>lua vim.lsp.buf.formatting()<CR>", { silent = true })
			vim.api.nvim_buf_set_keymap(
				bufnr,
				"n",
				"<leader>b=",
				"<Cmd>lua vim.lsp.buf.format()<CR>",
				{ silent = false }
			)
			vim.api.nvim_command([[autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()]])
			vim.api.nvim_command([[autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()]])
			vim.api.nvim_command([[autocmd CursorMoved <buffer> lua vim.lsp.util.buf_clear_references()]])
		end
		local lspconfig = require("lspconfig")
		lspconfig.pyright.setup({ on_attach = on_attach_callback })
		lspconfig.ocamllsp.setup({ on_attach = on_attach_callback })
		lspconfig.lua_ls.setup({
			on_attach = on_attach_callback,

			on_init = function(client)
				if client.workspace_folders then
					local path = client.workspace_folders[1].name
					if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
						return
					end
				end

				client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
					runtime = {
						version = "LuaJIT",
					},
					workspace = {
						checkThirdParty = false,
						library = {
							vim.env.VIMRUNTIME,
						},
					},
				})
			end,
			settings = {
				Lua = {
					format = {
						enable = true,
						defaultConfig = {
							indent_style = "space",
							indent_size = "2",
						},
					},
				},
			},
		})
		lspconfig.codeqlls.setup({
			on_attach = on_attach_callback,
		})

		lspconfig.nixd.setup({
			on_attach = on_attach_callback,
		})
	end,
>>>>>>> c8b5c70af3cedb1e3accc2bb6aea33a80df771a4
}
