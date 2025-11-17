local wezterm = require 'wezterm'
local act = wezterm.action

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Цветовая палитра с зелёным акцентом
local colors = {
  foreground = "#C0FFC0",
  background = "#001a0d",
  cursor_bg = "#66FF99",
  cursor_border = "#66FF99",
  cursor_fg = "#0A0A0F",
  selection_bg = "#66FF99",
  selection_fg = "#0A0A0F",
  ansi = {
    "#1E1E2E", "#FF007C", "#00FF9F", "#FFD500",
    "#00BFFF", "#B400FF", "#00FFFF", "#C0C0C0",
  },
  brights = {
    "#2E2E3E", "#FF3399", "#33FFB2", "#FFE066",
    "#33CFFF", "#CC66FF", "#66FFFF", "#FFFFFF",
  },
}

-- Настройка таббара с AMOLED-чёрным фоном и зелёным акцентом
colors.tab_bar = {
  background = "#000000",
  active_tab = {
    bg_color = "#66FF99",
    fg_color = "#001a0d",
    intensity = "Bold",
  },
  inactive_tab = {
    bg_color = "#000000",
    fg_color = "#448866",
  },
  inactive_tab_hover = {
    bg_color = "#003322",
    fg_color = "#66FF99",
  },
  new_tab = {
    bg_color = "#000000",
    fg_color = "#66FF99",
  },
  new_tab_hover = {
    bg_color = "#001a0d",
    fg_color = "#66FF99",
  },
}

-- Основные настройки окна
config.font = wezterm.font("JetBrains Mono")
config.font_size = 14.0
config.cell_width = 0.95
config.window_background_opacity = 0.85
config.text_background_opacity = 1.0
config.window_decorations = "RESIZE"
config.window_close_confirmation = "NeverPrompt"
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.default_cursor_style = 'BlinkingUnderline'
config.cursor_blink_rate = 900
config.colors = colors
config.enable_scroll_bar = false
config.scrollback_lines = 5000
config.enable_csi_u_key_encoding = false
config.default_prog = { "wsl.exe" }

-- Настройка лидер-клавиши: ctrl + `
config.leader = { key = "`", mods = "CTRL", timeout_milliseconds = 5000 }

-- Горячие клавиши
config.keys = {
  -- Новое окно
  { mods = "LEADER", key = "n", action = act.SpawnTab "CurrentPaneDomain" },
  -- Закрыть окно
  { mods = "LEADER", key = "q", action = act.CloseCurrentPane { confirm = true } },
  -- Предыдущее окно
  { mods = "LEADER", key = "b", action = act.ActivateTabRelative(-1) },
  -- Следующее окно
  { mods = "LEADER", key = "f", action = act.ActivateTabRelative(1) },
  -- Сплит окон
  { mods = "LEADER", key = "v", action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
  { mods = "LEADER", key = "h", action = act.SplitVertical { domain = "CurrentPaneDomain" } },
  -- Перемещение между окнами
  { mods = "LEADER", key = "k", action = act.ActivatePaneDirection "Down" },
  { mods = "LEADER", key = "j", action = act.ActivatePaneDirection "Up" },
  { mods = "LEADER", key = ";", action = act.ActivatePaneDirection "Right" },
  { mods = "LEADER", key = "l", action = act.ActivatePaneDirection "Left" },
  -- Ресайз окон
  { mods = "LEADER", key = "LeftArrow", action = act.AdjustPaneSize { "Left", 5 } },
  { mods = "LEADER", key = "RightArrow", action = act.AdjustPaneSize { "Right", 5 } },
  { mods = "LEADER", key = "DownArrow", action = act.AdjustPaneSize { "Down", 5 } },
  { mods = "LEADER", key = "UpArrow", action = act.AdjustPaneSize { "Up", 5 } },
  -- Копировать/вставить
  { key = "c", mods = "CTRL", action = act.CopyTo("Clipboard") },
  { key = "v", mods = "CTRL", action = act.PasteFrom("Clipboard") },
  -- Полноэкранный режим
  { key = "F11", mods = "NONE", action = act.ToggleFullScreen },
}

for i = 0, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = "LEADER",
    action = act.ActivateTab(i),
  })
end

-- Настройка таббара
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = true

-- Индикатор активности лидера
wezterm.on("update-status", function(window, _)
  if window:leader_is_active() then
    window:set_left_status(wezterm.format {
      { Background = { Color = "#66FF99" } },
      { Foreground = { Color = "#001a0d" } },
      { Text = " 🦉" },
    })
  else
    window:set_left_status("")
  end
end)

-- Установка максимального FPS и плавности анимации
config.max_fps = 240
config.animation_fps = 240

return config
  