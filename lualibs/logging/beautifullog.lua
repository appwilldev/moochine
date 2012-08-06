-------------------------------------------------------------------------------
-- @author lilydjwg <lilydjwg@gmail.com>
-- @copyright GPLv3
-- vim:se sw=2:
-------------------------------------------------------------------------------

require "logging"

local LEVEL_PREFIX = {
  [logging.DEBUG] = '\27[34m[D',
  [logging.INFO]  = '\27[32m[I',
  [logging.WARN]  = '\27[33m[W',
  [logging.ERROR] = '\27[31m[E',
  [logging.FATAL] = '\27[31m[F',
}

function logging.beautifullog(filename, funclevel)

  if type(filename) ~= "string" then
    filename = "/dev/stderr"
  end

  local f = io.open(filename, "a")
  if not f then
    return nil, string.format("file `%s' could not be opened for writing", filename)
  end
  f:setvbuf("line")

  return logging.new(function(self, level, message)
    local date = os.date("%m-%d %H:%M:%S")
    local frame = debug.getinfo(funclevel or 4)
    local s = string.format('%s %s %s:%d]\27[m %s\n',
      LEVEL_PREFIX[level], date,
      string.gsub(frame.short_src, '%.lua$', ''),
      frame.currentline,
      message
    )
    f:write(s)
    return true
  end)
end
