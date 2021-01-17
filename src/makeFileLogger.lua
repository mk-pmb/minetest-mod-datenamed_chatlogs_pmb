-- -*- coding: utf-8, tab-width: 2 -*-

local api = {}
local mtApi = { __index = function (_, k) return rawget(api, k) end }

local function makeFileLogger(opt)
  local L = {
    destFh = nil,
    destPath = nil,
  }
  local function cfg(k, d)
    L[k] = (opt[k] or d or error('Missing value for option ' .. k))
  end
  cfg('pathPre', '')
  cfg('pathTpl', '%Y/%m/%y%m%d.txt')
  cfg('mkpathFunc')
  cfg('debugPrint', print)
  setmetatable(L, mtApi)
  return L
end


function api.fail(L, fmt, ...)
  local msg = ((L.errPfx or 'fileLogger with no errPfx') .. ': '
    .. fmt:format(...))
  L.debugPrint(msg)
  error(msg)
end


function api.closeLog(L)
  if L.destFh then L.destFh:close() end
  L.destFh = nil
end


function api.cleanup(L)
  L:closeLog()
end


function api.writeDestLine(L, ln)
  local ok, err = pcall(L.destFh.write, L.destFh, ln .. '\n')
  if ok then return end
  L:fail('Cannot append to logfile: %q; msg: %q', err, ln)
end


function api.calcAbsDest(L, now)
  return L.pathPre .. os.date(L.pathTpl, now)
end


function api.checkReopenDest(L, now)
  local absDest = L:calcAbsDest(now)
  if L.destFh and (L.destPath == absDest) then return end
  L:closeLog()
  local destDir = (absDest:match('.+[%\\%/]')
    or error('Cannot determine parent directory for logfile', absDest))
  L.mkpathFunc(destDir)
  local ok, res = pcall(io.open, absDest, 'a')
  if not ok then error('Failed (pcall) to open logfile', absDest, res) end
  if not res then
    error('Failed (bad result) to open logfile', res, absDest)
  end
  L.destFh = res
  L.destPath = absDest
end


function api.defuseArgs(...)
  local a = { ... }
  local o = {}
  local x, t, s
  for i = 1, table.maxn(a) do
    x = a[i]
    t = type(x)
    s = ((t == 'string')
      or (t == 'number')
      )
    if not s then x = '<' .. t .. '>' end
    o[i] = x
  end
  return o
end


function api.write(L, ...)
  local now = os.time()
  L:checkReopenDest(now)
  if not L.destFh then return end
  local msg = table.concat(L.defuseArgs(...), '\t')
  msg = now .. os.date(' %F %T', now) .. '\t' .. msg
  local ok, err = pcall(api.writeDestLine, L, msg)
  L.destFh:flush()
  return nil
end


function api.makeWriterWithPrefixArg(L, a)
  return function (...) L:write(a, ...) end
end


function api.makeWriterWithPrefixStr(L, s)
  return function (m, ...) L:write(m .. s, ...) end
end










return makeFileLogger
