local mp = require 'mp'
local utils = require 'mp.utils'

local tmp_thumbnail_path = "/tmp/mpv_thumb.jpg"
local default_icon_path = "/usr/share/icons/hicolor/32x32/apps/mpv.png"

mp.observe_property("media-title", "string", function(name, value)
  if not value then return end

  local thumb_url = mp.get_property("metadata/by-key/thumbnail")
  local icon_path = default_icon_path

  if thumb_url then
    local ret = utils.subprocess({
      cancellable = false,
      args = {"curl", "-s", "-L", "-o", tmp_thumbnail_path, thumb_url}
    })

    if ret.status == 0 then
      icon_path = tmp_thumbnail_path
    end
  end
 
  local notify_args = {"notify-send","-i", icon_path, "Now Playing", value}

  utils.subprocess({
    cancellable = false,
    args = notify_args
  })
end)
