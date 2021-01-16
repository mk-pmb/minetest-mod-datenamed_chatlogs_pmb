-- -*- coding: utf-8, tab-width: 2 -*-

local luaLibName = ...
local luaLibPfx = (luaLibName or ''):match('^.+[%.%/]') or ''

local function retNil() return nil end

local MT = {
  settings = {
    get       = retNil,
    get_bool  = retNil,
  },
}
_G.minetest = MT

local mockApi = {
  minetest = MT,
  hooks = {},
}
function mockApi.runHook(name, ...)
  local f = mockApi.hooks[name]
  if f then return f(...) end
  print('W: runHook skip (not hooked):', name, ...)
end

local function addStubMthd(m) MT[m] = function (...) print(m, ...) end end
addStubMthd('log')
addStubMthd('debug')

local function addStubGetter(m, val)
  MT[m] = function (...)
    print(m .. ': ' .. val .. ' <- args:', ...)
    return val
  end
end
addStubGetter('get_current_modname', 'test:curmod')
addStubGetter('get_worldpath', './tmp')
addStubGetter('get_modpath', '..')


function MT.mkdir(path)
  print('mkdir', path)
  local shellCmd = 'mkdir --parents ' .. path
  -- We can trust the path because the tests use safe constant values.
  local pipe = io.popen(shellCmd, 'r')
  pipe:read('*a') -- read ALL the output
  pipe:close()
end

local function hookable(ev)
  MT['register_on_' .. ev] = function (f)
    mockApi.hooks[ev] = f
    print('hooked', ev, f)
  end
end

hookable('shutdown')
hookable('chat_message')
hookable('joinplayer')
hookable('leaveplayer')
hookable('modchannel_message')
hookable('prejoinplayer')




return mockApi
