--[[
    Smart Selector
    Copyright (C) 2020  lyserenity <https://github.com/lyserenity>
    Copyright (C) 2023  Xuesong Peng <pengxuesong.cn@gmail.com>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
--]]

local semicolon = KeyEvent(";") --("semicolon")
local apostrophe = KeyEvent("'") --("apostrophe")
local kRejected = 0 -- do the OS default processing
local kAccepted = 1 -- consume it
local kNoop     = 2 -- leave it to other processors

local function page_start_index(engine)
    local context = engine.context
    local page_size= engine.schema.page_size
    local segment= context.composition:back()
    if not segment then return -1 end
    return (segment.selected_index // page_size) * page_size 
end

local function processor(key_event, env)
    if key_event:release() or key_event:alt() or key_event:super() then
        return kNoop
    end
    local context = env.engine.context
    if not context:has_menu() then return kNoop end
    local pg_first_index =  page_start_index(env.engine)
    if pg_first_index < 0 then return kNoop end
    
    if key_event:eq(semicolon) then
      for _,v in ipairs{1,0} do
        if context:select(pg_first_index + v) then return kAccepted end
      end
    elseif key_event:eq(apostrophe) then
      for _,v in ipairs{2,1,0} do
        if context:select(pg_first_index + v) then return kAccepted end
      end
    else
      return kNoop
    end
    return kNoop
end

return { func = processor }
