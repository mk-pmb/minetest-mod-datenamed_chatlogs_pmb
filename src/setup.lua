-- -*- coding: utf-8, tab-width: 2 -*-
return function (minetest, M)

  M.logger = M.doSrc('makeFileLogger')({
    pathPre = minetest.get_worldpath() .. '/chatlogs/',
    pathTpl = minetest.settings:get(M.name .. '.pathtpl'),
    mkpathFunc = minetest.mkdir,
    debugPrint = minetest.debug,
  })
  print('makeWriterWithPrefixArg:', M.logger.makeWriterWithPrefixArg)

  minetest.register_on_shutdown(function (...)
    M.logger:write('shutdown', ...)
    M.logger:cleanup()
  end)

  local function regEv(e)
    (minetest['register_on_' .. e] or error('No API to register event: ' .. e)
    )(M.logger:makeWriterWithPrefixArg(e))
  end
  regEv('chat_message')
  regEv('joinplayer')
  regEv('leaveplayer')
  regEv('modchannel_message')
  regEv('prejoinplayer')

  M.log('info', 'Ready. Current destination would be: %q',
    M.logger:calcAbsDest())

end
