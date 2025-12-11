return {
	-- Deps
	"nvim-neotest/nvim-nio",
	"theHamsta/nvim-dap-virtual-text",

	-- DAP Core
	{
		"mfussenegger/nvim-dap",
        -- stylua: ignore
				keys = {
					{ "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Breakpoint Condition", },
					{ "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint", },
					{ "<leader>dc", function() require("dap").continue() end, desc = "Run/Continue", },
					{ "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args", },
					{ "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor", },
					{ "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)", },
					{ "<leader>di", function() require("dap").step_into() end, desc = "Step Into", },
					{ "<leader>dj", function() require("dap").down() end, desc = "Down", },
					{ "<leader>dk", function() require("dap").up() end, desc = "Up", },
					{ "<leader>dl", function() require("dap").run_last() end, desc = "Run Last", },
					{ "<leader>do", function() require("dap").step_out() end, desc = "Step Out", },
					{ "<leader>dO", function() require("dap").step_over() end, desc = "Step Over", },
					{ "<leader>dP", function() require("dap").pause() end, desc = "Pause", },
					{ "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL", },
					{ "<leader>ds", function() require("dap").session() end, desc = "Session", },
					{ "<leader>dt", function() require("dap").terminate() end, desc = "Terminate", },
					{ "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets", },
				},
		config = function() end,
		opts = function()
			local dap = require("dap")
			if not dap.adapters then
				dap.adapters = {}
			end
			dap.adapters["probe-rs-debug"] = {
				type = "server",
				port = "${port}",
				executable = {
					command = vim.fn.expand("$HOME/.cargo/bin/probe-rs"),
					args = { "dap-server", "--port", "${port}" },
				},
			}

			-- Connect the probe-rs-debug with rust files. Configuration of the debugger is done via project_folder/.vscode/launch.json
			require("dap.ext.vscode").type_to_filetypes["probe-rs-debug"] = { "rust" }
			-- Set up of handlers for RTT and probe-rs messages.
			-- In addition to nvim-dap-ui I write messages to a probe-rs.log in project folder
			-- If RTT is enabled, probe-rs sends an event after init of a channel. This has to be confirmed or otherwise probe-rs wont sent the rtt data.
			dap.listeners.before["event_probe-rs-rtt-channel-config"]["plugins.nvim-dap-probe-rs"] = function(
				session,
				body
			)
				local utils = require("dap.utils")
				utils.notify(
					string.format(
						'probe-rs: Opening RTT channel %d with name "%s"!',
						body.channelNumber,
						body.channelName
					)
				)
				local file = io.open("probe-rs.log", "a")
				if file then
					file:write(
						string.format(
							'%s: Opening RTT channel %d with name "%s"!\n',
							os.date("%Y-%m-%d-T%H:%M:%S"),
							body.channelNumber,
							body.channelName
						)
					)
				end
				if file then
					file:close()
				end
				session:request("rttWindowOpened", { body.channelNumber, true })
			end
			-- After confirming RTT window is open, we will get rtt-data-events.
			-- I print them to the dap-repl, which is one way and not separated.
			-- If you have better ideas, let me know.
			dap.listeners.before["event_probe-rs-rtt-data"]["plugins.nvim-dap-probe-rs"] = function(_, body)
				local message = string.format(
					"%s: RTT-Channel %d - Message: %s",
					os.date("%Y-%m-%d-T%H:%M:%S"),
					body.channelNumber,
					body.data
				)
				local repl = require("dap.repl")
				repl.append(message)
				local file = io.open("probe-rs.log", "a")
				if file then
					file:write(message)
				end
				if file then
					file:close()
				end
			end
			-- Probe-rs can send messages, which are handled with this listener.
			dap.listeners.before["event_probe-rs-show-message"]["plugins.nvim-dap-probe-rs"] = function(_, body)
				local message = string.format("%s: probe-rs message: %s", os.date("%Y-%m-%d-T%H:%M:%S"), body.message)
				local repl = require("dap.repl")
				repl.append(message)
				local file = io.open("probe-rs.log", "a")
				if file then
					file:write(message)
				end
				if file then
					file:close()
				end
			end

			-- Rust debugging with GDB
			dap.adapters["rust-gdb"] = {
				type = "executable",
				command = "rust-gdb",
				args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
			}
			dap.configurations.rust = {
				{
					name = "Launch",
					type = "rust-gdb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					args = {}, -- provide arguments if needed
					cwd = "${workspaceFolder}",
					stopAtBeginningOfMainSubprogram = false,
				},
				{
					name = "Select and attach to process",
					type = "rust-gdb",
					request = "attach",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					pid = function()
						local name = vim.fn.input("Executable name (filter): ")
						return require("dap.utils").pick_process({ filter = name })
					end,
					cwd = "${workspaceFolder}",
				},
				{
					name = "Attach to gdbserver :1234",
					type = "rust-gdb",
					request = "attach",
					target = "localhost:1234",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
				},
			}
		end,
	},

	-- DAP debugger UI like VS Code
	{
		"rcarriga/nvim-dap-ui",
		lazy = true,
		dependencies = {
			"nvim-neotest/nvim-nio",
			"theHamsta/nvim-dap-virtual-text",
		},
    -- stylua: ignore
		keys = {
			{ "<leader>du", function() require("dapui").toggle({}) end, desc = "DAP UI", },
			{ "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = { "n", "x" }, },
		},
		opts = {},
		config = function(_, opts)
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup(opts)
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open({})
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close({})
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close({})
			end
		end,
	},

	-- Integrate with Mason
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = "mason.nvim",
		cmd = { "DapInstall", "DapUninstall" },
		opts = {
			automatic_installation = true,
			handlers = {},
			ensure_installed = {},
		},
		config = function() end,
	},

	-- Languages
	"mfussenegger/nvim-dap-python",
	-- "jedrzejboczar/nvim-dap-cortex-debug", -- May not need if using probe-rs
}

-- vim: ts=2 sts=2 sw=2 et
