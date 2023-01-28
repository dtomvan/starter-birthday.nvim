local M = {}

--- Rainbowify your birthday message (mini.starter only)
---@param rainbow boolean
---@return fun(content: table): table
M['mini.starter'] = function(rainbow)
    rainbow = rainbow == nil or StarterBirthday.config.item.rainbow and rainbow

    ---@param content {string: string, hl: string}[][]
    return function(content)
        if not rainbow then
            return content
        end

        ---@type table[][]
        local coords = MiniStarter.content_coords(content, 'item')
        for _, c in ipairs(coords) do
            ---@cast c { line: number, unit: number }
            ---@type table
            local unit = content[c.line][c.unit]
            ---@type table
            local item = unit.item
            local hl = StarterBirthday.config.item.rainbow.hl_groups

            if item.name == StarterBirthday.config.item.name then
                table.remove(content[c.line], c.unit)
                -- Go backwards to prevent collision
                for i = #item.name, 1, -1 do
                    ---@type string|nil
                    local ch = item.name:sub(i, i)
                    table.insert(content[c.line], c.unit, {
                        string = ch,
                        hl = hl[(i - 1) % #hl + 1],
                    })
                end
                table.insert(content[c.line], c.unit, { string = '', type = 'item', item = item })
            end
        end
        return content
    end
end

return M
