---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by heyqule.
--- DateTime: 12/23/2020 8:27 PM
---

local String = require('__stdlib__/stdlib/utils/string')
local Math = require('__stdlib__/stdlib/utils/math')
local Table = require('__stdlib__/stdlib/utils/table')

local get_unit = function(unit_name)
    local current_tier = remote.call('enemy_race_manager', 'get_race_tier', MOD_NAME)
    return unit_name[current_tier][Math.random(#unit_name[current_tier])]
end

local get_overlord_droppable_unit = function()
    local unit_name = {
        { 'zergling', 'hydralisk' },
        { 'hydralisk', 'lurker' },
        { 'hydralisk', 'lurker', 'infested' },
    }
    return get_unit(unit_name)
end

local get_drone_buildable_turrets = function()
    local unit_name = {
        { 'spore_colony' },
        { 'spore_colony' },
        { 'spore_colony', 'nydus' },
    }
    return get_unit(unit_name)
end

local CustomAttacks = {}

--effect_id :: string: The effect_id specified in the trigger effect.
--surface_index :: uint: The surface the effect happened on.
--source_position :: Position (optional)
--source_entity :: LuaEntity (optional)
--target_position :: Position (optional)
--target_entity :: LuaEntity (optional)
--https://lua-api.factorio.com/latest/LuaSurface.html#LuaSurface.create_entity
function CustomAttacks.process_overlord(event)
    local surface = game.surfaces[event.surface_index]
    local nameToken = String.split(event.source_entity.name, '/')
    local level = nameToken[3]
    local position = event.source_position
    position.x = position.x + 2

    local unit_name = MOD_NAME .. '/' .. get_overlord_droppable_unit() .. '/' .. level

    if not surface.can_place_entity({ name = unit_name, position = position }) then
        position = surface.find_non_colliding_position(unit_name, event.source_position, 10, 2, true)
    end

    if position then
        surface.create_entity({ name = unit_name, position = position, force = event.source_entity.force })
    end
end

function CustomAttacks.process_drone(event)
    local surface = game.surfaces[event.surface_index]
    local nameToken = String.split(event.source_entity.name, '/')
    local level = nameToken[3]
    local position = event.source_position

    local unit_name = MOD_NAME .. '/' .. get_drone_buildable_turrets() .. '/' .. level

    if not surface.can_place_entity({ name = unit_name, position = position }) then
        position = surface.find_non_colliding_position(unit_name, event.source_position, 10, 2, true)
    end

    if position then
        surface.create_entity({ name = unit_name, position = position, force = event.source_entity.force })
        event.source_entity.damage(1000000, 'neutral', 'self')
    end
end

return CustomAttacks