--
-- Created by IntelliJ IDEA.
-- User: heyqule
-- Date: 12/20/2020
-- Time: 5:04 PM
-- To change this template use File | Settings | File Templates.
--

local Game = require('__stdlib__/stdlib/game')

local ErmConfig = require('__enemyracemanager__/lib/global_config')
local ForceHelper = require('__enemyracemanager__/lib/helper/force_helper')

local Event = require('__stdlib__/stdlib/event/event')
local String = require('__stdlib__/stdlib/utils/string')
local CustomAttacks = require('__erm_zerg__/prototypes/custom_attacks')

require('__erm_zerg__/global')
-- Constants


local createRace = function()
    local force = game.forces[FORCE_NAME]
    if not force then
        force = game.create_force(FORCE_NAME)
    end

    force.ai_controllable = true;
    force.disable_research()
    force.friendly_fire = false;

    ForceHelper.set_friends(game, FORCE_NAME)
end

local addRaceSettings = function()
    if remote.call('enemy_race_manager', 'get_race', MOD_NAME) then
        return
    end
    local race_settings = {
        race = MOD_NAME,
        version = MOD_VERSION,
        level = 1, -- Race level
        tier = 1, -- Race tier
        evolution_point = 0,
        evolution_base_point = 0,
        angry_meter = 0, -- Build by killing their force (Spawner = 20, turrets = 10)
        send_attack_threshold = 2000, -- When threshold reach, sends attack to the base
        send_attack_threshold_deviation = 0.2,
        next_attack_threshold = 0, -- Used by system to calculate next move
        units = {
            { 'zergling', 'hydralisk', 'mutalisk' },
            { 'overlord', 'devourer', 'drone' },
            { 'guardian','ultralisk', 'queen', 'defiler' },
        },
        current_units_tier = {},
        turrets = {
            { 'sunker_colony', 'spore_colony' },
            {},
            {},
        },
        current_turrets_tier = {},
        command_centers = {
            { 'hatchery' },
            { 'lair' },
            { 'hive' }
        },
        current_command_centers_tier = {},
        support_structures = {
            { 'spawning_pool', 'hydraden', 'spire', 'chamber' },
            { 'greater_spire' },
            { 'ultralisk_cavern', 'queen_nest', 'defiler_mound', 'nyduspit' },
        },
        current_support_structures_tier = {},
    }

    race_settings.current_units_tier = race_settings.units[1]
    race_settings.current_turrets_tier = race_settings.turrets[1]
    race_settings.current_command_centers_tier = race_settings.command_centers[1]
    race_settings.current_support_structures_tier = race_settings.support_structures[1]

    remote.call('enemy_race_manager', 'register_race', race_settings)
end

Event.on_init(function(event)
    createRace()
    addRaceSettings()
end)

Event.on_load(function(event)
end)

Event.on_configuration_changed(function(event)
    createRace()

    -- Mod Compatibility Upgrade for race settings
    Event.dispatch({
        name = Event.get_event_name(ErmConfig.RACE_SETTING_UPDATE), affected_race = MOD_NAME })
end)

Event.register(defines.events.on_script_trigger_effect, function(event)
    if not event.source_entity then
        return
    end

    if event.effect_id == OVERLORD_ATTACK then
        CustomAttacks.process_overlord(event)
    elseif event.effect_id == DRONE_ATTACK then
        CustomAttacks.process_drone(event)
    elseif event.effect_id == INFESTED_ATTACK then
        CustomAttacks.process_infested(event)
    end
end)



