--- The default configuration for this plugin
---
---@alias StarterBirthday.Formatter nil|string|fun(config: StarterBirthday.Config): string|nil
---
---@class StarterBirthday.Config
---
---@field date StarterBirthday.Config.Date
---@field username string|nil
---@field locale string|nil
---@field demo boolean
---@field item StarterBirthday.Config.Item
---@field ascii_art StarterBirthday.Config.AsciiArt

---@class StarterBirthday.Config.Date
---@field day number|nil
---@field month number|nil

---@class StarterBirthday.Config.Item
---@field name StarterBirthday.Formatter
---@field section StarterBirthday.Formatter
---@field rainbow StarterBirthday.Config.Rainbow
---
---@class StarterBirthday.Config.Rainbow
---@field enabled boolean
---@field hl_groups string[]

---@class StarterBirthday.Config.AsciiArt
---@field enabled boolean
---@field text string[]|string
---@field opts table<string, any|nil>

---@type StarterBirthday.Config
return {
    date = {
        day = nil,
        month = nil,
    },
    username = os.getenv 'USER',
    locale = nil,
    demo = false,
    item = {
        name = 'Happy Birthday!',
        section = require('starter-birthday').section_name,
        rainbow = {
            enabled = true,
            hl_groups = {
                'Error',
                'Float',
                'WarningMsg',
                'String',
                'Function',
                'Exception',
            },
        },
    },
    ascii_art = {
        enabled = true,
        text = require 'starter-birthday.ascii_art',
        opts = {
            filetype = 'text',
            number = false,
            relativenumber = false,
            cursorline = false,
        },
    },
}
