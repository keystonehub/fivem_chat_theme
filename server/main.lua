--- This script covers server-side functionality for the pawnshop, including dynamic pricing, item stock management,
-- and employee permissions.
-- @script server/main.lua

--- @section Dependencies

core = exports.fivem_utils:get_module('fw')
commands = exports.fivem_utils:get_module('commands')
scope = exports.fivem_utils:get_module('scope')

--- @section Local functions

--- Internal help function to get player name
-- @lfunction get_player_name
local function get_player_name(source)
    local player_name = GetPlayerName(source)
    return player_name
end

--- @section Exports

--- Intercepts default chat messages using chat exports.
if not config.disable_chats.global_chat then
    exports.chat:registerMessageHook(function(source, outMessage, hookRef)
        local message = outMessage.args[2]
        if string.sub(message, 1, 1) ~= "/" then
            hookRef.cancel()
            local player_name = get_player_name(source)
            log_message({
                chat_type = 'global_chat',
                player_name = player_name,
                message = message
            })
            TriggerClientEvent('chat:addMessage', -1, {
                template = [[
                    <div class="msg chat-message default">
                        <span><i class="fa-solid fa-globe"></i>[GLOBAL] <player_name>{0}:</player_name> {1}</span>
                    </div>
                ]],
                args = { player_name, message }
            })
        end
    end)
end

--- @section Commands

--- Allows a player to clear their own chat.
if not config.disable_commands.clear then
    commands.register('clear', nil, 'Clears your chat window.', {}, function(source, args, raw)
        TriggerClientEvent('chat:clear', source)
    end)
end

--- Allows a staff member to clear everyones chat.
if not config.disable_commands.clear_all then
    commands.register('clear_all', { 'dev' } --[[here]], 'Clears chat for all players.', {}, function(source, args, raw)
        TriggerClientEvent('chat:clear', -1)
    end)
end

--- Sends a message in local chat *(to players within the messaging players scope)*
if not config.disable_chats.local_chat then
    commands.register('local', nil, 'Send a local chat message only visible to those in range.', {{ name = 'message', help = 'The message to say' }}, function(source, args, raw)
        local message = table.concat(args, " ")
        local player_name = get_player_name(source)
        local players_in_range = scope.get_players_in_range(source, 20.0, true)
        for _, player_id in ipairs(players_in_range) do
            log_message({
                chat_type = 'local_chat',
                player_name = player_name,
                message = message
            })
            TriggerClientEvent('chat:addMessage', player_id, {
                template = [[
                    <div class="msg chat-message local">
                        <span><i class="fa-solid fa-street-view"></i>[LOCAL] <player_name>{0}:</player_name> {1}</span>
                    </div>
                ]],
                args = { player_name, message }
            })
        end
    end)
end

--- Sends a staff message to all players.
-- Uses utils user ranks for permissions.
if not config.disable_chats.staff then
    commands.register('staff', { 'dev' }, 'Send a staff message.', {{ name = 'message', help = 'The message to say' }}, function(source, args, raw)
        local message = table.concat(args, " ")
        local player_name = get_player_name(source)
        log_message({
            chat_type = 'staff',
            player_name = player_name,
            message = message
        })
        TriggerClientEvent('chat:addMessage', -1, {
            template = [[
                <div class="msg chat-message staff">
                    <span><i class="fa-solid fa-user-secret"></i>[STAFF] <player_name>{0}:</player_name> {1}</span>
                </div>
            ]],
            args = { player_name, message }
        })
    end)
end

--- Sends a message in staff only chat.
-- Uses utils user ranks for permissions.
if not config.disable_chats.staff_only then
    commands.register('staff_only', { 'dev' }, 'Send a staff only message.', {{ name = 'message', help = 'The message to say' }}, function(source, args, raw)
        local message = table.concat(args, " ")
        local player_name = get_player_name(source)
        log_message({
            chat_type = 'staff_only',
            player_name = player_name,
            message = message
        })
        TriggerClientEvent('chat:addMessage', -1, {
            template = [[
                <div class="msg chat-message staff_only">
                    <span><i class="fa-solid fa-circle-exclamation"></i>[STAFF ONLY] <player_name>{0}:</player_name> {1}</span>
                </div>
            ]],
            args = { player_name, message }
        })
    end)
end

--- Sends an advertisement message to all players
if not config.disable_chats.advert then
    commands.register('ad', nil, 'Send a local chat message only visible to those in range.', {{ name = 'message', help = 'The message to say' }}, function(source, args, raw)
        local message = table.concat(args, " ")
        local player_name = get_player_name(source)
        log_message({
            chat_type = 'adverts',
            player_name = player_name,
            message = message
        })
        TriggerClientEvent('chat:addMessage', -1, {
            template = [[
                <div class="msg chat-message advert">
                    <span><i class="fa-solid fa-rectangle-ad"></i>[AD] <player_name>{0}:</player_name> {1}</span>
                </div>
            ]],
            args = { player_name, message }
        })
    end)
end

--- Sends a police message to all players, optionally filtering by on-duty status.
if not config.disable_chats.police then
    commands.register('police', nil, 'Send a police message to all players.', {{ name = 'message', help = 'The message to say' }}, function(source, args, raw)
        local message = table.concat(args, " ")
        local player_name = get_player_name(source)
        local job_names = config.police.jobs
        local on_duty_required = config.police.on_duty_only
        if not core.player_has_job(source, job_names, on_duty_required) then
            TriggerClientEvent('chat:addMessage', source, {
                template = [[
                    <div class="msg chat-message warning">
                        <span><i class="fa-solid fa-triangle-exclamation"></i>[WARNING] Error: You dont have permission to talk in this chat or you are not on duty.</span>
                    </div>
                ]],
                args = { }
            })
            return
        end
        log_message({
            chat_type = 'police',
            player_name = player_name,
            message = message
        })
        TriggerClientEvent('chat:addMessage', -1, {
            template = [[
                <div class="msg chat-message police">
                    <span><i class="fa-solid fa-shield-halved"></i>[POLICE] <player_name>{0}:</player_name> {1}</span>
                </div>
            ]],
            args = { player_name, message }
        })
    end)
end

--- Sends a ems message to all players, optionally filtering by on-duty status.
if not config.disable_chats.ems then
    commands.register('ems', nil, 'Send a ems message to all players.', {{ name = 'message', help = 'The message to say' }}, function(source, args, raw)
        local message = table.concat(args, " ")
        local player_name = get_player_name(source)
        local job_names = config.ems.jobs
        local on_duty_required = config.ems.on_duty_only
        if not core.player_has_job(source, job_names, on_duty_required) then
            TriggerClientEvent('chat:addMessage', source, {
                template = [[
                    <div class="msg chat-message warning">
                        <span><i class="fa-solid fa-triangle-exclamation"></i>[WARNING] Error: You dont have permission to talk in this chat or you are not on duty.</span>
                    </div>
                ]],
                args = { }
            })
            return
        end
        log_message({
            chat_type = 'ems',
            player_name = player_name,
            message = message
        })
        TriggerClientEvent('chat:addMessage', -1, {
            template = [[
                <div class="msg chat-message ems">
                    <span><i class="fa-solid fa-shield-halved"></i>[EMS] <player_name>{0}:</player_name> {1}</span>
                </div>
            ]],
            args = { player_name, message }
        })
    end)
end

--- Staff can send a warning message to a specific player or all players
if not config.disable_chats.warning then
    commands.register('warn', { 'dev' }, 'Send a warning to all players or specify a player.', {{ name = 'id', help = 'Player ID (optional)' }, { name = 'message', help = 'The message to say' }}, function(source, args, raw)
        local target_id = tonumber(args[1])
        local message = table.concat(args, " ", target_id and 2 or 1)
        local player_name = get_player_name(source)
        if target_id then
            local target_name = get_player_name(target_id)
            log_message({
                chat_type = 'player_warning',
                player_name = player_name,
                target_name = target_name,
                message = message
            })
            TriggerClientEvent('chat:addMessage', target_id, {
                template = [[
                    <div class="msg chat-message warning">
                        <span><i class="fa-solid fa-triangle-exclamation"></i>[PM] from <player_name>{0}:</player_name> <player_name>{1}</player_name> {2}</span>
                    </div>
                ]],
                args = { player_name, target_name, message }
            })
        else
            log_message({
                chat_type = 'warning',
                player_name = player_name,
                message = message
            })
            TriggerClientEvent('chat:addMessage', -1, {
                template = [[
                    <div class="msg chat-message warning">
                        <span><i class="fa-solid fa-triangle-exclamation"></i>[WARNING] <player_name>{0}:</player_name> {1}</span>
                    </div>
                ]],
                args = { player_name, message }
            })
        end
    end)
end

--- Sends a private message to a specific player
if not config.disable_chats.pm then
    commands.register('pm', nil, 'Send a private message to a specific player.', {{ name = 'id', help = 'Player ID' }, { name = 'message', help = 'The message to say' }}, function(source, args, raw)
        local target_id = tonumber(args[1])
        local player_name = get_player_name(source)
        if not target_id then
            TriggerClientEvent('chat:addMessage', source, {
                template = [[
                    <div class="msg chat-message warning">
                        <span><i class="fa-solid fa-triangle-exclamation"></i>[WARNING] Error: You must specify a player ID.</span>
                    </div>
                ]],
                args = { }
            })
            return
        end
        local message = table.concat(args, " ", 2)
        local target_player_exists = GetPlayerName(target_id) ~= nil
        if target_player_exists then
            local target_name = get_player_name(target_id)
            log_message({
                chat_type = 'pm',
                player_name = player_name,
                target_name = target_name,
                message = message
            })
            TriggerClientEvent('chat:addMessage', target_id, {
                template = [[
                    <div class="msg chat-message pm">
                        <span><i class="fa-solid fa-envelope"></i>[PM] from <player_name>{0}:</player_name> {1}</span>
                    </div>
                ]],
                args = { player_name, message }
            })
            TriggerClientEvent('chat:addMessage', source, {
                template = [[
                    <div class="msg chat-message success">
                        <span><i class="fa-solid fa-check"></i>[SUCCESS] Your message was sent to {0}.</span>
                    </div>
                ]],
                args = { target_name }
            })
        else
            TriggerClientEvent('chat:addMessage', source, {
                template = [[
                    <div class="msg chat-message warning">
                        <span><i class="fa-solid fa-triangle-exclamation"></i>[WARNING] Error: No player was found for that ID.</span>
                    </div>
                ]],
                args = { }
            })
        end
    end)
end

--- Sends an trade message to all players
if not config.disable_chats.trade then
    commands.register('trade', nil, 'Send a trade chat message to all players.', {{ name = 'message', help = 'The message to say' }}, function(source, args, raw)
        local message = table.concat(args, " ")
        local player_name = get_player_name(source)
        log_message({
            chat_type = 'trade',
            player_name = player_name,
            message = message
        })
        TriggerClientEvent('chat:addMessage', -1, {
            template = [[
                <div class="msg chat-message trade">
                    <span><i class="fa-solid fa-hand-holding-hand"></i>[TRADE] <player_name>{0}:</player_name> {1}</span>
                </div>
            ]],
            args = { player_name, message }
        })
    end)
end