local util = require 'starter-birthday.util'

local M = {}

--- Display the happy birthday message, if applicable
---@param config StarterBirthday.Config|nil
---@return nil|fun(): table
M['mini.starter'] = function(config)
    local cfg = util.merge_and_validate(StarterBirthday.config or {}, config or {})
    if not cfg then
        return
    end
    return function()
        if not (cfg.date.day and cfg.date.month) then
            local ok, lazy = pcall(require, 'lazy')
            return {
                {
                    action = ok and function() end,
                    name = 'Please configure your birthday by passing a day and a month'
                        .. (ok and ' (TODO: press <CR> to edit your configs)' or ''),
                    section = 'No birthday set',
                },
            }
        elseif cfg.demo or os.date '%d%m' == ('%02d%02d'):format(cfg.date.day, cfg.date.month) then
            return {
                {
                    action = function()
                        vim.cmd.b(vim.api.nvim_create_buf(false, true))
                        local t = cfg.ascii_art.text
                        ---@type string[]
                        local text
                        if type(t) == 'string' then
                            text = vim.split(t, '\n')
                        elseif type(t) == 'table' then
                            text = t
                        end
                        vim.api.nvim_buf_set_lines(0, 0, 0, false, text)
                        for k, v in pairs(cfg.ascii_art.opts) do
                            ---@diagnostic disable-next-line: no-unknown
                            vim.opt_local[k] = v
                        end
                    end,
                    name = util.get_or_call(cfg.item.name, cfg),
                    section = util.get_or_call(cfg.item.section, cfg),
                },
            }
        else
            return {}
        end
    end
end

return M
