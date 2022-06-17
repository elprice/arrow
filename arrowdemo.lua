_addon.name = 'arrowdemo'
_addon.author = 'Eikken'
_addon.version = '0'
_addon.commands = {'ad'}
require('lists')

local arrowmodule = require('arrow')

local chatmode = 15
local stop = false

function command_helper(cmd, ...)

    local args = L{...}

    if cmd == 'pointat' then

        mob_name = list.concat(args, ' ')
        if mob_name == '' then
            windower.add_to_chat(chatmode, 'ArrowDemo :: No mob name provided. Not running.')
            return
        end

        local mob = windower.ffxi.get_mob_by_name(mob_name)
        while mob and not stop do
            arrowmodule.update(mob.name,mob.x,mob.y)
            mob = windower.ffxi.get_mob_by_name(mob_name)
            coroutine.sleep(0.2)
        end   

        windower.add_to_chat(chatmode, 'ArrowDemo :: '..mob_name..' not found or gone or stop signaled. Stopping.')
        arrowmodule.hide()
    elseif cmd == 'stop' then
        stop = true
    end
end

windower.register_event('addon command', command_helper)
windower.register_event('load', arrowmodule.init)
windower.register_event('unload', arrowmodule.destroy)
