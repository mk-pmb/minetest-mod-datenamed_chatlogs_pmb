-- -*- coding: utf-8, tab-width: 2 -*-

local luaLibName = ...
local luaLibPfx = (luaLibName or ''):match('^.+[%.%/]') or ''

local mockApi = require(luaLibPfx .. 'mockApi')

dofile('../init.lua')

mockApi.runHook('joinplayer', 'Bernd')
mockApi.runHook('chat_message', 'Bernd', 'hi!')
mockApi.runHook('leaveplayer', 'Bernd')


mockApi.runHook('shutdown')
