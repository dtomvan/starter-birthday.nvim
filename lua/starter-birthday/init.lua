---@class StarterBirthday
local M = {}

M.gen_hook = require 'starter-birthday.gen_hook'
M.items = require 'starter-birthday.items'
M.util = require 'starter-birthday.util'

M.section_name = function(config)
    ---@type string
    local th
    local day = tostring(config.date.day)
    if day[#day] == 1 then
        th = 'st'
    elseif day[#day] == 2 then
        th = 'nd'
    elseif day[#day] == 3 then
        th = 'rd'
    else
        th = 'th'
    end
    -- 30.44 days (avg length of a month over 48 months) in seconds
    local month_to_seconds = 2629743
    if config.locale then
        os.setlocale(config.locale, 'time')
    end
    local months = os.date('%B', (config.date.month - 1) * month_to_seconds)
    return string.format("It's the %d%s of %s, %s!", day, th, months, config.username)
end

M.setup = function(config)
    -- Used to have consistent behaviour when reconfiguring
    ---@diagnostic disable-next-line: no-unknown
    package.loaded['starter-birthday.util'] = nil
    local def = require 'starter-birthday.config'
    local cfg = M.util.merge_config(def, config)
    M.config = M.util.validate_config(cfg, true) and cfg or def
end

StarterBirthday = M

return StarterBirthday
