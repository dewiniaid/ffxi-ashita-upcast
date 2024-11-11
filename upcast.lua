addon.name      = 'Upcast';
addon.author    = 'Dewin';
addon.version   = '1.0';
addon.desc      = 'Automatically cast the highest currently known tier of the specified spell.';
addon.link      = 'https://github.com/dewiniaid/ashita-upcast'  -- THIS LINK DOES NOT EXIST YET

require('common');
local chat = require('chat');

local spellData = require('spelldata')

local function CheckLevels(resource)
    local playMgr = AshitaCore:GetMemoryManager():GetPlayer();
    local mainJob = playMgr:GetMainJob();
    local mainJobLevel = playMgr:GetMainJobLevel();
    local subJob = playMgr:GetSubJob();
    local subJobLevel = playMgr:GetSubJobLevel();

    local jobMask = resource.JobPointMask;
    local levelRequired = resource.LevelRequired;

    if bit.band(bit.rshift(jobMask, mainJob), 1) == 1 then
        return (mainJobLevel == 99); --Assume player knows JP spells if 99
    elseif (levelRequired[mainJob + 1] ~= -1) and (mainJobLevel >= levelRequired[mainJob + 1]) then
        return true;
    end

    if bit.band(bit.rshift(jobMask, subJob), 1) ~= 1 then
        local level = levelRequired[subJob + 1];        
        return (level ~= -1) and (subJobLevel >= level);
    end

    return false;
end

local function debug(msg)
    -- print(chat.header('Upcast') .. chat.message(msg))
end

local function has_bit(a, b)
    return bit.band(a, b) ~= 0
end

local function IsValidTarget(spell)
    -- Heavily adapted from Shorthand:
    -- https://github.com/ThornyFFXI/Shorthand/blob/main/helpers.cpp#L191
    local index = AshitaCore:GetMemoryManager():GetTarget():GetTargetIndex(0)
    debug("index=" .. (index or '(nil)'))
    if not index then
        return false
    end
    local myIndex = AshitaCore:GetMemoryManager():GetParty():GetMemberTargetIndex(0)
    debug("myIndex=" .. (myIndex or '(nil)'));

    if (index == myIndex) then  -- No sensible replacement if targeting yourself
        return true
    end

    local targets = spell.Targets
    debug("targets=" .. (targets or '(nil)'));
    local entity = AshitaCore:GetMemoryManager():GetEntity()
    debug("entity name=" .. (entity:GetName(index) or '(nil)'))
    if not entity:GetRawEntity(index) then
        debug("raw entity not found")
        return false
    end
    local rflags = entity:GetRenderFlags0(index)
    debug("rflags=" .. (rflags or '(nil)'));
    if not has_bit(rflags, 0x200) then
        debug("render flags lacks 0x200")
        return false
    end
    if has_bit(rflags, 0x4000) then
        debug("render flags has 0x4000")
        return false
    end
    local myAllegiance = entity:GetBallistaFlags(myIndex)
    local flags = entity:GetSpawnFlags(index)
    local allegiance = entity:GetBallistaFlags(index)
    local friendly = (allegiance == myAllegeiance)
    debug("flags=" .. (flags or '(nil)'));
    debug("myAllegiance=" .. (myAllegiance or '(nil)'));
    debug("allegiance=" .. (allegiance or '(nil)'));
    debug("friendly=" .. (friendly and 'true' or 'false'));

    -- Don't target living entities for raise/tractor or dead entities for anything else..
    local health = entity:GetHPPercent(index)
    if has_bit(targets, 0x80) ~= (health == 0) then
        debug("can't target dead/living targets, fail")
        -- No dead targets unless spell can have dead targets
        return false
    end

    -- Self target.  Redundant, because we return true if targeting ourselves anyways.
    if has_bit(targets, 0x01) and has_bit(flags, 0x200) then
        debug("targetting self, auto-success)")
        return true
    end

    -- Pets
    if has_bit(targets, 0x02) and has_bit(flags, 0x1000) then
        -- Only your own pets.
        if index == entity:GetPetTargetIndex(myIndex) then
            debug("targetting your pet, auto-success)")
            return true
        end
    end

    -- Party
    if friendly and has_bit(targets, 0x04) and has_bit(flags, 0x04) then
        return true
    end

    -- Alliance
    if friendly and has_bit(targets, 0x08) and has_bit(flags, 0x08) then
        return true
    end

    -- Friendly target
    if friendly and has_bit(targets, 0x10) then
        -- Can cast on players and NPCs that are allied with self.
        if has_bit(flags, 0x03) then
            return true
        end

        -- Can cast on allied battle entities that aren't pets (helper NPCs)
        if has_bit(flags, 0x10) and not has_bit(flags, 0x100) then
            return true
        end
    end

    -- Enemy target
    if (not friendly) and has_bit(targets, 0x20) then
        -- Can cast on players that are charmed or on a different ballista team
        if has_bit(flags, 0x01) then
            return true
        end

        -- Can cast on monsters that aren't currently pets.
        if has_bit(flags, 0x10) and not has_bit(flags, 0x100) then
            return true
        end
    end

    -- NPC tradable.  Not entirely certain if this will ever apply to spells but...
    if has_bit(targets, 0x40) and has_bit(flags, 0x02) then
        return true
    end

    return false



    
    -- -- Commented out, because a last-second cure on someone who died just before hitting the macro shouldn't target the player instead.
    -- if friendly then
    --     if ((bit.band(targets, 0x04) ~= 0) and (bit.band(flags, 0x04) ~= 0)) then  -- Party
    --         return true
    --     elseif ((bit.band(targets, 0x08) ~= 0) and (bit.band(flags, 0x08) ~= 0)) then  -- Alliance
    --         return true
    --     elseif (bit.band(targets, 0x10) ~= 0) then  -- Friendly targets
    --         if ((bit.band(flags, 0x03) ~= 0)) then  -- Can cast on players and NPCs that are allied with self..
    --             return true
    --         elseif (bit.band(flags, 0x10) ~= 0) and (bit.band(flags, 0x100) == 0) then  -- Can cast on allied battle entities that aren't pets.. (helper npcs)
    --             return true
    --         end
    --     end
    --     return false
    -- else
    --     local health = entity:GetHPPercent(index)
    --     if (bit.band(targets, 0x80) == (health == 0)) then
    --         -- No dead targets unless spell can have dead targets
    --         return false
    --     end
    --     return true
    -- end
    -- elseif (bit.band(targets, 0x20) ~= 0) then  -- Not friendly + can't target hostiles
    
    --     if bit.band(flags, 0x01) then  -- Cast on charmed players or those on a different ballista team
    --         return true
    --     elseif (bit.band(flags, 0x10) and (not bit.band(flags, 0x100))) then  -- Cast on monsters that aren't pets.
    --         return true
    --     end
    -- elseif bit.band(targets, 0x40) and bit.band(flags, 0x02) then
    --     return true
    -- else
    --     return false
    -- end
end

ashita.events.register('command', 'command_cb', function (e)
    local args = e.command:args();
    if (#args == 0) then
        return;
    end

    if (string.lower(args[1]) ~= '/upcast') and (string.lower(args[1]) ~= '/up') then
        return;
    end
    e.blocked = true;

    local skip_tiers = 0       -- Number of tiers to skip (i.e. if Cure III is castable, cast Cure II instead)
    local in_cooldown = false  -- Choose the matching spell even if it's in cooldown, rather than skipping down one.
    local show_recast = false  -- Send /recast <spell> in addition to (trying to) cast it.
    local recast_only = false  -- /recast only, don't actually try to cast.
    local spell_name = nil     -- Original spell name.
    local spell_family = nil   -- Spell family (really spell_name lowercased)
    local target = nil         -- Intended spell target.

    for ix, arg in ipairs(args) do
        if ix ~= 1 then  -- Skip the first argument
            arg_lower = string.lower(arg)
            if arg_lower == 'cd' then
                in_cooldown = true
            elseif arg_lower == 'wr' then  -- (W)ith (R)ecast
                show_recast = true
            elseif arg_lower == "ro" or arg_lower == "recast" then
                show_recast = true
                recast_only = true
            elseif arg_lower[1] == '-' then
                skip_tiers = -tonumber(arg_lower)
                if skip_tiers == 0 then
                    print(chat.header('Upcast') .. chat.error("Unexpected option '" .. arg .. "'"));
                    return
                end
            else  -- Unknown argument, so hopefully it's the spell name.  This is the end of any and all options
                spell_name = arg
                spell_family = arg_lower
                target = args[ix + 1]  -- May be nil
                break
            end
        end
    end

    debug("skip_tiers=" .. skip_tiers);
    debug("in_cooldown=" .. (in_cooldown and 'true' or 'false'));
    debug("show_recast=" .. (show_recast and 'true' or 'false'));
    debug("spell_name=" .. (spell_name or '(nil)'));
    debug("spell_family=" .. (spell_family or '(nil)'));
    debug("target=" .. (target or '(nil)'));

    if not spell_name then
        print(chat.header('Upcast') .. chat.error("A spell name is required."));
    end

    local ids = spellData[spell_family]
    local final_spell = nil
    local final_spell_name = nil
    
    local resources = AshitaCore:GetResourceManager()
    if ids then
        local player = AshitaCore:GetMemoryManager():GetPlayer();
        local recast = AshitaCore:GetMemoryManager():GetRecast();
        
        for ix = #ids, 1, -1 do
            local id = ids[ix]
            -- Do they have the spell?
            if not player:HasSpell(id) then
                goto continue
            end

            local resource = resources:GetSpellById(id)
            -- Are they high enough level?
            if not CheckLevels(resource) then
                goto continue
            end
        
            -- Are we skipping tiers?
            if (skip_tiers > 0) then
                skip_tiers = skip_tiers - 1
                goto continue
            end

            -- Is it cooling down?  Did we decide to skip that?
            if ((not in_cooldown) and (recast:GetSpellTimer(resource.Index) ~= 0)) then
                goto continue
            end

            final_spell = resource
            break
            ::continue::
        end
    end
    if not final_spell then
        -- If this point was reached, we failed to find a valid spell.  Try the original input with no upcasting shenanigans.
        final_spell = resources:GetSpellByName(spell_name, 0)
    end
    final_spell_name = final_spell and final_spell.Name[1] or spell_name

    if show_recast then
        AshitaCore:GetChatManager():QueueCommand(1, "/recast \"" .. final_spell_name .. "\"");
    end
    if not target then
        if not final_spell then
            target = "<t>"
        else
            if IsValidTarget(final_spell) then
                target = "<t>"
            else
                target = "<me>"
            end
            debug("Defaulting to " .. target) ;
        end
    end

    if not recast_only then
        AshitaCore:GetChatManager():QueueCommand(1, "/ma \"" .. final_spell_name .. "\" " .. target);
    end
end);