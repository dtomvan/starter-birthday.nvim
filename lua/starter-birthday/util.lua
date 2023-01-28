local M = {}

---@param config StarterBirthday.Config
---@param is_setup true|nil
---@return boolean
M.validate_config = function(config, is_setup)
    ---@diagnostic disable-next-line: param-type-mismatch, no-unknown
    local ok, e = pcall(vim.validate, {
        ['config.date'] = { config.date, 't' },
        ['config.date.day'] = {
            config.date.day,
            function(x)
                if type(x) == 'nil' and not is_setup then
                    -- nil will be handled in a more gentle way on the starter
                    -- (will not error every time it is updated, just on setup())
                    return true
                end
                if type(x) ~= 'number' then
                    return
                end
                local month_to_days = {
                    31,
                    29,
                    31,
                    30,
                    31,
                    30,
                    31,
                    31,
                    30,
                    31,
                    30,
                    31,
                }
                return x <= month_to_days[config.date.month]
            end,
            'day of month (appropriate for the month, e.g. in february at most 29)',
        },
        ['config.date.month'] = {
            config.date.month,
            function(x)
                return (x == nil and not is_setup) or type(x) == 'number' and x >= 1 and x <= 12
            end,
            'month number (between 1 and 12)',
        },
        ['config.username'] = { config.username, 's', true },
        ['config.locale'] = { config.locale, 's', true },
        ['config.demo'] = { config.demo, 'b' },
        ['config.item'] = { config.item, 't' },
        ['config.item.name'] = { config.item.name, { 's', 'f' }, true },
        ['config.item.section'] = { config.item.section, { 's', 'f' }, true },
        ['config.item.rainbow'] = { config.item.rainbow, 't' },
        ['config.item.rainbow.enabled'] = { config.item.rainbow.enabled, 'b' },
        ['config.item.rainbow.hl_groups'] = {
            config.item.rainbow.hl_groups,
            function(x)
                if type(x) ~= 'table' then
                    return
                end
                for _, v in ipairs(x) do
                    return type(v) == 'string'
                end
                return true
            end,
            'string[]',
        },
        ['config.ascii_art'] = { config.ascii_art, 't' },
        ['config.ascii_art.enabled'] = { config.ascii_art.enabled, 'b' },
        ['config.ascii_art.opts'] = { config.ascii_art.opts, 'table', true },
        ['config.ascii_art.text'] = {
            config.ascii_art.text,
            function(x)
                if type(x) == 'string' then
                    return true
                end
                if type(x) ~= 'table' then
                    return
                end
                for _, v in ipairs(x) do
                    return type(v) == 'string'
                end
                return true
            end,
            'string[]|string',
        },
    })
    ---@cast e string|nil
    if not ok then
        vim.notify('(starter-birthday) configuration is not valid: ' .. e, vim.log.levels.WARN)
    end
    return ok
end

---@param fst StarterBirthday.Config
---@param snd StarterBirthday.Config
---@return StarterBirthday.Config
M.merge_config = function(fst, snd)
    return vim.tbl_deep_extend('force', fst, snd)
end

--- Returns nil if invalid
---@param fst StarterBirthday.Config
---@param snd StarterBirthday.Config
---@return StarterBirthday.Config|nil
M.merge_and_validate = function(fst, snd)
    local cfg = M.merge_config(fst, snd)
    return M.validate_config(cfg) and cfg or nil
end

--- Extracts string
---@param s string|function(cfg: StarterBirthday.Config): string
---@param cfg StarterBirthday.Config
---@return string|nil
M.get_or_call = function(s, cfg)
    if type(s) == 'function' then
        return s(cfg)
    elseif type(s) == 'string' then
        return s
    end
end

return M
