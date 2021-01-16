-- -*- coding: utf-8, tab-width: 2 -*-

local M = { name = minetest.get_current_modname() }
M.basedir = (minetest.get_modpath(M.name) or error('get_modpath failed'))

function M.log(lv, fmt, ...)
  minetest.debug(M.name .. ' <' .. lv .. '> ' .. fmt:format(...))
end
M.log('info', 'Initializing. basedir = %q', M.basedir)
function M.doSrc(n)
  return M.dare('doSrc(' .. n .. ')', dofile,
    M.basedir .. '/src/' .. n .. '.lua')
end

function M.dare(descr, ...)
  local ok, x = pcall(...)
  if ok then return x end
  x = 'Failed to ' .. descr .. ': ' .. x
  minetest.log('error', M.name .. ': ' .. x)
  error(x)
end

M.doSrc('setup')(minetest, M)
