-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}

-- Equivalent to POSIX basename(3)
-- Given "/foo/bar" returns "bar"
-- Given "c:\\foo\\bar" returns "bar"
function basename(s)
    return string.gsub(s, '(.*[/\\])(.*)', '%2')
end

wezterm.on(
    'format-tab-title',
    function(tab, tabs, panes, config, hover, max_width)
        local proc = tab.active_pane.foreground_process_name

        return tostring(tab.tab_index) .. ": " .. basename(proc)
    end
)

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.show_new_tab_button_in_tab_bar = false

local sessionizer = wezterm.plugin.require "https://github.com/mikkasendke/sessionizer.wezterm"

local function replace_home(repl, titles, opts)
    local function ret()
        local to_sort = opts.toSort or true
        local title_pairs = titles()
        for i = 1,#title_pairs do
            title_pairs[i].label = string.gsub(title_pairs[i].label, "/home/%w+", repl)
        end
        if to_sort then
            table.sort(title_pairs, function(a, b)
                return string.len(a.label) < string.len(b.label)
            end)
        end
        return title_pairs
    end
    if opts.refresh then
        return ret
    else
        return ret()
    end
end

local my_schema = {
    replace_home("!: ~", sessionizer.AllActiveWorkspaces {}, { toSort = true, refresh = true }),
    replace_home("~", sessionizer.FdSearch(wezterm.home_dir .. "/avt"), {}),
    replace_home("~", sessionizer.FdSearch(wezterm.home_dir .. "/projects"), {}),
    replace_home("~", sessionizer.FdSearch(wezterm.home_dir .. "/.config"), {}),
    replace_home("~", sessionizer.FdSearch(wezterm.home_dir .. "/Desktop"), {}),
    sessionizer.DefaultWorkspace {},
}

config.keys = {
    { key = "S", mods = "SUPER", action = sessionizer.show(my_schema) },
    -- ... other keybindings ...
}

config.colors = {
    foreground = 'white',
}

config.warn_about_missing_glyphs = false
config.force_reverse_video_cursor = true

-- Finally, return the configuration to wezterm:
return config
