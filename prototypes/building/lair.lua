---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by heyqule.
--- DateTime: 12/21/2020 4:42 PM
---

require('__stdlib__/stdlib/utils/defines/time')

local ERM_UnitHelper = require('__enemyracemanager__/lib/unit_helper')
local ERM_UnitTint = require('__enemyracemanager__/lib/unit_tint')
local ERM_DebugHelper = require('__enemyracemanager__/lib/debug_helper')
local ZergSound = require('__erm_zerg__/prototypes/sound')

local enemy_autoplace = require("__enemyracemanager__/lib/enemy-autoplace-utils")
local name = 'lair'

-- Hitpoints
local health_multiplier = settings.startup["enemyracemanager-level-multipliers"].value
local hitpoint = 1800
local max_hitpoint_multiplier = settings.startup["enemyracemanager-max-hitpoint-multipliers"].value

local resistance_mutiplier = settings.startup["enemyracemanager-level-multipliers"].value
-- Handles acid and poison resistance
local base_acid_resistance = 25
local incremental_acid_resistance = 55
-- Handles physical resistance
local base_physical_resistance = 0
local incremental_physical_resistance = 80
-- Handles fire and explosive resistance
local base_fire_resistance = 0
local incremental_fire_resistance = 80
-- Handles laser and electric resistance
local base_electric_resistance = 0
local incremental_electric_resistance = 80
-- Handles cold resistance
local base_cold_resistance = 15
local incremental_cold_resistance = 65

-- Animation Settings
local unit_scale = 2

local pollution_absorption_absolute = 20
local spawning_cooldown = { 600, 300 }
local spawning_radius = 10
local max_count_of_owned_units = 5
local max_friends_around_to_spawn = 3
local spawn_table = function(level)
    local res = {}
    --Tire 1
    res[1] = { MOD_NAME .. '/zergling/' .. level, { { 0.0, 0.7 }, { 0.2, 0.7 }, { 0.4, 0.2 }, { 0.6, 0.1 }, { 0.8, 0.2 } } }
    res[2] = { MOD_NAME .. '/hydralisk/' .. level, { { 0.0, 0.2 }, { 0.2, 0.2 }, { 0.4, 0.2 }, { 0.6, 0.1 }, { 0.8, 0.2 } } }
    res[3] = { MOD_NAME .. '/mutalisk/' .. level, { { 0.0, 0.1 }, { 0.2, 0.1 }, { 0.4, 0.2 }, { 0.6, 0.1 }, { 0.8, 0.1 } } }
    --Tire 2
    res[4] = { MOD_NAME .. '/lurker/' .. level, { { 0.0, 0.0 }, { 0.2, 0.0 }, { 0.4, 0.1 }, { 0.6, 0.2 }, { 0.8, 0.1 } } }
    res[5] = { MOD_NAME .. '/guardian/' .. level, { { 0.0, 0.0 }, { 0.2, 0.0 }, { 0.4, 0.1 }, { 0.6, 0.15 }, { 0.8, 0.15 } } }
    res[6] = { MOD_NAME .. '/devourer/' .. level, { { 0.0, 0.0 }, { 0.2, 0.0 }, { 0.4, 0.1 }, { 0.6, 0.2 }, { 0.8, 0.15 } } }
    res[7] = { MOD_NAME .. '/overlord/' .. level, { { 0.0, 0.0 }, { 0.2, 0.0 }, { 0.4, 0.1 }, { 0.6, 0.15 }, { 0.8, 0.1 } } }
    return res
end

local collision_box = { { -3, -3.5 }, { 3.2, 3 } }
local map_generator_bounding_box = { { -4, -4 }, { 4, 4 } }
local selection_box = { { -3, -3.5 }, { 3.2, 3 } }

function ErmZerg.make_lair(level)
    level = level or 1

    data:extend({
        {
            type = "unit-spawner",
            name = MOD_NAME .. '/' .. name .. '/' .. level,
            localised_name = { 'entity-name.' .. MOD_NAME .. '/' .. name, level },
            icon = "__erm_zerg__/graphics/entity/icons/buildings/advisor.png",
            icon_size = 64,
            flags = { "placeable-player", "placeable-enemy" },
            max_health = ERM_UnitHelper.get_health(hitpoint, hitpoint * max_hitpoint_multiplier, health_multiplier, level),
            order = MOD_NAME .. "-z-hydra",
            subgroup = "enemies",
            working_sound = ZergSound.building_working_sound(name, 1),
            dying_sound = ZergSound.building_dying_sound(1),
            resistances = {
                { type = "acid", percent = ERM_UnitHelper.get_resistance(base_acid_resistance, incremental_acid_resistance, resistance_mutiplier, level) },
                { type = "poison", percent = ERM_UnitHelper.get_resistance(base_acid_resistance, incremental_acid_resistance, resistance_mutiplier, level) },
                { type = "physical", percent = ERM_UnitHelper.get_resistance(base_physical_resistance, incremental_physical_resistance, resistance_mutiplier, level) },
                { type = "fire", percent = ERM_UnitHelper.get_resistance(base_fire_resistance, incremental_fire_resistance, resistance_mutiplier, level) },
                { type = "explosion", percent = ERM_UnitHelper.get_resistance(base_fire_resistance, incremental_fire_resistance, resistance_mutiplier, level) },
                { type = "laser", percent = ERM_UnitHelper.get_resistance(base_electric_resistance, incremental_electric_resistance, resistance_mutiplier, level) },
                { type = "electric", percent = ERM_UnitHelper.get_resistance(base_electric_resistance, incremental_electric_resistance, resistance_mutiplier, level) },
                { type = "cold", percent = ERM_UnitHelper.get_resistance(base_cold_resistance, incremental_cold_resistance, resistance_mutiplier, level) }
            },
            healing_per_tick = ERM_UnitHelper.get_healing(hitpoint, max_hitpoint_multiplier, health_multiplier, level),
            collision_box = collision_box,
            map_generator_bounding_box = map_generator_bounding_box,
            selection_box = selection_box,
            pollution_absorption_absolute = pollution_absorption_absolute,
            pollution_absorption_proportional = 0.01,
            corpse = "zerg-large-base-corpse",
            dying_explosion = "zerg-building-explosion",
            max_count_of_owned_units = max_count_of_owned_units,
            max_friends_around_to_spawn = max_friends_around_to_spawn,
            animations = {
                layers = {
                    {
                        filename = "__erm_zerg__/graphics/entity/buildings/" .. name .. "/" .. name .. ".png",
                        width = 192,
                        height = 160,
                        frame_count = 5,
                        animation_speed = 0.18,
                        direction_count = 1,
                        run_mode = "forward-then-backward",
                        scale = unit_scale
                    }
                }
            },
            integration = {
                layers = {
                    {
                        filename = "__erm_zerg__/graphics/entity/buildings/" .. name .. "/" .. name .. ".png",
                        variation_count = 1,
                        width = 192,
                        height = 160,
                        frame_count = 1,
                        line_length = 1,
                        scale = unit_scale
                    },
                    {
                        filename = "__erm_zerg__/graphics/entity/buildings/" .. name .. "/" .. name .. ".png",
                        variation_count = 1,
                        width = 192,
                        height = 160,
                        frame_count = 1,
                        line_length = 1,
                        draw_as_shadow = true,
                        shift = { 0.5, 0.1 },
                        scale = unit_scale
                    },
                }
            },
            result_units = spawn_table(level),
            -- With zero evolution the spawn rate is 6 seconds, with max evolution it is 2.5 seconds
            spawning_cooldown = spawning_cooldown,
            spawning_radius = spawning_radius,
            spawning_spacing = 3,
            max_spawn_shift = 0,
            max_richness_for_spawn_shift = 100,
            -- distance_factor used to be 1, but Twinsen says:
            -- "The number or spitter spwners should be roughly equal to the number of biter spawners(regardless of difficulty)."
            -- (2018-12-07)
            autoplace = enemy_autoplace.enemy_spawner_autoplace(0, FORCE_NAME),
            call_for_help_radius = 80,
            spawn_decorations_on_expansion = true,
            spawn_decoration = {
                {
                    decorative = "light-mud-decal",
                    spawn_min = 0,
                    spawn_max = 2,
                    spawn_min_radius = 2,
                    spawn_max_radius = 5
                },
                {
                    decorative = "dark-mud-decal",
                    spawn_min = 0,
                    spawn_max = 3,
                    spawn_min_radius = 2,
                    spawn_max_radius = 6
                },
                {
                    decorative = "enemy-decal",
                    spawn_min = 3,
                    spawn_max = 5,
                    spawn_min_radius = 2,
                    spawn_max_radius = 7
                },
                {
                    decorative = "enemy-decal-transparent",
                    spawn_min = 4,
                    spawn_max = 20,
                    spawn_min_radius = 2,
                    spawn_max_radius = 14,
                    radius_curve = 0.9
                },
                {
                    decorative = "muddy-stump",
                    spawn_min = 2,
                    spawn_max = 5,
                    spawn_min_radius = 3,
                    spawn_max_radius = 6
                },
                {
                    decorative = "red-croton",
                    spawn_min = 2,
                    spawn_max = 8,
                    spawn_min_radius = 3,
                    spawn_max_radius = 6
                },
                {
                    decorative = "red-pita",
                    spawn_min = 1,
                    spawn_max = 5,
                    spawn_min_radius = 3,
                    spawn_max_radius = 6
                },
                {
                    decorative = "lichen-decal",
                    spawn_min = 1,
                    spawn_max = 2,
                    spawn_min_radius = 2,
                    spawn_max_radius = 7
                }
            }
        }
    })
end