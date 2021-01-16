-- -*- coding: utf-8, tab-width: 2 -*-
return function (M)

  local makeLogger = M.doSrc('makeLogger')
  M.logger = makeLogger({
    pathPre = minetest.get_worldpath() .. '/',
    pathTpl = (minetest.settings:get(M.name .. '.pathtpl')
      or 'chatlogs/%Y/%m/%y%m%d.txt'),
  })

end
