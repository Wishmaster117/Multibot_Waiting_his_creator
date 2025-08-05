-- ------------------------------------------------------------------
--  Helper universel : TimerAfter 
-- ------------------------------------------------------------------
if not TimerAfter then
    function TimerAfter(delay, callback)
        if C_Timer and C_Timer.After then
            return C_Timer.After(delay, callback)
        end
        local f = CreateFrame("Frame")
        f.elapsed = 0
        f:SetScript("OnUpdate", function(self, dt)
            self.elapsed = self.elapsed + dt
            if self.elapsed >= delay then
                self:SetScript("OnUpdate", nil)
                if callback then pcall(callback) end
            end
        end)
    end
    -- rendez-la accessible ailleurs
    MultiBot    = _G.MultiBot or {}
    MultiBot.TimerAfter = TimerAfter
end

-- MULTIBAR --

local tMultiBar = MultiBot.addFrame("MultiBar", -322, 144, 36)
tMultiBar:SetMovable(true)

-- LEFT --

local tLeft = tMultiBar.addFrame("Left", -76, 2, 32)

-- TANKER --

tLeft.addButton("Tanker", -170, 0, "ability_warrior_shieldbash", MultiBot.tips.tanker.master)
.doLeft = function(pButton)
	if(MultiBot.isTarget()) then MultiBot.ActionToGroup("@tank do attack my target") end
end

--[[-- ATTACK --

local tButton = tLeft.addButton("Attack", -136, 0, "Interface\\AddOns\\MultiBot\\Icons\\attack.blp", MultiBot.tips.attack.master)
tButton.doRight = function(pButton)
	MultiBot.ShowHideSwitch(pButton.parent.frames["Attack"])
end
tButton.doLeft = function(pButton)
	if(MultiBot.isTarget()) then MultiBot.ActionToGroup("do attack my target") end
end

local tAttack = tLeft.addFrame("Attack", -138, 34)
tAttack:Hide()

local tButton = tAttack.addButton("Attack", 0, 0, "Interface\\AddOns\\MultiBot\\Icons\\attack.blp", MultiBot.tips.attack.attack)
tButton.doRight = function(pButton)
	MultiBot.SelectToGroupButtonWithTarget(pButton.parent.parent, "Attack", pButton.texture, "do attack my target")
end
tButton.doLeft = function(pButton)
	if(MultiBot.isTarget()) then MultiBot.ActionToGroup("do attack my target") end
end

local tButton = tAttack.addButton("Ranged", 0, 30, "Interface\\AddOns\\MultiBot\\Icons\\attack_ranged.blp", MultiBot.tips.attack.ranged)
tButton.doRight = function(pButton)
	MultiBot.SelectToGroupButtonWithTarget(pButton.parent.parent, "Attack", pButton.texture, "@ranged do attack my target")
end
tButton.doLeft = function(pButton)
	if(MultiBot.isTarget()) then MultiBot.ActionToGroup("@ranged do attack my target") end
end

local tButton = tAttack.addButton("Melee", 0, 60, "Interface\\AddOns\\MultiBot\\Icons\\attack_melee.blp", MultiBot.tips.attack.melee)
tButton.doRight = function(pButton)
	MultiBot.SelectToGroupButtonWithTarget(pButton.parent.parent, "Attack", pButton.texture, "@melee do attack my target")
end
tButton.doLeft = function(pButton)
	if(MultiBot.isTarget()) then MultiBot.ActionToGroup("@melee do attack my target") end
end

local tButton = tAttack.addButton("Healer", 0, 90, "Interface\\AddOns\\MultiBot\\Icons\\attack_healer.blp", MultiBot.tips.attack.healer)
tButton.doRight = function(pButton)
	MultiBot.SelectToGroupButtonWithTarget(pButton.parent.parent, "Attack", pButton.texture, "@healer do attack my target")
end
tButton.doLeft = function(pButton)
	if(MultiBot.isTarget()) then MultiBot.ActionToGroup("@healer do attack my target") end
end

local tButton = tAttack.addButton("Dps", 0, 120, "Interface\\AddOns\\MultiBot\\Icons\\attack_dps.blp", MultiBot.tips.attack.dps)
tButton.doRight = function(pButton)
	MultiBot.SelectToGroupButtonWithTarget(pButton.parent.parent, "Attack", pButton.texture, "@dps do attack my target")
end
tButton.doLeft = function(pButton)
	if(MultiBot.isTarget()) then MultiBot.ActionToGroup("@dps do attack my target") end
end

local tButton = tAttack.addButton("Tank", 0, 150, "Interface\\AddOns\\MultiBot\\Icons\\attack_tank.blp", MultiBot.tips.attack.tank)
tButton.doRight = function(pButton)
	MultiBot.SelectToGroupButtonWithTarget(pButton.parent.parent, "Attack", pButton.texture, "@tank do attack my target")
end
tButton.doLeft = function(pButton)
	if(MultiBot.isTarget()) then MultiBot.ActionToGroup("@tank do attack my target") end
end]]--

-- --------------------------------------------------------------------
--  UI ATTACK REFORGED --
-- --------------------------------------------------------------------
function MultiBot.BuildAttackUI(tLeft)

  -- 1. Table
  local ATTACK_BUTTONS = {
    -- label          icon                                                           command                           tip-key (MultiBot.tips.attack.<key>)
    { name="Attack",  icon="Interface\\AddOns\\MultiBot\\Icons\\attack.blp",         cmd="do attack my target",        tip="attack" },
    { name="Ranged",  icon="Interface\\AddOns\\MultiBot\\Icons\\attack_ranged.blp",  cmd="@ranged do attack my target",tip="ranged" },
    { name="Melee",   icon="Interface\\AddOns\\MultiBot\\Icons\\attack_melee.blp",   cmd="@melee do attack my target", tip="melee"  },
    { name="Healer",  icon="Interface\\AddOns\\MultiBot\\Icons\\attack_healer.blp",  cmd="@healer do attack my target",tip="healer" },
    { name="Dps",     icon="Interface\\AddOns\\MultiBot\\Icons\\attack_dps.blp",     cmd="@dps do attack my target",   tip="dps"    },
    { name="Tank",    icon="Interface\\AddOns\\MultiBot\\Icons\\attack_tank.blp",    cmd="@tank do attack my target",  tip="tank"   },
  }

  -- 2. Helper
  local function AddAttackButton(frame, info, index, cellH)
    local btn = frame.addButton(info.name,
                                0,                          -- x
                                (index-1)*cellH,            -- y
                                info.icon,
                                MultiBot.tips.attack[info.tip])

    -- Left Click shoot the command only if target exist
    btn.doLeft  = function()
      if MultiBot.isTarget() then
        MultiBot.ActionToGroup(info.cmd)
      end
    end

    -- Right click : select as default
    btn.doRight = function(b)
      MultiBot.SelectToGroupButtonWithTarget(b.parent.parent, "Attack", b.texture, info.cmd)
    end
  end

  -- 3. Main Button
  local mainBtn = tLeft.addButton("Attack", -136, 0,
                                  "Interface\\AddOns\\MultiBot\\Icons\\attack.blp",
                                  MultiBot.tips.attack.master)

  mainBtn.doLeft  = function() if MultiBot.isTarget() then MultiBot.ActionToGroup("do attack my target") end end
  mainBtn.doRight = function(b) MultiBot.ShowHideSwitch(b.parent.frames["Attack"]) end

  -- 4. Internal Frame with Buttons
  local tAttack = tLeft.addFrame("Attack", -138, 34)
  tAttack:Hide()

  local CELL_H = 30
  for idx, data in ipairs(ATTACK_BUTTONS) do
    AddAttackButton(tAttack, data, idx, CELL_H)
  end
end

--  We call it when tLeft are ready
MultiBot.BuildAttackUI(tLeft)

-- MODE --

local tButton = tLeft.addButton("Mode", -102, 0, "Interface\\AddOns\\MultiBot\\Icons\\mode_passive.blp", MultiBot.tips.mode.master).setDisable()
tButton.doRight = function(pButton)
	MultiBot.ShowHideSwitch(pButton.parent.frames["Mode"])
end
tButton.doLeft = function(pButton)
	if(MultiBot.OnOffSwitch(pButton)) then
		MultiBot.ActionToGroup("co +passive,?")
	else
		MultiBot.ActionToGroup("co -passive,?")
	end
end

local tMode = tLeft.addFrame("Mode", -104, 34)
tMode:Hide()

tMode.addButton("Passive", 0, 0, "Interface\\AddOns\\MultiBot\\Icons\\mode_passive.blp", MultiBot.tips.mode.passive)
.doLeft = function(pButton)
	if(MultiBot.SelectToGroup(pButton.parent.parent, "Mode", pButton.texture, "co +passive,?")) then
		pButton.parent.parent.buttons["Mode"].setEnable().doLeft = function(pButton)
			if(MultiBot.OnOffSwitch(pButton)) then
				MultiBot.ActionToGroup("co +passive,?")
			else
				MultiBot.ActionToGroup("co -passive,?")
			end
		end
	end
end

tMode.addButton("Grind", 0, 30, "Interface\\AddOns\\MultiBot\\Icons\\mode_grind.blp", MultiBot.tips.mode.grind)
.doLeft = function(pButton)
	if(MultiBot.SelectToGroup(pButton.parent.parent, "Mode", pButton.texture, "grind")) then
		pButton.parent.parent.buttons["Mode"].setEnable().doLeft = function(pButton)
			if(MultiBot.OnOffSwitch(pButton)) then
				MultiBot.ActionToGroup("grind")
			else
				MultiBot.ActionToGroup("follow")
			end
		end
	end
end

-- STAY|FOLLOW --

tLeft.addButton("Stay", -68, 0, "Interface\\AddOns\\MultiBot\\Icons\\command_follow.blp", MultiBot.tips.stallow.stay)
.doLeft = function(pButton)
	if(MultiBot.ActionToGroup("stay")) then
		pButton.parent.buttons["Follow"].doShow()
		pButton.parent.buttons["ExpandFollow"].setDisable()
		pButton.parent.buttons["ExpandStay"].setEnable()
		pButton.doHide()
	end
end

tLeft.addButton("Follow", -68, 0, "Interface\\AddOns\\MultiBot\\Icons\\command_stay.blp", MultiBot.tips.stallow.follow).doHide()
.doLeft = function(pButton)
	if(MultiBot.ActionToGroup("follow")) then
		pButton.parent.buttons["Stay"].doShow()
		pButton.parent.buttons["ExpandFollow"].setEnable()
		pButton.parent.buttons["ExpandStay"].setDisable()
		pButton.doHide()
	end
end

tLeft.addButton("ExpandStay", -68, 0, "Interface\\AddOns\\MultiBot\\Icons\\command_stay.blp", MultiBot.tips.expand.stay).doHide().setDisable()
.doLeft = function(pButton)
	MultiBot.ActionToGroup("stay")
	pButton.parent.buttons["ExpandFollow"].setDisable()
	pButton.setEnable()
end

tLeft.addButton("ExpandFollow", -102, 0, "Interface\\AddOns\\MultiBot\\Icons\\command_follow.blp", MultiBot.tips.expand.follow).doHide()
.doLeft = function(pButton)
	MultiBot.ActionToGroup("follow")
	pButton.parent.buttons["ExpandStay"].setDisable()
	pButton.setEnable()
end

-- FLEE --

--[[local tButton = tLeft.addButton("Flee", -34, 0, "Interface\\AddOns\\MultiBot\\Icons\\flee.blp", MultiBot.tips.flee.master)
tButton.doRight = function(pButton)
	MultiBot.ShowHideSwitch(pButton.parent.frames["Flee"])
end
tButton.doLeft = function(pButton)
	MultiBot.ActionToGroup("flee")
end

local tFlee = tLeft.addFrame("Flee", -36, 34)
tFlee:Hide()

local tButton = tFlee.addButton("Flee", 0, 0, "Interface\\AddOns\\MultiBot\\Icons\\flee.blp", MultiBot.tips.flee.flee)
tButton.doRight = function(pButton)
	MultiBot.SelectToGroupButton(pButton.parent.parent, "Flee", pButton.texture, "flee")
end
tButton.doLeft = function(pButton)
	MultiBot.ActionToGroup("flee")
end

local tButton = tFlee.addButton("Ranged", 0, 30, "Interface\\AddOns\\MultiBot\\Icons\\flee_ranged.blp", MultiBot.tips.flee.ranged)
tButton.doRight = function(pButton)
	MultiBot.SelectToGroupButton(pButton.parent.parent, "Flee", pButton.texture, "@ranged flee")
end
tButton.doLeft = function(pButton)
	MultiBot.ActionToGroup("@ranged flee")
end

local tButton = tFlee.addButton("Melee", 0, 60, "Interface\\AddOns\\MultiBot\\Icons\\flee_melee.blp", MultiBot.tips.flee.melee)
tButton.doRight = function(pButton)
	MultiBot.SelectToGroupButton(pButton.parent.parent, "Flee", pButton.texture, "@melee flee")
end
tButton.doLeft = function(pButton)
	MultiBot.ActionToGroup("@melee flee")
end

local tButton = tFlee.addButton("Healer", 0, 90, "Interface\\AddOns\\MultiBot\\Icons\\flee_healer.blp", MultiBot.tips.flee.healer)
tButton.doRight = function(pButton)
	MultiBot.SelectToGroupButton(pButton.parent.parent, "Flee", pButton.texture, "@healer flee")
end
tButton.doLeft = function(pButton)
	MultiBot.ActionToGroup("@healer flee")
end

local tButton = tFlee.addButton("Dps", 0, 120, "Interface\\AddOns\\MultiBot\\Icons\\flee_dps.blp", MultiBot.tips.flee.dps)
tButton.doRight = function(pButton)
	MultiBot.SelectToGroupButton(pButton.parent.parent, "Flee", pButton.texture, "@dps flee")
end
tButton.doLeft = function(pButton)
	MultiBot.ActionToGroup("@dps flee")
end

local tButton = tFlee.addButton("Tank", 0, 150, "Interface\\AddOns\\MultiBot\\Icons\\flee_tank.blp", MultiBot.tips.flee.tank)
tButton.doRight = function(pButton)
	MultiBot.SelectToGroupButton(pButton.parent.parent, "Flee", pButton.texture, "@tank flee")
end
tButton.doLeft = function(pButton)
	MultiBot.ActionToGroup("@tank flee")
end

local tButton = tFlee.addButton("Target", 0, 180, "Interface\\AddOns\\MultiBot\\Icons\\flee_target.blp", MultiBot.tips.flee.target)
tButton.doRight = function(pButton)
	MultiBot.SelectToTargetButton(pButton.parent.parent, "Flee", pButton.texture, "flee")
end
tButton.doLeft = function(pButton)
	MultiBot.ActionToTarget("flee")
end]]--

--  UI FLEE REFORGED --
function MultiBot.BuildFleeUI(tLeft)

  -- 1. Table
  local FLEE_BUTTONS = {
    -- label          icon                                                            cmd / taget          tip-key (MultiBot.tips.flee.<key>)
    { name="Flee",    icon="Interface\\AddOns\\MultiBot\\Icons\\flee.blp",            cmd="flee",          tip="flee",     scope="group"  },
    { name="Ranged",  icon="Interface\\AddOns\\MultiBot\\Icons\\flee_ranged.blp",     cmd="@ranged flee",  tip="ranged",   scope="group"  },
    { name="Melee",   icon="Interface\\AddOns\\MultiBot\\Icons\\flee_melee.blp",      cmd="@melee flee",   tip="melee",    scope="group"  },
    { name="Healer",  icon="Interface\\AddOns\\MultiBot\\Icons\\flee_healer.blp",     cmd="@healer flee",  tip="healer",   scope="group"  },
    { name="Dps",     icon="Interface\\AddOns\\MultiBot\\Icons\\flee_dps.blp",        cmd="@dps flee",     tip="dps",      scope="group"  },
    { name="Tank",    icon="Interface\\AddOns\\MultiBot\\Icons\\flee_tank.blp",       cmd="@tank flee",    tip="tank",     scope="group"  },
    { name="Target",  icon="Interface\\AddOns\\MultiBot\\Icons\\flee_target.blp",     cmd="flee",          tip="target",   scope="target" },
  }

  -- 2. Helper to create vertival buttons
  local function AddFleeButton(frame, info, index, cellH)
    local btn = frame.addButton(info.name,
                                0,                           -- x
                                (index-1)*cellH,             -- y
                                info.icon,
                                MultiBot.tips.flee[info.tip])

    if info.scope == "target" then
      -- Left click action, right click action
      btn.doLeft  = function() MultiBot.ActionToTarget(info.cmd) end
      btn.doRight = function(b) MultiBot.SelectToTargetButton(b.parent.parent,"Flee",b.texture,info.cmd) end
    else
      -- scope group/role
      btn.doLeft  = function() MultiBot.ActionToGroup(info.cmd) end
      btn.doRight = function(b) MultiBot.SelectToGroupButton(b.parent.parent,"Flee",b.texture,info.cmd) end
    end
  end

  -- 3. Maint Button
  local mainBtn = tLeft.addButton("Flee", -34, 0,
                                  "Interface\\AddOns\\MultiBot\\Icons\\flee.blp",
                                  MultiBot.tips.flee.master)

  mainBtn.doLeft  = function() MultiBot.ActionToGroup("flee") end
  mainBtn.doRight = function(b) MultiBot.ShowHideSwitch(b.parent.frames["Flee"]) end

  -- 4. Internal Frame + vertical buttons
  local tFlee = tLeft.addFrame("Flee", -36, 34)
  tFlee:Hide()

  local CELL_H = 30   -- space between buttons
  for idx, data in ipairs(FLEE_BUTTONS) do
    AddFleeButton(tFlee, data, idx, CELL_H)
  end
end

--  We call it when tLeft are ready
MultiBot.BuildFleeUI(tLeft)

--[[-- FORMATION --

local tButton = tLeft.addButton("Format", -0, 0, "Interface\\AddOns\\MultiBot\\Icons\\formation_near.blp", MultiBot.tips.format.master)
tButton.doRight = function(pButton)
	MultiBot.ActionToGroup("formation")
end
tButton.doLeft = function(pButton)
	MultiBot.ShowHideSwitch(pButton.parent.frames["Format"])
end

local tFormat = tLeft.addFrame("Format", -2, 34)
tFormat:Hide()

tFormat.addButton("Arrow", 0, 0, "Interface\\AddOns\\MultiBot\\Icons\\formation_arrow.blp", MultiBot.tips.format.arrow)
.doLeft = function(pButton)
	MultiBot.SelectToGroup(pButton.parent.parent, "Format", pButton.texture, "formation arrow")
end

tFormat.addButton("Queue", 0, 30, "Interface\\AddOns\\MultiBot\\Icons\\formation_queue.blp", MultiBot.tips.format.queue)
.doLeft = function(pButton)
	MultiBot.SelectToGroup(pButton.parent.parent, "Format", pButton.texture, "formation queue")
end

tFormat.addButton("Near", 0, 60, "Interface\\AddOns\\MultiBot\\Icons\\formation_near.blp", MultiBot.tips.format.near)
.doLeft = function(pButton)
	MultiBot.SelectToGroup(pButton.parent.parent, "Format", pButton.texture, "formation near")
end

tFormat.addButton("Melee", 0, 90, "Interface\\AddOns\\MultiBot\\Icons\\formation_melee.blp", MultiBot.tips.format.melee)
.doLeft = function(pButton)
	MultiBot.SelectToGroup(pButton.parent.parent, "Format", pButton.texture, "formation melee")
end

tFormat.addButton("Line", 0, 120, "Interface\\AddOns\\MultiBot\\Icons\\formation_line.blp", MultiBot.tips.format.line)
.doLeft = function(pButton)
	MultiBot.SelectToGroup(pButton.parent.parent, "Format", pButton.texture, "formation line")
end

tFormat.addButton("Circle", 0, 150, "Interface\\AddOns\\MultiBot\\Icons\\formation_circle.blp", MultiBot.tips.format.circle)
.doLeft = function(pButton)
	MultiBot.SelectToGroup(pButton.parent.parent, "Format", pButton.texture, "formation circle")
end

tFormat.addButton("Chaos", 0, 180, "Interface\\AddOns\\MultiBot\\Icons\\formation_chaos.blp", MultiBot.tips.format.chaos)
.doLeft = function(pButton)
	MultiBot.SelectToGroup(pButton.parent.parent, "Format", pButton.texture, "formation chaos")
end

tFormat.addButton("Shield", 0, 210, "Interface\\AddOns\\MultiBot\\Icons\\formation_shield.blp", MultiBot.tips.format.shield)
.doLeft = function(pButton)
	MultiBot.SelectToGroup(pButton.parent.parent, "Format", pButton.texture, "formation shield")
end]]--

--  UI FORMATION REFORGED --
function MultiBot.BuildFormationUI(tLeft)
  -- 1. Formation Table
  local FORMATION_BUTTONS = {
    { name = "Arrow",  icon = "Interface\\AddOns\\MultiBot\\Icons\\formation_arrow.blp",  cmd = "formation arrow"  },
    { name = "Queue",  icon = "Interface\\AddOns\\MultiBot\\Icons\\formation_queue.blp",  cmd = "formation queue"  },
    { name = "Near",   icon = "Interface\\AddOns\\MultiBot\\Icons\\formation_near.blp",   cmd = "formation near"   },
    { name = "Melee",  icon = "Interface\\AddOns\\MultiBot\\Icons\\formation_melee.blp",  cmd = "formation melee"  },
    { name = "Line",   icon = "Interface\\AddOns\\MultiBot\\Icons\\formation_line.blp",   cmd = "formation line"   },
    { name = "Circle", icon = "Interface\\AddOns\\MultiBot\\Icons\\formation_circle.blp", cmd = "formation circle" },
    { name = "Chaos",  icon = "Interface\\AddOns\\MultiBot\\Icons\\formation_chaos.blp",  cmd = "formation chaos"  },
    { name = "Shield", icon = "Interface\\AddOns\\MultiBot\\Icons\\formation_shield.blp", cmd = "formation shield" },
  }

  local function AddFormationButton(frame, info, col, row, cellW, cellH)
    frame.addButton(info.name,
                    (col-1)*cellW,
                    (row-1)*cellH,
                    info.icon,
                    MultiBot.tips.format[string.lower(info.name)])
      .doLeft = function(btn)
        MultiBot.SelectToGroup(btn.parent.parent, "Format", btn.texture, info.cmd)
      end
  end

  -- Main Button --
  local fBtn = tLeft.addButton("Format", 0, 0,
                               "Interface\\AddOns\\MultiBot\\Icons\\formation_near.blp",
                               MultiBot.tips.format.master)

  fBtn.doLeft  = function(btn)  MultiBot.ShowHideSwitch(btn.parent.frames["Format"]) end
  fBtn.doRight = function()     MultiBot.ActionToGroup("formation")                 end

  -- Internal Frame --
  local tFormat = tLeft.addFrame("Format", -2, 34)
  tFormat:Hide()

  -- Grid 1 × N (columns) --
  local COLS     = 1     -- One column
  local CELL_W   = 40    -- wide (useless here but we keep the arg.)
  local CELL_H   = 30    -- high/vertival spacing
  
  for idx, data in ipairs(FORMATION_BUTTONS) do
  local col = 1                                    -- toujours 1
  local row = idx                                   -- 1,2,3…
  AddFormationButton(tFormat, data, col, row, CELL_W, CELL_H)
  end 
end

-- We call it, when tLeft are ready
MultiBot.BuildFormationUI(tLeft)

-- BEASTMASTER --

tLeft.addButton("Beast", -0, 0, "ability_mount_swiftredwindrider", MultiBot.tips.beast.master).doHide()
.doLeft = function(pButton)
	MultiBot.ShowHideSwitch(pButton.parent.frames["Beast"])
end

local tBeast = tLeft.addFrame("Beast", -2, 34)
tBeast:Hide()

tBeast.addButton("Release", 0, 0, "spell_nature_spiritwolf", MultiBot.tips.beast.release)
.doLeft = function(pButton)
	MultiBot.ActionToTargetOrGroup("cast 2641")
end

tBeast.addButton("Revive", 0, 30, "ability_hunter_beastsoothe", MultiBot.tips.beast.revive)
.doLeft = function(pButton)
	MultiBot.ActionToTargetOrGroup("cast 982")
end

tBeast.addButton("Heal", 0, 60, "ability_hunter_mendpet", MultiBot.tips.beast.heal)
.doLeft = function(pButton)
	MultiBot.ActionToTargetOrGroup("cast 48990")
end

tBeast.addButton("Feed", 0, 90, "ability_hunter_beasttraining", MultiBot.tips.beast.feed)
.doLeft = function(pButton)
	MultiBot.ActionToTargetOrGroup("cast 6991")
end

tBeast.addButton("Call", 0, 120, "ability_hunter_beastcall", MultiBot.tips.beast.call)
.doLeft = function(pButton)
	MultiBot.ActionToTargetOrGroup("cast 883")
end

-- CREATOR --

-- tLeft.addButton("Creator", -0, 0, "inv_helmet_145a", MultiBot.tips.creator.master).doHide()
-- .doLeft = function(pButton)
-- 	MultiBot.ShowHideSwitch(pButton.parent.frames["Creator"])
-- 	MultiBot.frames["MultiBar"].frames["Units"]:Hide()
-- end
-- 
-- local tCreator = tLeft.addFrame("Creator", -2, 34)
-- tCreator:Hide()
-- 
-- tCreator.addButton("Warrior", 0, 0, "Interface\\AddOns\\MultiBot\\Icons\\addclass_warrior.blp", MultiBot.tips.creator.warrior)
-- .doLeft = function(pButton)
-- 	SendChatMessage(".playerbot bot addclass warrior", "SAY")
-- end
-- 
-- tCreator.addButton("Warlock", 0, 30, "Interface\\AddOns\\MultiBot\\Icons\\addclass_warlock.blp", MultiBot.tips.creator.warlock)
-- .doLeft = function(pButton)
-- 	SendChatMessage(".playerbot bot addclass warlock", "SAY")
-- end
-- 
-- tCreator.addButton("Shaman", 0, 60, "Interface\\AddOns\\MultiBot\\Icons\\addclass_shaman.blp", MultiBot.tips.creator.shaman)
-- .doLeft = function(pButton)
-- 	SendChatMessage(".playerbot bot addclass shaman", "SAY")
-- end
-- 
-- tCreator.addButton("Rogue", 0, 90, "Interface\\AddOns\\MultiBot\\Icons\\addclass_rogue.blp", MultiBot.tips.creator.rogue)
-- .doLeft = function(pButton)
-- 	SendChatMessage(".playerbot bot addclass rogue", "SAY")
-- end
-- 
-- tCreator.addButton("Priest", 0, 120, "Interface\\AddOns\\MultiBot\\Icons\\addclass_priest.blp", MultiBot.tips.creator.priest)
-- .doLeft = function(pButton)
-- 	SendChatMessage(".playerbot bot addclass priest", "SAY")
-- end
-- 
-- tCreator.addButton("Paladin", 0, 150, "Interface\\AddOns\\MultiBot\\Icons\\addclass_paladin.blp", MultiBot.tips.creator.paladin)
-- .doLeft = function(pButton)
-- 	SendChatMessage(".playerbot bot addclass paladin", "SAY")
-- end
-- 
-- tCreator.addButton("Mage", 0, 180, "Interface\\AddOns\\MultiBot\\Icons\\addclass_mage.blp", MultiBot.tips.creator.mage)
-- .doLeft = function(pButton)
-- 	SendChatMessage(".playerbot bot addclass mage", "SAY")
-- end
-- 
-- tCreator.addButton("Hunter", 0, 210, "Interface\\AddOns\\MultiBot\\Icons\\addclass_hunter.blp", MultiBot.tips.creator.hunter)
-- .doLeft = function(pButton)
-- 	SendChatMessage(".playerbot bot addclass hunter", "SAY")
-- end
-- 
-- tCreator.addButton("Druid", 0, 240, "Interface\\AddOns\\MultiBot\\Icons\\addclass_druid.blp", MultiBot.tips.creator.druid)
-- .doLeft = function(pButton)
-- 	SendChatMessage(".playerbot bot addclass druid", "SAY")
-- end
-- 
-- tCreator.addButton("DeathKnight", 0, 270, "Interface\\AddOns\\MultiBot\\Icons\\addclass_deathknight.blp", MultiBot.tips.creator.deathknight)
-- .doLeft = function(pButton)
-- 	SendChatMessage(".playerbot bot addclass dk", "SAY")
-- end
-- 
-- tCreator.addButton("Inspect", 0, 300, "Interface\\AddOns\\MultiBot\\Icons\\filter_none.blp", MultiBot.tips.creator.inspect)
-- .doLeft = function(pButton)
-- 	local tName = UnitName("target")
-- 	if(tName == nil or tName == "Unknown Entity") then return SendChatMessage("I dont have a Target.", "SAY") end
-- 	InspectUnit(tName)
-- end
-- 
-- local tButton = tCreator.addButton("Init", 0, 330, "inv_misc_enggizmos_27", MultiBot.tips.creator.init)
-- tButton.doRight = function(pButton)
-- 	if(GetNumRaidMembers() > 0) then
-- 		for i = 1, GetNumRaidMembers() do
-- 			local tName = UnitName("raid" .. i)
-- 			if(MultiBot.isRoster("players", tName))	then SendChatMessage(MultiBot.doReplace(MultiBot.info.player, "NAME", tName), "SAY")
-- 			elseif(MultiBot.isRoster("members", tName)) then SendChatMessage(MultiBot.doReplace(MultiBot.info.member, "NAME", tName), "SAY")
-- 			elseif(tName ~= UnitName("player")) then SendChatMessage(".playerbot bot init=auto " .. tName, "SAY")
-- 			end
-- 		end
-- 		
-- 		return
-- 	end
-- 	
-- 	if(GetNumPartyMembers() > 0) then
-- 		for i = 1, GetNumPartyMembers() do
-- 			local tName = UnitName("party" .. i)
-- 			if(MultiBot.isRoster("players", tName))	then SendChatMessage(MultiBot.doReplace(MultiBot.info.player, "NAME", tName), "SAY")
-- 			elseif(MultiBot.isRoster("members", tName)) then SendChatMessage(MultiBot.doReplace(MultiBot.info.member, "NAME", tName), "SAY")
-- 			elseif(tName ~= UnitName("player")) then SendChatMessage(".playerbot bot init=auto " .. tName, "SAY")
-- 			end
-- 		end
-- 		
-- 		return
-- 	end
-- 	
-- 	SendChatMessage(MultiBot.info.group, "SAY")
-- end
-- tButton.doLeft = function(pButton)
-- 	local tName = UnitName("target")
-- 	if(tName == nil or tName == "Unknown Entity") then return SendChatMessage(MultiBot.info.target, "SAY") end
-- 	if(MultiBot.isRoster("players", tName)) then return SendChatMessage(MultiBot.info.players, "SAY") end
-- 	if(MultiBot.isRoster("members", tName)) then return SendChatMessage(MultiBot.info.members, "SAY") end
-- 	SendChatMessage(".playerbot bot init=auto " .. tName, "SAY")
-- end

--  CREATOR refactored --
local GENDER_BUTTONS = {
  { label = "Male",     gender = "male",    icon = "Interface\\Icons\\INV_Misc_Toy_02",        tip = MultiBot.tips.creator.gendermale      },
  { label = "Femelle",  gender = "female",  icon = "Interface\\Icons\\INV_Misc_Toy_04",        tip = MultiBot.tips.creator.genderfemale    },
  { label = "Aléatoire",gender = nil,       icon = "Interface\\Buttons\\UI-GroupLoot-Dice-Up", tip = MultiBot.tips.creator.genderrandom    },
}

local CLASS_BUTTONS = {
  { name = "Warrior",     y =   0, icon = "Interface\\AddOns\\MultiBot\\Icons\\addclass_warrior.blp",     cmd = "warrior"     },
  { name = "Warlock",     y =  30, icon = "Interface\\AddOns\\MultiBot\\Icons\\addclass_warlock.blp",     cmd = "warlock"     },
  { name = "Shaman",      y =  60, icon = "Interface\\AddOns\\MultiBot\\Icons\\addclass_shaman.blp",      cmd = "shaman"      },
  { name = "Rogue",       y =  90, icon = "Interface\\AddOns\\MultiBot\\Icons\\addclass_rogue.blp",       cmd = "rogue"       },
  { name = "Priest",      y = 120, icon = "Interface\\AddOns\\MultiBot\\Icons\\addclass_priest.blp",      cmd = "priest"      },
  { name = "Paladin",     y = 150, icon = "Interface\\AddOns\\MultiBot\\Icons\\addclass_paladin.blp",     cmd = "paladin"     },
  { name = "Mage",        y = 180, icon = "Interface\\AddOns\\MultiBot\\Icons\\addclass_mage.blp",        cmd = "mage"        },
  { name = "Hunter",      y = 210, icon = "Interface\\AddOns\\MultiBot\\Icons\\addclass_hunter.blp",      cmd = "hunter"      },
  { name = "Druid",       y = 240, icon = "Interface\\AddOns\\MultiBot\\Icons\\addclass_druid.blp",       cmd = "druid"       },
  { name = "DeathKnight", y = 270, icon = "Interface\\AddOns\\MultiBot\\Icons\\addclass_deathknight.blp", cmd = "dk"          }
}

local function AddClassButton(frame, info)
  -- 1. Main class button
  local classBtn = frame.addButton(info.name, 0, info.y, info.icon,
                                   MultiBot.tips.creator[string.lower(info.name)])

  -- 2. Sub buttons (Male / Female / Random)
  classBtn.genderButtons = {}
  local xOffset = 30
  local step    = 30

  for idx, g in ipairs(GENDER_BUTTONS) do
    local gBtn = frame.addButton(g.label,
                                 xOffset + (idx-1)*step,
                                 info.y,
                                 g.icon,
                                 g.tip)

    gBtn:Hide()                         -- hided at start

    gBtn.doLeft = function()
      MultiBot.AddClassToTarget(info.cmd, g.gender)   -- Send command
    end

    table.insert(classBtn.genderButtons, gBtn)
  end

  -- 3. When we click in class button => toggle the 3 gender buttons
  classBtn.doLeft = function(btn)
    local show = not btn.genderButtons[1]:IsShown()

    -- Hide those of the other class to keep display clean
    for _, other in ipairs(frame.buttons or {}) do
      if other ~= btn and other.genderButtons then
        for _, b in ipairs(other.genderButtons) do b:Hide() end
      end
    end

    -- Display / hide buttons from the clicked class
    for _, b in ipairs(btn.genderButtons) do
      if show then b:Show() else b:Hide() end
    end
  end

  -- We keep main buttons for the global toggle
  frame.buttons = frame.buttons or {}
  table.insert(frame.buttons, classBtn)
end


--  Creator
tLeft.addButton("Creator", -0, 0, "inv_helmet_145a", MultiBot.tips.creator.master)
  .doLeft = function(btn)
    MultiBot.ShowHideSwitch(btn.parent.frames["Creator"])
    MultiBot.frames["MultiBar"].frames["Units"]:Hide()
  end

local tCreator = tLeft.addFrame("Creator", -2, 34)
tCreator:Hide()
-- hook OnHide to clos sub buttons
tCreator:HookScript("OnHide", function(self)
  -- self.buttons content all main buttons
  if self.buttons then
    for _, btn in ipairs(self.buttons) do
      if btn.genderButtons then
        for _, gBtn in ipairs(btn.genderButtons) do gBtn:Hide() end
      end
    end
  end
end)

for _, data in ipairs(CLASS_BUTTONS) do
  AddClassButton(tCreator, data)
end

--  Inspect
tCreator.addButton("Inspect", 0, 300, "Interface\\AddOns\\MultiBot\\Icons\\filter_none.blp", MultiBot.tips.creator.inspect)
  .doLeft = function()
    if UnitExists("target") and UnitIsPlayer("target") then
      InspectUnit("target")
    else
      SendChatMessage(MultiBot.tips.creator.notarget, "SAY")
    end
  end

-- Button Init
local tButton = tCreator.addButton("Init", 0, 330, "inv_misc_enggizmos_27", MultiBot.tips.creator.init)

tButton.doRight = function()
  local function Iterate(unitPrefix, num)
    for i = 1, num do
      local name = UnitName(unitPrefix .. i)
      if name and name ~= UnitName("player") then
        if MultiBot.isRoster("players", name) then
          SendChatMessage(MultiBot.doReplace(MultiBot.info.player, "NAME", name), "SAY")
        elseif MultiBot.isRoster("members", name) then
          SendChatMessage(MultiBot.doReplace(MultiBot.info.member, "NAME", name), "SAY")
        else
          MultiBot.InitAuto(name)
        end
      end
    end
  end

  if IsInRaid() then
    Iterate("raid", GetNumGroupMembers())
  elseif IsInGroup() then
    Iterate("party", GetNumSubgroupMembers())
  else
    SendChatMessage(MultiBot.info.group, "SAY")
  end
end

tButton.doLeft = function()
  if UnitExists("target") and UnitIsPlayer("target") then
    local name = UnitName("target")
    if MultiBot.isRoster("players", name) then
      SendChatMessage(MultiBot.info.players, "SAY")
    elseif MultiBot.isRoster("members", name) then
      SendChatMessage(MultiBot.info.members, "SAY")
    else
      MultiBot.InitAuto(name)
    end
  else
    SendChatMessage(MultiBot.info.target, "SAY")
  end
end

-- UNITS --

local tButton = tMultiBar.addButton("Units", -38, 0, "inv_scroll_04", MultiBot.tips.units.master)
tButton.roster = "players"
tButton.filter = "none"

tButton.doRight = function(pButton)
	-- MEMBERBOTS --
	
	for i = 1, 50 do
		local tName, tRank, tIndex, tLevel, tClass = GetGuildRosterInfo(i)
		
		-- Ensure that the Counter is not bigger than the Amount of Members in Guildlist
		if(tName ~= nil and tLevel ~= nil and tClass ~= nil and tName ~= UnitName("player")) then
			local tMember = MultiBot.addMember(tClass, tLevel, tName)
			
			if(tMember.state == false)
			then tMember.setDisable()
			else tMember.setEnable()
			end
			
			tMember.doRight = function(pButton)
				if(pButton.state == false) then return end
				SendChatMessage(".playerbot bot remove " .. pButton.name, "SAY")
				if(pButton.parent.frames[pButton.name] ~= nil) then pButton.parent.frames[pButton.name]:Hide() end
				pButton.setDisable()
			end
			
			tMember.doLeft = function(pButton)
				if(pButton.state) then
					if(pButton.parent.frames[pButton.name] ~= nil) then MultiBot.ShowHideSwitch(pButton.parent.frames[pButton.name]) end
				else
					SendChatMessage(".playerbot bot add " .. pButton.name, "SAY")
					pButton.setEnable()
				end
			end
		else
			break
		end
	end
	
	-- FRIENDBOTS --
	
	for i = 1, 50 do
		local tName, tLevel, tClass = GetFriendInfo(i)
		
		-- Ensure that the Counter is not bigger than the Amount of Members in Friendlist
		if(tName ~= nil and tLevel ~= nil and tClass ~= nil and tName ~= UnitName("player")) then
			local tFriend = MultiBot.addFriend(tClass, tLevel, tName)
			
			if(tFriend.state == false)
			then tFriend.setDisable()
			else tFriend.setEnable()
			end
			
			tFriend.doRight = function(pButton)
				if(pButton.state == false) then return end
				SendChatMessage(".playerbot bot remove " .. pButton.name, "SAY")
				if(pButton.parent.frames[pButton.name] ~= nil) then pButton.parent.frames[pButton.name]:Hide() end
				pButton.setDisable()
			end
			
			tFriend.doLeft = function(pButton)
				if(pButton.state) then
					if(pButton.parent.frames[pButton.name] ~= nil) then MultiBot.ShowHideSwitch(pButton.parent.frames[pButton.name]) end
				else
					SendChatMessage(".playerbot bot add " .. pButton.name, "SAY")
					pButton.setEnable()
				end
			end
		else
			break
		end
	end
	
	pButton.doLeft(pButton, pButton.roster, pButton.filter)
end

tButton.doLeft = function(pButton, oRoster, oFilter)
	local tUnits = pButton.parent.frames["Units"]
	local tTable = nil
	
	for key, value in pairs(tUnits.buttons) do value:Hide() end
	for key, value in pairs(tUnits.frames) do value:Hide() end
	tUnits.frames["Alliance"]:Show()
	tUnits.frames["Control"]:Show()
	
	if(oRoster == nil and oFilter == nil) then MultiBot.ShowHideSwitch(tUnits)
	elseif(oRoster ~= nil) then pButton.roster = oRoster
	elseif(oFilter ~= nil) then pButton.filter = oFilter
	end
	
	if(pButton.filter ~= "none")
	then tTable = MultiBot.index.classes[pButton.roster][pButton.filter]
	else tTable = MultiBot.index[pButton.roster]
	end
	
	local tButton = nil
	local tFrame = nil
	local tIndex = 0
	
	if(tTable ~= nil)
	then pButton.limit = table.getn(tTable)
	else pButton.limit = 0
	end
	
	pButton.from = 1
	pButton.to = 10
	
	for i = 1, pButton.limit do
		tIndex = (i - 1)%10 + 1
		tFrame = tUnits.frames[tTable[i]]
		tButton = tUnits.buttons[tTable[i]]
		tButton.setPoint(0, (tUnits.size + 2) * (tIndex - 1))
		if(tFrame ~=nil) then tFrame.setPoint(-34, (tUnits.size + 2) * (tIndex - 1) + 2) end
		
		if(pButton.from <= i and pButton.to >= i) then
			if(tFrame ~= nil and tButton.state) then tFrame:Show() end
			tButton:Show()
		end
	end
	
	if(pButton.limit < pButton.to)
	then tUnits.frames["Control"].setPoint(-2, (tUnits.size + 2) * pButton.limit)
	else tUnits.frames["Control"].setPoint(-2, (tUnits.size + 2) * pButton.to)
	end
	
	if(pButton.limit < 11)
	then tUnits.frames["Control"].buttons["Browse"]:Hide()
	else tUnits.frames["Control"].buttons["Browse"]:Show()
	end
end

local tUnits = tMultiBar.addFrame("Units", -40, 72)
tUnits:Hide()

-- UNITS: ALLIANCE / HORDE  --
local tAlliance = tUnits.addFrame("Alliance", 0, -34, 32)
tAlliance:Show()

-- 1.  Determinate player faction
local faction = UnitFactionGroup("player")      -- "Alliance" ou "Horde"

-- 2.  Associate faction -> Banner
local FACTION_BANNERS = {
  Alliance = "inv_misc_tournaments_banner_human",
  Horde    = "inv_misc_tournaments_banner_orc",
}

-- 3.  Fallback
local bannerIcon = FACTION_BANNERS[faction] or "inv_misc_tournaments_banner_human"

-- 4.  Creating button
local btnAlliance = tAlliance.addButton("FactionBanner", 0, 0, bannerIcon,
                                        MultiBot.tips.units.alliance)  -- ou units.horde si tu ajoutes le tooltip
btnAlliance:doShow()

-- Callbacks
btnAlliance.doRight = function() SendChatMessage(".playerbot bot remove *", "SAY") end
btnAlliance.doLeft  = function() SendChatMessage(".playerbot bot add *",    "SAY") end

-- UNITS:CONTROL --

local tControl = tUnits.addFrame("Control", -2, 0)
tControl:Show()

--[[-- UNITS:FILTER --

local tButton = tControl.addButton("Filter", 0, 0, "Interface\\AddOns\\MultiBot\\Icons\\filter_none.blp", MultiBot.tips.units.filter)
tButton.doRight = function(pButton)
	local tButton = MultiBot.frames["MultiBar"].buttons["Units"]
	MultiBot.Select(pButton.parent, "Filter", "Interface\\AddOns\\MultiBot\\Icons\\filter_none.blp")
	tButton.doLeft(tButton, nil, "none")
end
tButton.doLeft = function(pButton)
	MultiBot.ShowHideSwitch(pButton.parent.frames["Filter"])
end

local tFilter = tControl.addFrame("Filter", -30, 2)
tFilter:Hide()

tFilter.addButton("DeathKnight", 0, 0, "Interface\\AddOns\\MultiBot\\Icons\\filter_deathknight.blp", MultiBot.tips.units.deathknight)
.doLeft = function(pButton)
	local tButton = MultiBot.frames["MultiBar"].buttons["Units"]
	MultiBot.Select(pButton.parent.parent, "Filter", pButton.texture)
	tButton.doLeft(tButton, nil, "DeathKnight")
end

tFilter.addButton("Druid", -26, 0, "Interface\\AddOns\\MultiBot\\Icons\\filter_druid.blp", MultiBot.tips.units.druid)
.doLeft = function(pButton)
	local tButton = MultiBot.frames["MultiBar"].buttons["Units"]
	MultiBot.Select(pButton.parent.parent, "Filter", pButton.texture)
	tButton.doLeft(tButton, nil, "Druid")
end

tFilter.addButton("Hunter", -52, 0, "Interface\\AddOns\\MultiBot\\Icons\\filter_hunter.blp", MultiBot.tips.units.hunter)
.doLeft = function(pButton)
	local tButton = MultiBot.frames["MultiBar"].buttons["Units"]
	MultiBot.Select(pButton.parent.parent, "Filter", pButton.texture)
	tButton.doLeft(tButton, nil, "Hunter")
end

tFilter.addButton("Mage", -78, 0, "Interface\\AddOns\\MultiBot\\Icons\\filter_mage.blp", MultiBot.tips.units.mage)
.doLeft = function(pButton)
	local tButton = MultiBot.frames["MultiBar"].buttons["Units"]
	MultiBot.Select(pButton.parent.parent, "Filter", pButton.texture)
	tButton.doLeft(tButton, nil, "Mage")
end

tFilter.addButton("Paladin", -104, 0, "Interface\\AddOns\\MultiBot\\Icons\\filter_paladin.blp", MultiBot.tips.units.paladin)
.doLeft = function(pButton)
	local tButton = MultiBot.frames["MultiBar"].buttons["Units"]
	MultiBot.Select(pButton.parent.parent, "Filter", pButton.texture)
	tButton.doLeft(tButton, nil, "Paladin")
end

tFilter.addButton("Priest", -130, 0, "Interface\\AddOns\\MultiBot\\Icons\\filter_priest.blp", MultiBot.tips.units.priest)
.doLeft = function(pButton)
	local tButton = MultiBot.frames["MultiBar"].buttons["Units"]
	MultiBot.Select(pButton.parent.parent, "Filter", pButton.texture)
	tButton.doLeft(tButton, nil, "Priest")
end

tFilter.addButton("Rogue", -156, 0, "Interface\\AddOns\\MultiBot\\Icons\\filter_rogue.blp", MultiBot.tips.units.rogue)
.doLeft = function(pButton)
	local tButton = MultiBot.frames["MultiBar"].buttons["Units"]
	MultiBot.Select(pButton.parent.parent, "Filter", pButton.texture)
	tButton.doLeft(tButton, nil, "Rogue")
end

tFilter.addButton("Shaman", -182, 0, "Interface\\AddOns\\MultiBot\\Icons\\filter_shaman.blp", MultiBot.tips.units.shaman)
.doLeft = function(pButton)
	local tButton = MultiBot.frames["MultiBar"].buttons["Units"]
	MultiBot.Select(pButton.parent.parent, "Filter", pButton.texture)
	tButton.doLeft(tButton, nil, "Shaman")
end

tFilter.addButton("Warlock", -208, 0, "Interface\\AddOns\\MultiBot\\Icons\\filter_warlock.blp", MultiBot.tips.units.warlock)
.doLeft = function(pButton)
	local tButton = MultiBot.frames["MultiBar"].buttons["Units"]
	MultiBot.Select(pButton.parent.parent, "Filter", pButton.texture)
	tButton.doLeft(tButton, nil, "Warlock")
end

tFilter.addButton("Warrior", -234, 0, "Interface\\AddOns\\MultiBot\\Icons\\filter_warrior.blp", MultiBot.tips.units.warrior)
.doLeft = function(pButton)
	local tButton = MultiBot.frames["MultiBar"].buttons["Units"]
	MultiBot.Select(pButton.parent.parent, "Filter", pButton.texture)
	tButton.doLeft(tButton, nil, "Warrior")
end

tFilter.addButton("None", -260, 0, "Interface\\AddOns\\MultiBot\\Icons\\filter_none.blp", MultiBot.tips.units.none)
.doLeft = function(pButton)
	local tButton = MultiBot.frames["MultiBar"].buttons["Units"]
	MultiBot.Select(pButton.parent.parent, "Filter", pButton.texture)
	tButton.doLeft(tButton, nil, "none")
end]]--

-- UNITS:FILTER REFACTORED --
function MultiBot.BuildFilterUI(tControl)
  -- 1. Main button
  local rootBtn = tControl.addButton("Filter", 0, 0,
                                     "Interface\\AddOns\\MultiBot\\Icons\\filter_none.blp",
                                     MultiBot.tips.units.filter)

  -- Left CLick : Show/mask sub frame Right Click : reset filter
  rootBtn.doLeft  = function(b) MultiBot.ShowHideSwitch(b.parent.frames["Filter"]) end
  rootBtn.doRight = function(b)
    local unitsBtn = MultiBot.frames.MultiBar.buttons.Units
    MultiBot.Select(b.parent, "Filter",
                    "Interface\\AddOns\\MultiBot\\Icons\\filter_none.blp")
    unitsBtn.doLeft(unitsBtn, nil, "none")
  end

  -- 2. Frame + Data Table
  local tFilter = tControl.addFrame("Filter", -30, 2) ; tFilter:Hide()

  local FILTERS = {
    { key="DeathKnight", icon="filter_deathknight" },
    { key="Druid",       icon="filter_druid"       },
    { key="Hunter",      icon="filter_hunter"      },
    { key="Mage",        icon="filter_mage"        },
    { key="Paladin",     icon="filter_paladin"     },
    { key="Priest",      icon="filter_priest"      },
    { key="Rogue",       icon="filter_rogue"       },
    { key="Shaman",      icon="filter_shaman"      },
    { key="Warlock",     icon="filter_warlock"     },
    { key="Warrior",     icon="filter_warrior"     },
    { key="none",        icon="filter_none"        },   -- « None » = reset
  }

  -- 3. Helper : create class filter button
  local function AddFilterButton(info, idx)
    local x = -26 * (idx - 1)                 -- même pas : -26, -52, …
    local texture = "Interface\\AddOns\\MultiBot\\Icons\\" .. info.icon .. ".blp"

    local btn = tFilter.addButton(info.key, x, 0, texture,
                                  MultiBot.tips.units[string.lower(info.key)])

    btn.doLeft = function(b)
      local unitsBtn = MultiBot.frames.MultiBar.buttons.Units
      MultiBot.Select(b.parent.parent, "Filter", b.texture)
      unitsBtn.doLeft(unitsBtn, nil, info.key)
    end
  end

  -- 4. Loop
  for i, data in ipairs(FILTERS) do
    AddFilterButton(data, i)
  end
end

--  We call the function after tControl creation
MultiBot.BuildFilterUI(tControl)

--[[-- UNITS:ROSTER --

local tButton = tControl.addButton("Roster", 0, 30, "Interface\\AddOns\\MultiBot\\Icons\\roster_players.blp", MultiBot.tips.units.roster)
tButton.doRight = function(pButton)
	local tButton = MultiBot.frames["MultiBar"].buttons["Units"]
	MultiBot.Select(pButton.parent, "Roster", "Interface\\AddOns\\MultiBot\\Icons\\roster_players.blp")
	tButton.doLeft(tButton, "players")
end
tButton.doLeft = function(pButton)
	MultiBot.ShowHideSwitch(pButton.parent.frames["Roster"])
end

local tRoster = tControl.addFrame("Roster", -30, 32)
tRoster:Hide()

tRoster.addButton("Friends", 0, 0, "Interface\\AddOns\\MultiBot\\Icons\\roster_friends.blp", MultiBot.tips.units.friends)
.doLeft = function(pButton)
	local tButton = MultiBot.frames["MultiBar"].buttons["Units"]
	MultiBot.Select(pButton.parent.parent, "Roster", pButton.texture)
	pButton.parent.parent.buttons["Invite"].setEnable()
	pButton.parent.parent.frames["Invite"]:Hide()
	tButton.doLeft(tButton, "friends")
end

tRoster.addButton("Members", -26, 0, "Interface\\AddOns\\MultiBot\\Icons\\roster_members.blp", MultiBot.tips.units.members)
.doLeft = function(pButton)
	local tButton = MultiBot.frames["MultiBar"].buttons["Units"]
	MultiBot.Select(pButton.parent.parent, "Roster", pButton.texture)
	pButton.parent.parent.buttons["Invite"].setEnable()
	pButton.parent.parent.frames["Invite"]:Hide()
	tButton.doLeft(tButton, "members")
end

tRoster.addButton("Players", -52, 0, "Interface\\AddOns\\MultiBot\\Icons\\roster_players.blp", MultiBot.tips.units.players)
.doLeft = function(pButton)
	local tButton = MultiBot.frames["MultiBar"].buttons["Units"]
	MultiBot.Select(pButton.parent.parent, "Roster", pButton.texture)
	pButton.parent.parent.buttons["Invite"].setEnable()
	pButton.parent.parent.frames["Invite"]:Hide()
	tButton.doLeft(tButton, "players")
end

tRoster.addButton("Actives", -78, 0, "Interface\\AddOns\\MultiBot\\Icons\\roster_actives.blp", MultiBot.tips.units.actives)
.doLeft = function(pButton)
	local tButton = MultiBot.frames["MultiBar"].buttons["Units"]
	MultiBot.Select(pButton.parent.parent, "Roster", pButton.texture)
	pButton.parent.parent.buttons["Invite"].setDisable()
	pButton.parent.parent.frames["Invite"]:Hide()
	tButton.doLeft(tButton, "actives")
end]]--

-- UNITS:ROSTER REFACTORED --
function MultiBot.BuildRosterUI(tControl)

  -- 1. Main Button
  local rootBtn = tControl.addButton("Roster", 0, 30,
                                     "Interface\\AddOns\\MultiBot\\Icons\\roster_players.blp",
                                     MultiBot.tips.units.roster)

  -- Left Click = toggle sub frame  |  Right Click = select “Players”
  rootBtn.doLeft  = function(b) MultiBot.ShowHideSwitch(b.parent.frames.Roster) end
  rootBtn.doRight = function(b)
    local unitsBtn = MultiBot.frames.MultiBar.buttons.Units
    MultiBot.Select(b.parent, "Roster",
                    "Interface\\AddOns\\MultiBot\\Icons\\roster_players.blp")
    unitsBtn.doLeft(unitsBtn, "players")
  end

  -- 2. Frame and Config Table
  local tRoster = tControl.addFrame("Roster", -30, 32) ; tRoster:Hide()

  local ROSTER_MODES = {
    -- key          icon                   Button        tooltip-key
    { id="friends", icon="roster_friends", invite=true,  tip="friends" },
    { id="members", icon="roster_members", invite=true,  tip="members" },
    { id="players", icon="roster_players", invite=true,  tip="players" },
    { id="actives", icon="roster_actives", invite=false, tip="actives" },
  }

  -- 3. Helper bouton Roster
  local function AddRosterButton(cfg, idx)
    local x = -26 * (idx-1)
    local tex = "Interface\\AddOns\\MultiBot\\Icons\\" .. cfg.icon .. ".blp"

    local btn = tRoster.addButton(cfg.id:gsub("^%l", string.upper), x, 0,
                                  tex, MultiBot.tips.units[cfg.tip])

    btn.doLeft = function(b)
      local unitsBtn = MultiBot.frames.MultiBar.buttons.Units
      MultiBot.Select(b.parent.parent, "Roster", b.texture)

      if cfg.invite then
        b.parent.parent.buttons.Invite.setEnable()
      else
        b.parent.parent.buttons.Invite.setDisable()
      end
      b.parent.parent.frames.Invite:Hide()

      unitsBtn.doLeft(unitsBtn, cfg.id)
    end
  end

  -- 4. Loop
  for i, cfg in ipairs(ROSTER_MODES) do
    AddRosterButton(cfg, i)
  end
end

--  Function call
MultiBot.BuildRosterUI(tControl)

-- UNITS:BROWSE --

local tButton = tControl.addButton("Invite", 0, 60, "Interface\\AddOns\\MultiBot\\Icons\\invite.blp", MultiBot.tips.units.invite).setEnable()
tButton.doRight = function(pButton)
	if(GetNumRaidMembers() > 0 or GetNumPartyMembers() > 0) then
		return SendChatMessage(".playerbot bot remove *", "SAY")
	else
		MultiBot.timer.invite.roster = MultiBot.frames["MultiBar"].buttons["Units"].roster
		MultiBot.timer.invite.needs = table.getn(MultiBot.index[MultiBot.timer.invite.roster])
		MultiBot.timer.invite.index = 1
		MultiBot.auto.invite = true
		SendChatMessage(MultiBot.info.starting, "SAY")
	end
end
tButton.doLeft = function(pButton)
	if(pButton.state) then MultiBot.ShowHideSwitch(pButton.parent.frames["Invite"]) end
end

local tInvite = tControl.addFrame("Invite", -30, 62)
tInvite:Hide()

tInvite.addButton("Party+5", 0, 0, "Interface\\AddOns\\MultiBot\\Icons\\invite_party_5.blp", MultiBot.tips.units.inviteParty5)
.doLeft = function(pButton)
	if(MultiBot.auto.invite) then return SendChatMessage(MultiBot.info.wait, "SAY") end
	local tRaid = GetNumRaidMembers()
	local tParty = GetNumPartyMembers()
	MultiBot.timer.invite.roster = MultiBot.frames["MultiBar"].buttons["Units"].roster
	MultiBot.timer.invite.needs = MultiBot.IF(tRaid > 0, 5 - tRaid, MultiBot.IF(tParty > 0, 4 - tParty, 4))
	MultiBot.timer.invite.index = 1
	MultiBot.auto.invite = true
	pButton.parent:Hide()
	SendChatMessage(MultiBot.info.starting, "SAY")
end

tInvite.addButton("Raid+10", 56, 0, "Interface\\AddOns\\MultiBot\\Icons\\invite_raid_10.blp", MultiBot.tips.units.inviteRaid10)
.doLeft = function(pButton)
	if(MultiBot.auto.invite) then return SendChatMessage(MultiBot.info.wait, "SAY") end
	local tRaid = GetNumRaidMembers()
	local tParty = GetNumPartyMembers()
	MultiBot.timer.invite.roster = MultiBot.frames["MultiBar"].buttons["Units"].roster
	MultiBot.timer.invite.needs = 10 - MultiBot.IF(tRaid > 0, tRaid, MultiBot.IF(tParty > 0, tParty + 1, 1))
	MultiBot.timer.invite.index = 1
	MultiBot.auto.invite = true
	pButton.parent:Hide()
	SendChatMessage(MultiBot.info.starting, "SAY")
end

tInvite.addButton("Raid+25", 82, 0, "Interface\\AddOns\\MultiBot\\Icons\\invite_raid_25.blp", MultiBot.tips.units.inviteRaid25)
.doLeft = function(pButton)
	if(MultiBot.auto.invite) then return SendChatMessage(MultiBot.info.wait, "SAY") end
	local tRaid = GetNumRaidMembers()
	local tParty = GetNumPartyMembers()
	MultiBot.timer.invite.roster = MultiBot.frames["MultiBar"].buttons["Units"].roster
	MultiBot.timer.invite.needs = 25 - MultiBot.IF(tRaid > 0, tRaid, MultiBot.IF(tParty > 0, tParty + 1, 1))
	MultiBot.timer.invite.index = 1
	MultiBot.auto.invite = true
	pButton.parent:Hide()
	SendChatMessage(MultiBot.info.starting, "SAY")
end

tInvite.addButton("Raid+40", 108, 0, "Interface\\AddOns\\MultiBot\\Icons\\invite_raid_40.blp", MultiBot.tips.units.inviteRaid40)
.doLeft = function(pButton)
	if(MultiBot.auto.invite) then return SendChatMessage(MultiBot.info.wait, "SAY") end
	local tRaid = GetNumRaidMembers()
	local tParty = GetNumPartyMembers()
	MultiBot.timer.invite.roster = MultiBot.frames["MultiBar"].buttons["Units"].roster
	MultiBot.timer.invite.needs = 40 - MultiBot.IF(tRaid > 0, tRaid, MultiBot.IF(tParty > 0, tParty + 1, 1))
	MultiBot.timer.invite.index = 1
	MultiBot.auto.invite = true
	pButton.parent:Hide()
	SendChatMessage(MultiBot.info.starting, "SAY")
end

tControl.addButton("Browse", 0, 90, "Interface\\AddOns\\MultiBot\\Icons\\browse.blp", MultiBot.tips.units.browse)
.doLeft = function(pButton)
	local tMaster = MultiBot.frames["MultiBar"].buttons["Units"]
	local tFrom = tMaster.from + 10
	local tTo = tMaster.to + 10
	
	if(tMaster.filter ~= "none")
	then tTable = MultiBot.index.classes[tMaster.roster][tMaster.filter]
	else tTable = MultiBot.index[tMaster.roster]
	end
	
	local tUnits = tMaster.parent.frames["Units"]
	local tButton = nil
	local tFrame = nil
	local tIndex = 0
	
	if(tFrom > tMaster.limit) then
		tFrom = 1
		tTo = 10
	end
	
	if(tTo > tMaster.limit) then
		tTo = tMaster.limit
	end
	
	for i = 1, tMaster.limit do
		tFrame = tUnits.frames[tTable[i]]
		tButton = tUnits.buttons[tTable[i]]
		
		if(tMaster.from <= i and tMaster.to >= i) then
			if(tFrame ~= nil) then tFrame:Hide() end
			tButton:Hide()
		end
		
		if(tFrom <= i and tTo >= i) then
			tIndex = tIndex + 1
			if(tFrame ~= nil and tButton.state) then tFrame:Show() end 
			tButton:Show()
		end
	end
	
	tMaster.from = tFrom
	tMaster.to = tTo
	
	tUnits.frames["Control"].setPoint(-2, (tUnits.size + 2) * tIndex)
end

-- MAIN --

local tButton = tMultiBar.addButton("Main", 0, 0, "inv_gizmo_02", MultiBot.tips.main.master)
tButton:RegisterForDrag("RightButton")
tButton:SetScript("OnDragStart", function()
	MultiBot.frames["MultiBar"]:StartMoving()
end)
tButton:SetScript("OnDragStop", function()
	MultiBot.frames["MultiBar"]:StopMovingOrSizing()
end)
tButton.doLeft = function(pButton)
	MultiBot.ShowHideSwitch(pButton.parent.frames["Main"])
end

local tMain = tMultiBar.addFrame("Main", -2, 38)
tMain:Hide()

tMain.addButton("Coords", 0, 0, "inv_gizmo_03", MultiBot.tips.main.coords)
.doLeft = function(pButton)
	MultiBot.frames["MultiBar"].setPoint(-262, 144)
	MultiBot.inventory.setPoint(-700, -144)
	MultiBot.spellbook.setPoint(-802, 302)
	MultiBot.talent.setPoint(-104, -276)
	MultiBot.reward.setPoint(-754,  238)
	MultiBot.itemus.setPoint(-860, -144)
	MultiBot.iconos.setPoint(-860, -144)
	MultiBot.stats.setPoint(-60, 560)
end

tMain.addButton("Masters", 0, 34, "mail_gmicon", MultiBot.tips.main.masters).setDisable()
.doLeft = function(pButton)
	if(MultiBot.GM == false) then return SendChatMessage(MultiBot.info.rights, "SAY") end
	if(MultiBot.OnOffSwitch(pButton)) then
		MultiBot.doRepos("Right", 38)
		MultiBot.frames["MultiBar"].frames["Masters"]:Hide()
		MultiBot.frames["MultiBar"].buttons["Masters"]:Show()
	else
		MultiBot.doRepos("Right", -38)
		MultiBot.frames["MultiBar"].frames["Masters"]:Hide()
		MultiBot.frames["MultiBar"].buttons["Masters"]:Hide()
	end
end

tMain.addButton("RTSC", 0, 68, "ability_hunter_markedfordeath", MultiBot.tips.main.rtsc).setDisable()
.doLeft = function(pButton)
	if(MultiBot.OnOffSwitch(pButton)) then
		MultiBot.frames["MultiBar"].setPoint(MultiBot.frames["MultiBar"].x, MultiBot.frames["MultiBar"].y + 34)
		MultiBot.frames["MultiBar"].frames["RTSC"]:Show()
		MultiBot.ActionToGroup("rtsc")
	else
		MultiBot.frames["MultiBar"].setPoint(MultiBot.frames["MultiBar"].x, MultiBot.frames["MultiBar"].y - 34)
		MultiBot.frames["MultiBar"].frames["RTSC"]:Hide()
		MultiBot.ActionToGroup("rtsc reset")
	end
end

tMain.addButton("Raidus", 0, 102, "inv_misc_head_dragon_01", MultiBot.tips.main.raidus).setDisable()
.doLeft = function(pButton)
	if(MultiBot.OnOffSwitch(pButton)) then
		MultiBot.raidus.setRaidus()
		MultiBot.raidus:Show()
	else
		MultiBot.raidus:Hide()
	end
end

tMain.addButton("Creator", 0, 136, "inv_helmet_145a", MultiBot.tips.main.creator).setDisable()
.doLeft = function(pButton)
	if(MultiBot.OnOffSwitch(pButton)) then
		MultiBot.doRepos("Tanker", -34)
		MultiBot.doRepos("Attack", -34)
		MultiBot.doRepos("Mode", -34)
		MultiBot.doRepos("Stay", -34)
		MultiBot.doRepos("Follow", -34)
		MultiBot.doRepos("ExpandStay", -34)
		MultiBot.doRepos("ExpandFollow", -34)
		MultiBot.doRepos("Flee", -34)
		MultiBot.doRepos("Format", -34)
		MultiBot.doRepos("Beast", -34)
		MultiBot.frames["MultiBar"].frames["Left"].frames["Creator"]:Hide()
		MultiBot.frames["MultiBar"].frames["Left"].buttons["Creator"]:Show()
	else
		MultiBot.doRepos("Tanker", 34)
		MultiBot.doRepos("Attack", 34)
		MultiBot.doRepos("Mode", 34)
		MultiBot.doRepos("Stay", 34)
		MultiBot.doRepos("Follow", 34)
		MultiBot.doRepos("ExpandStay", 34)
		MultiBot.doRepos("ExpandFollow", 34)
		MultiBot.doRepos("Flee", 34)
		MultiBot.doRepos("Format", 34)
		MultiBot.doRepos("Beast", 34)
		MultiBot.frames["MultiBar"].frames["Left"].frames["Creator"]:Hide()
		MultiBot.frames["MultiBar"].frames["Left"].buttons["Creator"]:Hide()
	end
end

tMain.addButton("Beast", 0, 170, "ability_mount_swiftredwindrider", MultiBot.tips.main.beast).setDisable()
.doLeft = function(pButton)
	if(MultiBot.OnOffSwitch(pButton)) then
		MultiBot.doRepos("Tanker", -34)
		MultiBot.doRepos("Attack", -34)
		MultiBot.doRepos("Mode", -34)
		MultiBot.doRepos("Stay", -34)
		MultiBot.doRepos("Follow", -34)
		MultiBot.doRepos("ExpandStay", -34)
		MultiBot.doRepos("ExpandFollow", -34)
		MultiBot.doRepos("Flee", -34)
		MultiBot.doRepos("Format", -34)
		MultiBot.frames["MultiBar"].frames["Left"].frames["Beast"]:Hide()
		MultiBot.frames["MultiBar"].frames["Left"].buttons["Beast"]:Show()
	else
		MultiBot.doRepos("Tanker", 34)
		MultiBot.doRepos("Attack", 34)
		MultiBot.doRepos("Mode", 34)
		MultiBot.doRepos("Stay", 34)
		MultiBot.doRepos("Follow", 34)
		MultiBot.doRepos("ExpandStay", 34)
		MultiBot.doRepos("ExpandFollow", 34)
		MultiBot.doRepos("Flee", 34)
		MultiBot.doRepos("Format", 34)
		MultiBot.frames["MultiBar"].frames["Left"].frames["Beast"]:Hide()
		MultiBot.frames["MultiBar"].frames["Left"].buttons["Beast"]:Hide()
	end
end

--[[
local tButton = tMain.addButton("Language", 0, 34, "Interface\\AddOns\\MultiBot\\Icons\\language_none.blp", MultiBot.tips.main.lang.master).setDisable()
tButton.doRight = function(pButton)
	MultiBot.auto.language = MultiBot.OnOffSwitch(pButton) == false
end
tButton.doLeft = function(pButton)
	if(MultiBot.auto.language == true) then return SendChatMessage(MultiBot.info.language, "SAY") end
	MultiBot.ShowHideSwitch(pButton.parent.frames["Language"])
end

local tFrame = tMain.addFrame("Language", -36, 36)
tFrame:Hide()

tFrame.addButton("deDE", 0, 0, "Interface\\AddOns\\MultiBot\\Icons\\language_deDE.blp", MultiBot.tips.main.lang.deDE)
.doLeft = function(pButton)
	MultiBot.Select(pButton.parent.parent, "Language", pButton.texture)
	MultiBot.doSlash("/reload")
	MultiBot.language = "deDE"
end

tFrame.addButton("enGB", -30, 0, "Interface\\AddOns\\MultiBot\\Icons\\language_enGB.blp", MultiBot.tips.main.lang.enGB)
.doLeft = function(pButton)
	MultiBot.Select(pButton.parent.parent, "Language", pButton.texture)
	MultiBot.doSlash("/reload")
	MultiBot.language = "enGB"
end

tFrame.addButton("None", -60, 0, "Interface\\AddOns\\MultiBot\\Icons\\language_none.blp", MultiBot.tips.main.lang.none)
.doLeft = function(pButton)
	MultiBot.Select(pButton.parent.parent, "Language", pButton.texture)
	MultiBot.doSlash("/reload")
	MultiBot.language = "none"
end
]]--

tMain.addButton("Expand", 0, 204, "Interface\\AddOns\\MultiBot\\Icons\\command_follow.blp", MultiBot.tips.main.expand).setDisable()
.doLeft = function(pButton)
	if(MultiBot.OnOffSwitch(pButton)) then
		MultiBot.doRepos("Tanker", -34)
		MultiBot.doRepos("Attack", -34)
		MultiBot.doRepos("Mode", -34)
		MultiBot.frames["MultiBar"].frames["Left"].buttons["ExpandFollow"]:Show()
		MultiBot.frames["MultiBar"].frames["Left"].buttons["ExpandStay"]:Show()
		MultiBot.frames["MultiBar"].frames["Left"].buttons["Follow"]:Hide()
		MultiBot.frames["MultiBar"].frames["Left"].buttons["Stay"]:Hide()
	else
		MultiBot.doRepos("Tanker", 34)
		MultiBot.doRepos("Attack", 34)
		MultiBot.doRepos("Mode", 34)
		MultiBot.frames["MultiBar"].frames["Left"].buttons["ExpandFollow"]:Hide()
		MultiBot.frames["MultiBar"].frames["Left"].buttons["ExpandStay"]:Hide()
		MultiBot.frames["MultiBar"].frames["Left"].buttons["Follow"]:Show()
		MultiBot.frames["MultiBar"].frames["Left"].buttons["Stay"]:Show()
	end
end

tMain.addButton("Release", 0, 238, "achievement_bg_xkills_avgraveyard", MultiBot.tips.main.release).setDisable()
.doLeft = function(pButton)
	if(MultiBot.OnOffSwitch(pButton)) then
		MultiBot.auto.release = true
	else
		MultiBot.auto.release = false
	end
end

tMain.addButton("Stats", 0, 272, "inv_scroll_08", MultiBot.tips.main.stats).setDisable()
.doLeft = function(pButton)
	if(GetNumRaidMembers() > 0) then return SendChatMessage(MultiBot.info.stats, "SAY") end
	if(MultiBot.OnOffSwitch(pButton)) then
		MultiBot.auto.stats = true
		for i = 1, GetNumPartyMembers() do SendChatMessage("stats", "WHISPER", nil, UnitName("party" .. i)) end
		MultiBot.stats:Show()
	else
		MultiBot.auto.stats = false
		for key, value in pairs(MultiBot.stats.frames) do value:Hide() end
		MultiBot.stats:Hide()
	end
end

local tButton = tMain.addButton("Reward", 0, 306, "Interface\\AddOns\\MultiBot\\Icons\\reward.blp", MultiBot.tips.main.reward).setDisable()
tButton.doRight = function(pButton)
	if(table.getn(MultiBot.reward.rewards) > 0 and table.getn(MultiBot.reward.units) > 0) then MultiBot.reward:Show() end
end
tButton.doLeft = function(pButton)
	MultiBot.reward.state = MultiBot.OnOffSwitch(pButton)
end

tMain.addButton("Reset", 0, 340, "inv_misc_tournaments_symbol_gnome", MultiBot.tips.main.reset)
.doLeft = function(pButton)
	MultiBot.ActionToTargetOrGroup("reset botAI")
end

tMain.addButton("Actions", 0, 374, "inv_helmet_02", MultiBot.tips.main.action)
.doLeft = function(pButton)
	MultiBot.ActionToTargetOrGroup("reset")
end

--[[-- GAMEMASTER --

local tButton = tMultiBar.addButton("Masters", 38, 0, "mail_gmicon", MultiBot.tips.game.master).doHide()
tButton.doRight = function(pButton)
	MultiBot.doSlash("/MultiBot", "")
end
tButton.doLeft = function(pButton)
	MultiBot.ShowHideSwitch(pButton.parent.frames["Masters"])
end

local tMasters = tMultiBar.addFrame("Masters", 36, 38)
tMasters:Hide()

tMasters.addButton("NecroNet", 0, 0, "achievement_bg_xkills_avgraveyard", MultiBot.tips.game.necronet).setDisable()
.doLeft = function(pButton)
	if(pButton.state) then
		MultiBot.necronet.state = false
		for key, value in pairs(MultiBot.necronet.buttons) do value:Hide() end
		pButton.setDisable()
	else
		MultiBot.necronet.cont = 0
		MultiBot.necronet.area = 0
		MultiBot.necronet.zone = 0
		MultiBot.necronet.state = true
		pButton.setEnable()
	end
end

tMasters.addButton("Portal", 0, 34, "inv_box_02", MultiBot.tips.game.portal)
.doLeft = function(pButton)
	MultiBot.ShowHideSwitch(pButton.parent.frames["Portal"])
end

local tPortal = tMasters.addFrame("Portal", 30, 36)
tPortal:Hide()

local tButton = tPortal.addButton("Red", 0, 0, "inv_jewelcrafting_gem_16", MultiBot.doReplace(MultiBot.tips.game.memory, "ABOUT", MultiBot.info.location)).setDisable()
tButton.goMap = ""
tButton.goX = 0
tButton.goY = 0
tButton.goZ = 0

tButton.doRight = function(pButton)
	if(pButton.state == false) then return SendChatMessage(MultiBot.info.itlocation, "SAY") end
	pButton.tip = MultiBot.doReplace(MultiBot.tips.game.memory, "ABOUT", MultiBot.info.location)
	pButton.setDisable()
end
tButton.doLeft = function(pButton)
	local tPlayer = MultiBot.getBot(UnitName("player"))
	if(tPlayer.waitFor == nil) then tPlayer.waitFor = "" end
	if(tPlayer.waitFor ~= "") then return SendChatMessage(MultiBot.info.saving, "SAY") end
	if(pButton.state) then return SendChatMessage(".go xyz " .. pButton.goX .. " " .. pButton.goY .. " " .. pButton.goZ .. " " .. pButton.goMap, "SAY")	end
	tPlayer.memory = pButton
	tPlayer.waitFor = "COORDS"
	SendChatMessage(".gps", "SAY")
end

local tButton = tPortal.addButton("Green", 30, 0, "inv_jewelcrafting_gem_13", MultiBot.doReplace(MultiBot.tips.game.memory, "ABOUT", MultiBot.info.location)).setDisable()
tButton.goMap = ""
tButton.goX = 0
tButton.goY = 0
tButton.goZ = 0

tButton.doRight = function(pButton)
	if(pButton.state == false) then return SendChatMessage(MultiBot.info.itlocation, "SAY") end
	pButton.tip = MultiBot.doReplace(MultiBot.tips.game.memory, "ABOUT", MultiBot.info.location)
	pButton.setDisable()
end
tButton.doLeft = function(pButton)
	local tPlayer = MultiBot.getBot(UnitName("player"))
	if(tPlayer.waitFor == nil) then tPlayer.waitFor = "" end
	if(tPlayer.waitFor ~= "") then return SendChatMessage(MultiBot.info.saving, "SAY") end
	if(pButton.state) then return SendChatMessage(".go xyz " .. pButton.goX .. " " .. pButton.goY .. " " .. pButton.goZ .. " " .. pButton.goMap, "SAY")	end
	tPlayer.memory = pButton
	tPlayer.waitFor = "COORDS"
	SendChatMessage(".gps", "SAY")
end

local tButton = tPortal.addButton("Blue", 60, 0, "inv_jewelcrafting_gem_17", MultiBot.doReplace(MultiBot.tips.game.memory, "ABOUT", MultiBot.info.location)).setDisable()
tButton.goMap = ""
tButton.goX = 0
tButton.goY = 0
tButton.goZ = 0

tButton.doRight = function(pButton)
	if(pButton.state == false) then return SendChatMessage(MultiBot.info.itlocation, "SAY") end
	pButton.tip = MultiBot.doReplace(MultiBot.tips.game.memory, "ABOUT", MultiBot.info.location)
	pButton.setDisable()
end
tButton.doLeft = function(pButton)
	local tPlayer = MultiBot.getBot(UnitName("player"))
	if(tPlayer.waitFor == nil) then tPlayer.waitFor = "" end
	if(tPlayer.waitFor ~= "") then return SendChatMessage(MultiBot.info.saving, "SAY") end
	if(pButton.state) then return SendChatMessage(".go xyz " .. pButton.goX .. " " .. pButton.goY .. " " .. pButton.goZ .. " " .. pButton.goMap, "SAY")	end
	tPlayer.memory = pButton
	tPlayer.waitFor = "COORDS"
	SendChatMessage(".gps", "SAY")
end

tMasters.addButton("Itemus", 0, 68, "inv_box_01", MultiBot.tips.game.itemus)
.doLeft = function(pButton)
	if(MultiBot.ShowHideSwitch(MultiBot.itemus)) then
		MultiBot.itemus.addItems()
	end
end

tMasters.addButton("Iconos", 0, 102, "inv_mask_01", MultiBot.tips.game.iconos)
.doLeft = function(pButton)
	if(MultiBot.ShowHideSwitch(MultiBot.iconos)) then
		MultiBot.iconos.addIcons()
	end
end

tMasters.addButton("Summon", 0, 136, "spell_holy_prayerofspirit", MultiBot.tips.game.summon)
.doLeft = function(pButton)
	MultiBot.doDotWithTarget(".summon")
end

tMasters.addButton("Appear", 0, 170, "spell_holy_divinespirit", MultiBot.tips.game.appear)
.doLeft = function(pButton)
	MultiBot.doDotWithTarget(".appear")
end

-- DELETE SAVED VARIABLES --
StaticPopupDialogs["MULTIBOT_DELETE_SV"] = {
    text = MultiBot.tips.game.delsvwarning,
    button1 = YES,
    button2 = NO,
    OnAccept = function()
        if wipe then
            wipe(MultiBotGlobalSave)
        else
            for k in pairs(MultiBotGlobalSave) do MultiBotGlobalSave[k] = nil end
        end
        ReloadUI()
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
}

tMasters.addButton("DelSV", 0, 204, "ability_golemstormbolt", MultiBot.tips.game.delsv, "ActionButtonTemplate")

.doLeft = function()
    StaticPopup_Show("MULTIBOT_DELETE_SV")
end]]--

--  GAMEMASTER REFORGED --
function MultiBot.BuildGmUI(tMultiBar)
  -- 1. Main Button in Multibar
  local mainBtn = tMultiBar.addButton("Masters", 38, 0, "mail_gmicon",
                                      MultiBot.tips.game.master)
  mainBtn:doHide()                                      -- masqué par défaut

  mainBtn.doLeft  = function(b) MultiBot.ShowHideSwitch(b.parent.frames["Masters"]) end
  mainBtn.doRight = function()  MultiBot.doSlash("/MultiBot", "")                   end

  -- 2. Frame "Masters" : contain the buttons
  local tMasters = tMultiBar.addFrame("Masters", 36, 38)
  tMasters:Hide()

  -- 3. Button NecroNet (toggle)
  local necroBtn = tMasters.addButton("NecroNet", 0, 0,
                                      "achievement_bg_xkills_avgraveyard",
                                      MultiBot.tips.game.necronet)
  necroBtn:setDisable()

  necroBtn.doLeft = function(b)
    if b.state then          -- ON/OFF
      MultiBot.necronet.state = false
      for _, v in pairs(MultiBot.necronet.buttons) do v:Hide() end
      b:setDisable()
    else                     -- OFF/ON
      MultiBot.necronet.cont = 0
      MultiBot.necronet.area = 0
      MultiBot.necronet.zone = 0
      MultiBot.necronet.state = true
      b:setEnable()
    end
  end

  -- 4. Sub-Frame "Portal" (Red / Green / Blue “memory”)
  local portalBtn = tMasters.addButton("Portal", 0, 34, "inv_box_02",
                                       MultiBot.tips.game.portal)
  local tPortal   = tMasters.addFrame("Portal", 30, 36) ; tPortal:Hide()

  portalBtn.doLeft = function() MultiBot.ShowHideSwitch(tPortal) end

  -- Helper for portal
  local function AddMemoryGem(label, x, icon, tipKey)
    local gem = tPortal.addButton(label, x, 0, icon,
                                  MultiBot.doReplace(MultiBot.tips.game.memory,
                                                      "ABOUT", MultiBot.info.location))
    gem:setDisable()
    gem.goMap, gem.goX, gem.goY, gem.goZ = "",0,0,0

    -- Right click to update/delete
    gem.doRight = function(b)
      if not b.state then
        return SendChatMessage(MultiBot.info.itlocation, "SAY")
      end
      b.tip = MultiBot.doReplace(MultiBot.tips.game.memory, "ABOUT",
                                 MultiBot.info.location)
      b:setDisable()
    end

    -- Left click to Save or teleport
    gem.doLeft = function(b)
      local player = MultiBot.getBot(UnitName("player"))
      player.waitFor = player.waitFor or ""

      if player.waitFor ~= "" then
        return SendChatMessage(MultiBot.info.saving, "SAY")
      end

      if b.state then
        return SendChatMessage(".go xyz " ..
                               b.goX .. " " .. b.goY .. " " .. b.goZ ..
                               " " .. b.goMap, "SAY")
      end

      player.memory  = b
      player.waitFor = "COORDS"
      SendChatMessage(".gps", "SAY")
    end
  end

  -- Adding the 3 gems
  AddMemoryGem("Red",   0,  "inv_jewelcrafting_gem_16",
               MultiBot.tips.game.memory)
  AddMemoryGem("Green", 30, "inv_jewelcrafting_gem_13",
               MultiBot.tips.game.memory)
  AddMemoryGem("Blue",  60, "inv_jewelcrafting_gem_17",
               MultiBot.tips.game.memory)

  -- 5. Shortcuts for : Itemus / Iconos / Summon / Appear
  local UTIL_BUTTONS = {
    { label="Itemus", y= 68, icon="inv_box_01",        tip=MultiBot.tips.game.itemus,
      click=function()
        if MultiBot.ShowHideSwitch(MultiBot.itemus) then
          MultiBot.itemus.addItems()
        end
      end },

    { label="Iconos", y=102, icon="inv_mask_01",       tip=MultiBot.tips.game.iconos,
      click=function()
        if MultiBot.ShowHideSwitch(MultiBot.iconos) then
          MultiBot.iconos.addIcons()
        end
      end },

    { label="Summon", y=136, icon="spell_holy_prayerofspirit", tip=MultiBot.tips.game.summon,
      click=function() MultiBot.doDotWithTarget(".summon") end },

    { label="Appear", y=170, icon="spell_holy_divinespirit",   tip=MultiBot.tips.game.appear,
      click=function() MultiBot.doDotWithTarget(".appear") end },
  }

  for _, b in ipairs(UTIL_BUTTONS) do
    tMasters.addButton(b.label, 0, b.y, b.icon, b.tip).doLeft = b.click
  end

  -- 6. DelSV Button
  StaticPopupDialogs["MULTIBOT_DELETE_SV"] = {
      text         = MultiBot.tips.game.delsvwarning,
      button1      = YES,
      button2      = NO,
      OnAccept     = function()
          if wipe then wipe(MultiBotGlobalSave)
          else          for k in pairs(MultiBotGlobalSave) do MultiBotGlobalSave[k]=nil end end
          ReloadUI()
      end,
      timeout      = 0,   whileDead=true, hideOnEscape=true,
  }

  tMasters.addButton("DelSV", 0, 204, "ability_golemstormbolt",
                     MultiBot.tips.game.delsv, "ActionButtonTemplate")
    .doLeft = function() StaticPopup_Show("MULTIBOT_DELETE_SV") end
end

--  Calling the function
MultiBot.BuildGmUI(tMultiBar)

-- RIGHT --

local tRight = tMultiBar.addFrame("Right", 34, 2, 32)

-- QUESTS MENU --
-- flags par défaut
MultiBot._lastIncMode  = "WHISPER"
MultiBot._lastCompMode = "WHISPER"
MultiBot._lastAllMode       = "WHISPER"
MultiBot._awaitingQuestsAll = false
MultiBot._buildingAllQuests = false
MultiBot._blockOtherQuests = false
-- MultiBot.BotQuestsAll       = MultiBot.BotQuestsAll or {}

-- HIDDEN TOOLTIP TO CATCH LOC --
local LocalizeQuestTooltip = CreateFrame("GameTooltip", "MB_LocalizeQuestTooltip", UIParent, "GameTooltipTemplate")
LocalizeQuestTooltip:SetOwner(UIParent, "ANCHOR_NONE")

local function GetLocalizedQuestName(questID)
    LocalizeQuestTooltip:ClearLines()
    -- construit une hyperlink quest:<ID>
    LocalizeQuestTooltip:SetHyperlink("quest:"..questID)
    -- lit la première ligne du tooltip
    local textObj = _G["MB_LocalizeQuestTooltipTextLeft1"]
    return (textObj and textObj:GetText()) or tostring(questID)
end
-- END HIDDEN TOOLTIP --

-- MAIN BUTTON --
local tButton = tRight.addButton("Quests Menu", 0, 0,
                                 "achievement_quests_completed_06",
                                 MultiBot.tips.quests.main)
local tQuestMenu = tRight.addFrame("QuestMenu", -2, 64)
tQuestMenu:Hide()
tButton.doLeft  = function(p) MultiBot.ShowHideSwitch(p.parent.frames["QuestMenu"]) end
tButton.doRight = tButton.doLeft
-- END MAIN BUTTON --

-- BUTTON Accept * -- 
tQuestMenu.addButton("AcceptAll", 0, 30,
                     "inv_misc_note_02", MultiBot.tips.quests.accept)
.doLeft = function() MultiBot.ActionToGroup("accept *") end
-- END BUTTON Accept * -- 

-- POP-UP Frame for Quests --
local tQuests = CreateFrame("Frame", "MB_QuestPopup", UIParent)
tQuests:SetSize(370, 460)
tQuests:SetPoint("CENTER")
tQuests:SetFrameStrata("DIALOG")
tQuests:SetBackdrop({
    bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile     = true, tileSize = 32, edgeSize = 16,
    insets   = { left = 4, right = 4, top = 4, bottom = 4 }
})
tQuests:EnableMouse(true)
tQuests:SetMovable(true)
tQuests:RegisterForDrag("LeftButton")
tQuests:SetScript("OnDragStart", tQuests.StartMoving)
tQuests:SetScript("OnDragStop",  tQuests.StopMovingOrSizing)
tQuests:Hide()

-- bouton X
local close = CreateFrame("Button", nil, tQuests, "UIPanelCloseButton")
close:SetPoint("TOPRIGHT", -2, -2)

-- barre de titre
local title = tQuests:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -10)
title:SetText("Quêtes du personnage")

-- ScrollFrame + ScrollBar
local scrollFrame = CreateFrame("ScrollFrame", "MB_QuestScroll", tQuests, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 14, -38)
scrollFrame:SetPoint("BOTTOMRIGHT", -30, 14)

local content = CreateFrame("Frame", nil, scrollFrame)
content:SetWidth(1)              -- largeur auto
scrollFrame:SetScrollChild(content)
-- END POP-UP Frame for “Quests” --

-- BUTTON Quests --
local tListBtn = tQuestMenu.addButton("Quests", 0, -30,
                                      "inv_misc_book_07", MultiBot.tips.quests.master)
-- requis par MultiBotHandler
tRight.buttons["Quests"] = tListBtn

-- helpers
local function ClearContent()
    for _, child in ipairs({content:GetChildren()}) do
        child:Hide()
        child:SetParent(nil)
    end
end

local function MemberNamesOnQuest(questIndex)
    local names = {}
    if GetNumRaidMembers() > 0 then
        for n = 1, 40 do
            local unit = "raid"..n
            if UnitExists(unit) and IsUnitOnQuest(questIndex, unit) then
                local name = UnitName(unit)          -- ← récupère juste le nom
                if name then table.insert(names, name) end
            end
        end
    elseif GetNumPartyMembers() > 0 then
        for n = 1, 4 do
            local unit = "party"..n
            if UnitExists(unit) and IsUnitOnQuest(questIndex, unit) then
                local name = UnitName(unit)
                if name then table.insert(names, name) end
            end
        end
    end
    return names
end

-- CLIC DROIT : génère et rafraichit la liste
tListBtn.doRight = function()
    ClearContent()

    local entries = GetNumQuestLogEntries()
    local lineHeight, y = 24, -4

    for i = 1, entries do
        local link  = GetQuestLink(i)
        local questID = tonumber(link and link:match("|Hquest:(%d+):"))
        local title, level, _, header, collapsed = GetQuestLogTitle(i)

        if collapsed == nil then                               -- entrée réelle
            local line = CreateFrame("Frame", nil, content)
            line:SetSize(300, lineHeight)
            line:SetPoint("TOPLEFT", 0, y)

            -- icône
            local icon = line:CreateTexture(nil, "ARTWORK")
            icon:SetTexture("Interface\\Icons\\inv_misc_note_01")
            icon:SetSize(20, 20)
            icon:SetPoint("LEFT")

            -- lien de quête en SimpleHTML
            local html = CreateFrame("SimpleHTML", nil, line)
            html:SetSize(260, 20)
            html:SetPoint("LEFT", 24, 0)
            html:SetFontObject("GameFontNormal")
            html:SetText(link:gsub("%[", "|cff00ff00["):gsub("%]", "]|r"))
            html:SetHyperlinksEnabled(true)

            -- Tooltip
            html:SetScript("OnHyperlinkEnter", function(self, linkData, fullLink)
                GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
                GameTooltip:SetHyperlink(fullLink)

                -- Ajoute les objectifs de la quête
                local numObj = GetNumQuestLeaderBoards(i)
                if numObj and numObj > 0 then
                    for k = 1, numObj do
                        local txtObj, objType, finished = GetQuestLogLeaderBoard(k, i)
                        if txtObj then
                            local r, g, b = finished and 0.5 or 1, finished and 0.5 or 1, finished and 0.5 or 1
                            GameTooltip:AddLine("• "..txtObj, r, g, b)
                        end
                    end
                end

                -- Liste des membres/bots sur la quête
                local members = MemberNamesOnQuest(i)
                if #members > 0 then
                    GameTooltip:AddLine(" ", 1, 1, 1)
                    GameTooltip:AddLine("Groupe :", 0.8, 0.8, 0.8)
                    for _, n in ipairs(members) do GameTooltip:AddLine("- "..n) end
                end

                GameTooltip:Show()
            end)
            html:SetScript("OnHyperlinkLeave", function() GameTooltip:Hide() end)

            -- CLIC SUR LE LIEN DE LA QUETE
            html:SetScript("OnHyperlinkClick", function(self, linkData, link, button)
                if link:match("|Hquest:") then
                    local questIDClicked = tonumber(link:match("|Hquest:(%d+):"))
                    -- Retrouver l'index de la quête dans le journal
                    for idx = 1, GetNumQuestLogEntries() do
                        local qLink = GetQuestLink(idx)
                        if qLink and tonumber(qLink:match("|Hquest:(%d+):")) == questIDClicked then
                            SelectQuestLogEntry(idx)
                            if button == "RightButton" then
                                if GetNumRaidMembers() > 0 then
                                    SendChatMessage("drop "..qLink, "RAID")
                                elseif GetNumPartyMembers() > 0 then
                                    SendChatMessage("drop "..qLink, "PARTY")
                                end
                                SetAbandonQuest()
                                AbandonQuest()
                            else
                                QuestLogPushQuest()
                            end
                            break
                        end
                    end
                end
            end)

            y = y - lineHeight
        end
    end
    content:SetHeight(-y + 4)   -- hauteur totale des lignes
    scrollFrame:SetVerticalScroll(0)  -- remonter en haut
end

-- CLIC GAUCHE : show/hide la fenêtre
tListBtn.doLeft = function()
    if tQuests:IsShown() then
        tQuests:Hide()
    else
        tQuests:Show()
        tListBtn.doRight()
    end
end

-- END BUTTON QUESTS --

-- BUTTON QUESTS INCOMPLETED with sub buttons --
-- Table de stockage
MultiBot.BotQuestsIncompleted = {}  -- [botName] = { [questID]=questName, ... }

-- Popup Liste des quêtes du bot
local tBotPopup = CreateFrame("Frame", "MB_BotQuestPopup", UIParent)
tBotPopup:SetSize(360, 400)
tBotPopup:SetPoint("CENTER")
tBotPopup:SetFrameStrata("DIALOG")
tBotPopup:SetBackdrop({
    bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile     = true, tileSize = 32, edgeSize = 16,
    insets   = { left = 4, right = 4, top = 4, bottom = 4 }
})
tBotPopup:EnableMouse(true)
tBotPopup:SetMovable(true)
tBotPopup:RegisterForDrag("LeftButton")
tBotPopup:SetScript("OnDragStart", tBotPopup.StartMoving)
tBotPopup:SetScript("OnDragStop",  tBotPopup.StopMovingOrSizing)
tBotPopup:Hide()

local closeBtn = CreateFrame("Button", nil, tBotPopup, "UIPanelCloseButton")
closeBtn:SetPoint("TOPRIGHT", -2, -2)

local header = tBotPopup:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
header:SetPoint("TOP", 0, -10)
header:SetText(MultiBot.tips.quests.incomplist)

local scroll = CreateFrame("ScrollFrame", "MB_BotQuestScroll", tBotPopup, "UIPanelScrollFrameTemplate")
scroll:SetPoint("TOPLEFT", 14, -38)
scroll:SetPoint("BOTTOMRIGHT", -30, 14)

local contentBot = CreateFrame("Frame", nil, scroll)
contentBot:SetWidth(1)
scroll:SetScrollChild(contentBot)

MultiBot.tBotPopup = tBotPopup

local function ClearBotContent()
    for _, child in ipairs({ contentBot:GetChildren() }) do
        child:Hide()
        child:SetParent(nil)
    end
end

-- AJOUT ON VIDE TOUT
tBotPopup:SetScript("OnHide", function()
    MultiBot.BotQuestsIncompleted = {}
    ClearBotContent()
end)
-- Fin de l’ajout

local function BuildBotQuestList(botName)
    ClearBotContent()
    local quests = MultiBot.BotQuestsIncompleted[botName] or {}
    local y = -4
    for id, name in pairs(quests) do
        local line = CreateFrame("Frame", nil, contentBot)
        line:SetSize(300, 24)
        line:SetPoint("TOPLEFT", 0, y)

        local icon = line:CreateTexture(nil, "ARTWORK")
        icon:SetTexture("Interface\\Icons\\inv_misc_note_02")
        icon:SetSize(20,20)
        icon:SetPoint("LEFT")

        local locName = GetLocalizedQuestName(id) or name
        local link = ("|cff00ff00|Hquest:%s:0|h[%s]|h|r"):format(id, locName)
        local html = CreateFrame("SimpleHTML", nil, line)
        html:SetSize(260, 20)
        html:SetPoint("LEFT", 24, 0)
        html:SetFontObject("GameFontNormal")
        html:SetText(link)
        html:SetHyperlinksEnabled(true)
        html:SetScript("OnHyperlinkEnter", function(self, linkData, link)
            GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
            GameTooltip:SetHyperlink(link)
            GameTooltip:Show()
        end)
        html:SetScript("OnHyperlinkLeave", function() GameTooltip:Hide() end)

        y = y - 24
    end
    contentBot:SetHeight(-y + 4)
    scroll:SetVerticalScroll(0)
end

MultiBot.BuildBotQuestList = BuildBotQuestList

-- Reconstruit la popup en mode GROUP on agrège toutes les quêtes
local function BuildAggregatedQuestList()
    ClearBotContent()

    -- Construit la table id { name = ..., bots = { … } }
    local questMap = {}
    for botName, quests in pairs(MultiBot.BotQuestsIncompleted) do
        for id, name in pairs(quests) do
            local locName = GetLocalizedQuestName(id) or name
            if not questMap[id] then
                questMap[id] = { name = locName, bots = {} }
            end
            table.insert(questMap[id].bots, botName)
        end
    end

    -- 2Affiche chaque quête puis la ligne des bots
    local y = -4
    for id, data in pairs(questMap) do
        -- ligne quête
        local lineQ = CreateFrame("Frame", nil, contentBot)
        lineQ:SetSize(300, 24)
        lineQ:SetPoint("TOPLEFT", 0, y)

        -- icône
        local icon = lineQ:CreateTexture(nil, "ARTWORK")
        icon:SetTexture("Interface\\Icons\\inv_misc_note_02")
        icon:SetSize(20,20)
        icon:SetPoint("LEFT")

        -- lien cliquable
        local link = ("|cff00ff00|Hquest:%s:0|h[%s]|h|r"):format(id, data.name)
        local htmlQ = CreateFrame("SimpleHTML", nil, lineQ)
        htmlQ:SetSize(260, 20)
        htmlQ:SetPoint("LEFT", 24, 0)
        htmlQ:SetFontObject("GameFontNormal")
        htmlQ:SetText(link)
        htmlQ:SetHyperlinksEnabled(true)
        htmlQ:SetScript("OnHyperlinkEnter", function(self, linkData, link)
            GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
            GameTooltip:SetHyperlink(link)
            GameTooltip:Show()
        end)
        htmlQ:SetScript("OnHyperlinkLeave", function() GameTooltip:Hide() end)

        y = y - 24

        -- ligne bots
        local lineB = CreateFrame("Frame", nil, contentBot)
        lineB:SetSize(300, 16)
        lineB:SetPoint("TOPLEFT", 0, y)

        local botLine = lineB:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
        botLine:SetPoint("LEFT", 24, 0)
        botLine:SetText(MultiBot.tips.quests.botsword.. table.concat(data.bots, ", "))

        y = y - 16
    end

    contentBot:SetHeight(-y + 4)
    scroll:SetVerticalScroll(0)
end

-- Expose la fonction pour l’appeler depuis le handler
MultiBot.BuildAggregatedQuestList = BuildAggregatedQuestList

-- Bouton principal + deux sous-boutons pour choisir /p ou /w
local btnIncomp = tQuestMenu.addButton("BotQuestsIncomp", 0, 90,
    "Interface\\Icons\\INV_Misc_Bag_22",
    MultiBot.tips.quests.incompleted)

local btnGroup = tQuestMenu.addButton("BotQuestsIncompGroup", 31, 90,
                                        "Interface\\Icons\\INV_Crate_08",
                                        MultiBot.tips.quests.sendpartyraid)
btnGroup:doHide()

local btnWhisper = tQuestMenu.addButton("BotQuestsIncompWhisper", 61, 90,
                                          "Interface\\Icons\\INV_Crate_08",
                                          MultiBot.tips.quests.sendwhisp)
btnWhisper:doHide()

local function SendIncomp(method)

MultiBot._awaitingQuestsAll = false
	MultiBot._lastIncMode = method
    if method == "WHISPER" then
        local bot = UnitName("target")
        if not bot or not UnitIsPlayer("target") then
            UIErrorsFrame:AddMessage(MultiBot.tips.quests.questcomperror, 1, 0.2, 0.2, 1)
            return
        end
        -- reset juste pour ce bot
        MultiBot.BotQuestsIncompleted[bot] = {}
        -- envoi en whisper ciblé
        MultiBot.ActionToTarget("quests incompleted", bot)
        -- popup + liste pour ce bot
        tBotPopup:Show()
        ClearBotContent()
        MultiBot.TimerAfter(0.5, function() BuildBotQuestList(bot) end)
    else
        -- reset global
        MultiBot.BotQuestsIncompleted = {}
        MultiBot.ActionToGroup("quests incompleted")
        -- popup
        tBotPopup:Show()
        ClearBotContent()
    end
end

btnIncomp.doLeft = function()
    if btnGroup:IsShown() then
        btnGroup:doHide()
        btnWhisper:doHide()
    else
        btnGroup:doShow()
        btnWhisper:doShow()
    end
end

btnGroup.doLeft   = function() SendIncomp("GROUP")   end
btnWhisper.doLeft = function() SendIncomp("WHISPER") end

-- Expose pour le handler
tRight.buttons["BotQuestsIncomp"]        = btnIncomp
tRight.buttons["BotQuestsIncompGroup"]   = btnGroup
tRight.buttons["BotQuestsIncompWhisper"] = btnWhisper
-- END BUTTON quests incompleted --


-- BUTTON  COMPLETEDQUESTS --
-- Table de stockage pour les quêtes terminées du bot
MultiBot.BotQuestsCompleted = {}  -- [botName] = { [questID]=questName, ... }

-- 2) Pop-up Liste des quêtes terminées du bot
local tBotCompPopup = CreateFrame("Frame", "MB_BotQuestCompPopup", UIParent)
tBotCompPopup:SetSize(360, 400)
tBotCompPopup:SetPoint("CENTER")
tBotCompPopup:SetFrameStrata("DIALOG")
tBotCompPopup:SetBackdrop({
    bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile     = true, tileSize = 32, edgeSize = 16,
    insets   = { left = 4, right = 4, top = 4, bottom = 4 }
})
tBotCompPopup:EnableMouse(true)
tBotCompPopup:SetMovable(true)
tBotCompPopup:RegisterForDrag("LeftButton")
tBotCompPopup:SetScript("OnDragStart", tBotCompPopup.StartMoving)
tBotCompPopup:SetScript("OnDragStop",  tBotCompPopup.StopMovingOrSizing)
tBotCompPopup:Hide()

local closeBtn2 = CreateFrame("Button", nil, tBotCompPopup, "UIPanelCloseButton")
closeBtn2:SetPoint("TOPRIGHT", -2, -2)

local header2 = tBotCompPopup:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
header2:SetPoint("TOP", 0, -10)
header2:SetText(MultiBot.tips.quests.complist)

local scroll2 = CreateFrame("ScrollFrame", "MB_BotQuestCompScroll", tBotCompPopup, "UIPanelScrollFrameTemplate")
scroll2:SetPoint("TOPLEFT", 14, -38)
scroll2:SetPoint("BOTTOMRIGHT", -30, 14)

local contentComp = CreateFrame("Frame", nil, scroll2)
contentComp:SetWidth(1)
scroll2:SetScrollChild(contentComp)

MultiBot.tBotCompPopup = tBotCompPopup

local function ClearCompContent()
    for _, child in ipairs({ contentComp:GetChildren() }) do
        child:Hide()
        child:SetParent(nil)
    end
end

-- AJOUT ON VIDE TOUT
tBotCompPopup:SetScript("OnHide", function()
    MultiBot.BotQuestsCompleted = {}
    ClearCompContent()
end)
-- Fin de l’ajout

-- Build pour un seul bot
local function BuildBotCompletedList(botName)
    ClearCompContent()
    local quests = MultiBot.BotQuestsCompleted[botName] or {}
    local y = -4
    for id, name in pairs(quests) do
        local line = CreateFrame("Frame", nil, contentComp)
        line:SetSize(300, 24)
        line:SetPoint("TOPLEFT", 0, y)

        local icon = line:CreateTexture(nil, "ARTWORK")
        icon:SetTexture("Interface\\Icons\\inv_misc_note_02")
        icon:SetSize(20,20)
        icon:SetPoint("LEFT")

        local locName = GetLocalizedQuestName(id) or name
        local link = ("|cff00ff00|Hquest:%s:0|h[%s]|h|r"):format(id, locName)
        local html = CreateFrame("SimpleHTML", nil, line)
        html:SetSize(260, 20)
        html:SetPoint("LEFT", 24, 0)
        html:SetFontObject("GameFontNormal")
        html:SetText(link)
        html:SetHyperlinksEnabled(true)
        html:SetScript("OnHyperlinkEnter", function(self, linkData, link)
            GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
            GameTooltip:SetHyperlink(link)
            GameTooltip:Show()
        end)
        html:SetScript("OnHyperlinkLeave", function() GameTooltip:Hide() end)

        y = y - 24
    end
    contentComp:SetHeight(-y + 4)
    scroll2:SetVerticalScroll(0)
end
MultiBot.BuildBotCompletedList = BuildBotCompletedList

-- Build agrégé pour le groupe
local function BuildAggregatedCompletedList()
    ClearCompContent()

    -- On agrège les quêtes terminées de tous les bots
    local questMap = {}
    for botName, quests in pairs(MultiBot.BotQuestsCompleted) do
        for id, name in pairs(quests) do
            local locName = GetLocalizedQuestName(id) or name
            if not questMap[id] then
                questMap[id] = { name = locName, bots = {} }
            end
            table.insert(questMap[id].bots, botName)
        end
    end

    -- On affiche
    local y = -4
    for id, data in pairs(questMap) do
        -- ligne quête
        local lineQ = CreateFrame("Frame", nil, contentComp)
        lineQ:SetSize(300, 24)
        lineQ:SetPoint("TOPLEFT", 0, y)

        local icon = lineQ:CreateTexture(nil, "ARTWORK")
        icon:SetTexture("Interface\\Icons\\inv_misc_note_02")
        icon:SetSize(20, 20)
        icon:SetPoint("LEFT")

        local link = ("|cff00ff00|Hquest:%s:0|h[%s]|h|r"):format(id, data.name)
        local htmlQ = CreateFrame("SimpleHTML", nil, lineQ)
        htmlQ:SetSize(260, 20)
        htmlQ:SetPoint("LEFT", 24, 0)
        htmlQ:SetFontObject("GameFontNormal")
        htmlQ:SetText(link)
        htmlQ:SetHyperlinksEnabled(true)
        htmlQ:SetScript("OnHyperlinkEnter", function(self, linkData, link)
            GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
            GameTooltip:SetHyperlink(link)
            GameTooltip:Show()
        end)
        htmlQ:SetScript("OnHyperlinkLeave", function() GameTooltip:Hide() end)

        y = y - 24

        -- ligne bots
        local lineB = CreateFrame("Frame", nil, contentComp)
        lineB:SetSize(300, 16)
        lineB:SetPoint("TOPLEFT", 0, y)

        local botLine = lineB:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
        botLine:SetPoint("LEFT", 24, 0)
        botLine:SetText(MultiBot.tips.quests.botsword .. table.concat(data.bots, ", "))

        y = y - 16
    end

    contentComp:SetHeight(-y + 4)
    scroll2:SetVerticalScroll(0)
end

-- expose la fonction pour le handler
MultiBot.BuildAggregatedCompletedList = BuildAggregatedCompletedList

-- Les boutons
local btnComp = tQuestMenu.addButton("BotQuestsComp", 0, 60,
    "Interface\\Icons\\INV_Misc_Bag_20",
    MultiBot.tips.quests.completed)

local btnCompGroup = tQuestMenu.addButton("BotQuestsCompGroup", 31, 60,
    "Interface\\Icons\\INV_Crate_09",
    MultiBot.tips.quests.sendpartyraid)
btnCompGroup:doHide()

local btnCompWhisper = tQuestMenu.addButton("BotQuestsCompWhisper", 61, 60,
    "Interface\\Icons\\INV_Crate_09",
    MultiBot.tips.quests.sendwhisp)
btnCompWhisper:doHide()

local function SendComp(method)
MultiBot._awaitingQuestsAll = false
    MultiBot._lastCompMode = method
    if method == "WHISPER" then
        local bot = UnitName("target")
        if not bot or not UnitIsPlayer("target") then
			UIErrorsFrame:AddMessage(MultiBot.tips.quests.questcomperror, 1, 0.2, 0.2, 1)
            return
        end
        MultiBot.BotQuestsCompleted[bot] = {}
        MultiBot.ActionToTarget("quests completed", bot)
        tBotCompPopup:Show()
        ClearCompContent()
        MultiBot.TimerAfter(0.5, function()
            MultiBot.BuildBotCompletedList(bot)
        end)
    else
        -- GROUP
        MultiBot.BotQuestsCompleted = {}
        MultiBot.ActionToGroup("quests completed")
        tBotCompPopup:Show()
        ClearCompContent() 
    end
end

btnComp.doLeft = function()
    if btnCompGroup:IsShown() then
        btnCompGroup:doHide()
        btnCompWhisper:doHide()
    else
        btnCompGroup:doShow()
        btnCompWhisper:doShow()
    end
end
btnCompGroup.doLeft   = function() SendComp("GROUP")   end
btnCompWhisper.doLeft = function() SendComp("WHISPER") end

-- Expose pour le handler
tRight.buttons["BotQuestsComp"]        = btnComp
tRight.buttons["BotQuestsCompGroup"]   = btnCompGroup
tRight.buttons["BotQuestsCompWhisper"] = btnCompWhisper
-- END BUTTON  COMPLETED QUESTS --

-- BUTTON TALK --
local btnTalk = tQuestMenu.addButton("BotQuestsTalk", 0, 0,
    "Interface\\Icons\\ability_hunter_pet_devilsaur",
    MultiBot.tips.quests.talk)

btnTalk.doLeft = function()
    if not UnitExists("target") or UnitIsPlayer("target") then -- On vérifie qu'on cible bien un PNJ
        UIErrorsFrame:AddMessage(MultiBot.tips.quests.talkerror, 1, 0.2, 0.2, 1)
        return
    end
    MultiBot.ActionToGroup("talk") -- Envoie "talk" à tout le groupe ou raid
end

tRight.buttons["BotQuestsTalk"] = btnTalk
-- END BUTTON TALK --

-- BUTTON QUESTS ALL --

-- POPUP Quests All
local tBotAllPopup = CreateFrame("Frame", "MB_BotQuestAllPopup", UIParent)
tBotAllPopup:SetSize(400, 440)
tBotAllPopup:SetPoint("CENTER")
tBotAllPopup:SetFrameStrata("DIALOG")
tBotAllPopup:SetBackdrop({
    bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile     = true, tileSize = 32, edgeSize = 16,
    insets   = { left = 4, right = 4, top = 4, bottom = 4 }
})
tBotAllPopup:EnableMouse(true)
tBotAllPopup:SetMovable(true)
tBotAllPopup:RegisterForDrag("LeftButton")
tBotAllPopup:SetScript("OnDragStart", tBotAllPopup.StartMoving)
tBotAllPopup:SetScript("OnDragStop",  tBotAllPopup.StopMovingOrSizing)
tBotAllPopup:Hide()

-- On expose immédiatement pour qu'il existe dans SendAll
MultiBot.tBotAllPopup = tBotAllPopup

-- bouton X
local closeBtnAll = CreateFrame("Button", nil, tBotAllPopup, "UIPanelCloseButton")
closeBtnAll:SetPoint("TOPRIGHT", -2, -2)

local headerAll = tBotAllPopup:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
headerAll:SetPoint("TOP", 0, -10)
headerAll:SetText(MultiBot.tips.quests.alllist)

-- ScrollFrame
local scrollAll = CreateFrame("ScrollFrame", "MB_BotQuestAllScroll", tBotAllPopup, "UIPanelScrollFrameTemplate")
scrollAll:SetPoint("TOPLEFT", 12, -38)
scrollAll:SetPoint("BOTTOMRIGHT", -30, 14)

local contentAll = CreateFrame("Frame", nil, scrollAll)
contentAll:SetWidth(1)
scrollAll:SetScrollChild(contentAll)
tBotAllPopup.content = contentAll

-- Helper pour vider le contenu
-- function MultiBot.ClearAllContent()
--     for _, child in ipairs({ contentAll:GetChildren() }) do
--         child:Hide()
--         child:SetParent(nil)
--     end
--     if contentAll.text then contentAll.text:SetText("") end
-- end


function MultiBot.ClearAllContent()
    -- 1) Frames (boutons, lignes, etc.)
    for _, child in ipairs({ contentAll:GetChildren() }) do
        child:Hide()
        child:SetParent(nil)
    end

    -- 2) Regions (FontStrings, Textures) – les headers sont ici
    for _, region in ipairs({ contentAll:GetRegions() }) do
        region:Hide()                        -- on la masque
        if region:GetObjectType() == "FontString" then
            region:SetText("")               -- on vide le texte pour éviter les résidus
        elseif region:GetObjectType() == "Texture" then
            region:SetTexture(nil)           -- on efface la texture éventuelle
        end
    end

    if contentAll.text then
        contentAll.text:SetText("")
    end
end

-- AJOUT ON VIDE TOUT
tBotAllPopup:SetScript("OnHide", function()
    MultiBot.BotQuestsAll         = {}
    MultiBot.BotQuestsCompleted   = {}
    MultiBot.BotQuestsIncompleted = {}
    MultiBot.ClearAllContent()
end)
-- Fin de l’ajout

-- Build pour un seul bot
function MultiBot.BuildBotAllList(botName)
    MultiBot.ClearAllContent()
	local contentAll = MultiBot.tBotAllPopup.content
    local quests = MultiBot.BotQuestsAll[botName] or {}
    local y = -4
    for _, link in ipairs(quests) do
        local questID = tonumber(link:match("|Hquest:(%d+):"))
        local locName = questID and GetLocalizedQuestName(questID) or link
        local displayLink = link:gsub("%[[^%]]+%]", "|cff00ff00["..locName.."]|r")

        local line = CreateFrame("Frame", nil, contentAll)
        line:SetSize(360, 20)
        line:SetPoint("TOPLEFT", 0, y)

        local icon = line:CreateTexture(nil, "ARTWORK")
        icon:SetTexture("Interface\\Icons\\inv_misc_note_02")
        icon:SetSize(20,20)
        icon:SetPoint("LEFT", 0, 0)

        local html = CreateFrame("SimpleHTML", nil, line)
        html:SetSize(320, 20); html:SetPoint("LEFT", 24, 0)
        html:SetFontObject("GameFontNormal"); html:SetText(displayLink)
        html:SetHyperlinksEnabled(true)
        html:SetScript("OnHyperlinkEnter", function(self, _, link)
            GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
            GameTooltip:SetHyperlink(link)
            GameTooltip:Show()
        end)
        html:SetScript("OnHyperlinkLeave", function() GameTooltip:Hide() end)

        y = y - 22
    end
    contentAll:SetHeight(-y + 4)
    scrollAll:SetVerticalScroll(0)
end

-- version agrégée pour le groupe
local function BuildAggregatedAllList()
    MultiBot.ClearAllContent()
    local contentAll = MultiBot.tBotAllPopup.content
    local y = -4

    -- Regroupement comme avant...
    local complete = {}
    for bot, quests in pairs(MultiBot.BotQuestsCompleted or {}) do
        for id, name in pairs(quests or {}) do
            id = tonumber(id)
            if not complete[id] then complete[id] = { name = name, bots = {} } end
            table.insert(complete[id].bots, bot)
        end
    end

    local incomplete = {}
    for bot, quests in pairs(MultiBot.BotQuestsIncompleted or {}) do
        for id, name in pairs(quests or {}) do
            id = tonumber(id)
            if not incomplete[id] then incomplete[id] = { name = name, bots = {} } end
            table.insert(incomplete[id].bots, bot)
        end
    end

    -- === Header Quêtes complètes ===
    local header = contentAll:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    header:SetPoint("TOPLEFT", 0, y)
    header:SetText(MultiBot.tips.quests.compheader)
    y = y - 28

    -- Affiche toutes les quêtes complètes
    for id, data in pairs(complete) do
        local line = CreateFrame("Frame", nil, contentAll)
        line:SetSize(360, 20)
        line:SetPoint("TOPLEFT", 0, y)
        local icon = line:CreateTexture(nil, "ARTWORK")
        icon:SetTexture("Interface\\Icons\\inv_misc_note_02")
        icon:SetSize(20,20); icon:SetPoint("LEFT")
        -- local link = ("|cff00ff00|Hquest:%s:0|h[%s]|h|r"):format(id, data.name)
		local locName = GetLocalizedQuestName(id)
        local link = ("|cff00ff00|Hquest:%s:0|h[%s]|h|r"):format(id, locName)
        local html = CreateFrame("SimpleHTML", nil, line)
        html:SetSize(320, 20); html:SetPoint("LEFT", 24, 0)
        html:SetFontObject("GameFontNormal"); html:SetText(link)
        html:SetHyperlinksEnabled(true)
        html:SetScript("OnHyperlinkEnter", function(self, _, l)
            GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
            GameTooltip:SetHyperlink(l); GameTooltip:Show()
        end)
        html:SetScript("OnHyperlinkLeave", GameTooltip_Hide)
        y = y - 20

        local botsLine = contentAll:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
        botsLine:SetPoint("TOPLEFT", 24, y)
        botsLine:SetText(MultiBot.tips.quests.botsword .. table.concat(data.bots, ", "))
        y = y - 16
    end

    y = y - 10

    -- === Header Quêtes incomplètes ===
    local header2 = contentAll:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    header2:SetPoint("TOPLEFT", 0, y)
    header2:SetText(MultiBot.tips.quests.incompheader)
    y = y - 28

    -- Affiche toutes les quêtes incomplètes
    for id, data in pairs(incomplete) do
        local line = CreateFrame("Frame", nil, contentAll)
        line:SetSize(360, 20)
        line:SetPoint("TOPLEFT", 0, y)
        local icon = line:CreateTexture(nil, "ARTWORK")
        icon:SetTexture("Interface\\Icons\\inv_misc_note_02")
        icon:SetSize(20,20); icon:SetPoint("LEFT")
        -- local link = ("|cffffff00|Hquest:%s:0|h[%s]|h|r"):format(id, data.name)
		local locName = GetLocalizedQuestName(id)
        local link = ("|cff00ff00|Hquest:%s:0|h[%s]|h|r"):format(id, locName)
        local html = CreateFrame("SimpleHTML", nil, line)
        html:SetSize(320, 20); html:SetPoint("LEFT", 24, 0)
        html:SetFontObject("GameFontNormal"); html:SetText(link)
        html:SetHyperlinksEnabled(true)
        html:SetScript("OnHyperlinkEnter", function(self, _, l)
            GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
            GameTooltip:SetHyperlink(l); GameTooltip:Show()
        end)
        html:SetScript("OnHyperlinkLeave", GameTooltip_Hide)
        y = y - 20

        local botsLine = contentAll:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
        botsLine:SetPoint("TOPLEFT", 24, y)
        botsLine:SetText(MultiBot.tips.quests.botsword .. table.concat(data.bots, ", "))
        y = y - 16
    end

    contentAll:SetHeight(-y + 4)
    scrollAll:SetVerticalScroll(0)
end


MultiBot.BuildAggregatedAllList = BuildAggregatedAllList


-- BOUTONS All
local btnAll = tQuestMenu.addButton("BotQuestsAll", 0, 120,
    "Interface\\Icons\\INV_Misc_Book_09",
    MultiBot.tips.quests.allcompleted)

local btnAllGroup = tQuestMenu.addButton("BotQuestsAllGroup", 31, 120,
    "Interface\\Icons\\INV_Misc_Book_09",
    MultiBot.tips.quests.sendpartyraid)
btnAllGroup:doHide()

local btnAllWhisper = tQuestMenu.addButton("BotQuestsAllWhisper", 61, 120,
    "Interface\\Icons\\INV_Misc_Book_09",
    MultiBot.tips.quests.sendwhisp)
btnAllWhisper:doHide()

function SendAll(method)
    MultiBot._lastAllMode = method
    MultiBot._awaitingQuestsAll = true
    MultiBot._blockOtherQuests = true
    MultiBot.BotQuestsAll = {}
    MultiBot._awaitingQuestsAllBots = {}

    if method == "GROUP" then
        for i = 1, GetNumPartyMembers() do
            local name = UnitName("party"..i)
            if name then MultiBot._awaitingQuestsAllBots[name] = false end
        end
        MultiBot.ActionToGroup("quests all")
    elseif method == "WHISPER" then
        local bot = UnitName("target")
        if not bot or not UnitIsPlayer("target") then
            UIErrorsFrame:AddMessage(MultiBot.tips.quests.questcomperror, 1, 0.2, 0.2, 1)
            MultiBot._awaitingQuestsAll = false
            MultiBot._blockOtherQuests = false
            return
        end
        MultiBot._awaitingQuestsAllBots[bot] = false
        MultiBot.ActionToTarget("quests all", bot)
    end

    MultiBot.tBotAllPopup:Show()
    MultiBot.ClearAllContent()
    local f = MultiBot.tBotAllPopup.content
    f.text = f.text or f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    f.text:SetPoint("TOPLEFT", 8, -8)
    f.text:SetText("Loading…")
end

btnAll.doLeft = function()
    if btnAllGroup:IsShown() then
        btnAllGroup:doHide()
        btnAllWhisper:doHide()
	else
	    btnAllGroup:doShow()
		btnAllWhisper:doShow()
	end
end

btnAllGroup.doLeft   = function() SendAll("GROUP")   end
btnAllWhisper.doLeft = function() SendAll("WHISPER") end

tRight.buttons["BotQuestsAll"]        = btnAll
tRight.buttons["BotQuestsAllGroup"]   = btnAllGroup
tRight.buttons["BotQuestsAllWhisper"] = btnAllWhisper
-- END BUTTON QUESTS ALL --

-- BUTTONS USE GOB AND LOS --
function MultiBot.ShowGameObjectPopup()

    if MultiBot.GameObjPopup and MultiBot.GameObjPopup:IsShown() then
        MultiBot.GameObjPopup:Hide()
    end

    -- Crée la popup
    if not MultiBot.GameObjPopup then
        local popup = CreateFrame("Frame", "MB_GameObjPopup", UIParent)
        popup:SetSize(340, 340)
        popup:SetPoint("CENTER")
        popup:SetFrameStrata("DIALOG")
        popup:SetBackdrop({
            bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile     = true, tileSize = 32, edgeSize = 16,
            insets   = { left = 4, right = 4, top = 4, bottom = 4 }
        })
        popup:EnableMouse(true)
        popup:SetMovable(true)
        popup:RegisterForDrag("LeftButton")
        popup:SetScript("OnDragStart", popup.StartMoving)
        popup:SetScript("OnDragStop",  popup.StopMovingOrSizing)
        local close = CreateFrame("Button", nil, popup, "UIPanelCloseButton")
        close:SetPoint("TOPRIGHT", -2, -2)
        local title = popup:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
        title:SetPoint("TOP", 0, -10)
        title:SetText(MultiBot.tips.quests.gobsfound)
        -- ScrollFrame
        local scrollFrame = CreateFrame("ScrollFrame", "MB_GameObjScroll", popup, "UIPanelScrollFrameTemplate")
        scrollFrame:SetPoint("TOPLEFT", 14, -38)
        scrollFrame:SetPoint("BOTTOMRIGHT", -30, 14)
        local content = CreateFrame("Frame", nil, scrollFrame)
        content:SetWidth(1)
        scrollFrame:SetScrollChild(content)
        popup.content = content
        MultiBot.GameObjPopup = popup
        MultiBot.GameObjPopup.scrollFrame = scrollFrame
		
		
		-- Bouton "Tout copier"
	if not popup.copyBtn then
		local copyBtn = CreateFrame("Button", nil, popup, "UIPanelButtonTemplate")
		copyBtn:SetSize(120, 20)
		copyBtn:SetPoint("BOTTOMRIGHT", -40, 12)
		copyBtn:SetText(MultiBot.tips.quests.gobselectall)
		popup.copyBtn = copyBtn
		copyBtn:SetScript("OnClick", function()
			MultiBot.ShowGameObjectCopyBox()
		end)
	end
    
	end

    -- Nettoie le contenu
    local content = MultiBot.GameObjPopup.content
    for _, child in ipairs({content:GetChildren()}) do
        child:Hide()
        child:SetParent(nil)
    end

    -- Affiche la liste pour chaque bot auteur
    local y = -4
    for bot, lines in pairs(MultiBot.LastGameObjectSearch) do
        -- Titre bot
        local botLine = content:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
        botLine:SetPoint("TOPLEFT", 8, y)
        botLine:SetText("Bot: |cff80ff80"..bot.."|r")
        y = y - 18
        -- Chaque ligne du résultat
        for _, txt in ipairs(lines) do
            local l = content:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
            l:SetPoint("TOPLEFT", 24, y)
            l:SetText(txt)
            y = y - 16
        end
        y = y - 8
    end
    content:SetHeight(-y + 4)
    MultiBot.GameObjPopup.scrollFrame:SetVerticalScroll(0)
    MultiBot.GameObjPopup:Show()
end

function MultiBot.ShowGameObjectCopyBox()
		-- Ferme la popup GameObj principale si elle est ouverte
		if MultiBot.GameObjPopup and MultiBot.GameObjPopup:IsShown() then
			MultiBot.GameObjPopup:Hide()
		end
		
		if not MultiBot.GameObjCopyBox then
        local box = CreateFrame("Frame", "MB_GameObjCopyBox", UIParent)
        box:SetSize(380, 240)
        box:SetPoint("CENTER")
        box:SetBackdrop({
            bgFile   = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile     = true, tileSize = 32, edgeSize = 16,
            insets   = { left = 4, right = 4, top = 4, bottom = 4 }
        })
        box:SetFrameStrata("DIALOG")
        local close = CreateFrame("Button", nil, box, "UIPanelCloseButton")
        close:SetPoint("TOPRIGHT", -2, -2)
        close:SetScript("OnClick", function() box:Hide() end)

        local label = box:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
        label:SetPoint("TOP", 0, -10)
        label:SetText(MultiBot.tips.quests.gobctrlctocopy)

        -- EditBox multi-ligne
        local edit = CreateFrame("EditBox", nil, box)
        edit:SetFontObject("ChatFontNormal")
        edit:SetWidth(340)
        edit:SetHeight(180)
        edit:SetMultiLine(true)
        edit:SetAutoFocus(true)
        edit:EnableMouse(true)
        edit:SetPoint("TOP", 0, -40)
        edit:SetScript("OnEscapePressed", function(self) box:Hide() end)
        edit:SetScript("OnEditFocusGained", function(self) self:HighlightText() end)
        box.edit = edit
        MultiBot.GameObjCopyBox = box
    end

    -- Génère le texte à copier
    local text = ""
    for bot, lines in pairs(MultiBot.LastGameObjectSearch) do
        text = text .. ("Bot: %s\n"):format(bot)
        for _, l in ipairs(lines) do
            text = text .. l .. "\n"
        end
        text = text .. "\n"
    end
    MultiBot.GameObjCopyBox.edit:SetText(text)
    MultiBot.GameObjCopyBox.edit:HighlightText()
    MultiBot.GameObjCopyBox:Show()
end

local PROMPT
function ShowPrompt(title, onOk, defaultText)
    if not PROMPT then
        PROMPT = CreateFrame("Frame", "MBUniversalPrompt", UIParent)
        PROMPT:SetSize(260, 90)
        PROMPT:SetPoint("CENTER")
        PROMPT:SetBackdrop({
            bgFile="Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",
            tile=true, tileSize=32, edgeSize=16,
            insets={left=4, right=4, top=4, bottom=4}
        })
        PROMPT:SetBackdropColor(0,0,0,0.9)
        PROMPT:SetFrameStrata("DIALOG")
        PROMPT:SetMovable(true)
        PROMPT:EnableMouse(true)
        PROMPT:RegisterForDrag("LeftButton")
        PROMPT:SetScript("OnDragStart", PROMPT.StartMoving)
        PROMPT:SetScript("OnDragStop",  PROMPT.StopMovingOrSizing)

        local btnClose = CreateFrame("Button", nil, PROMPT, "UIPanelCloseButton")
        btnClose:SetPoint("TOPRIGHT", -5, -5)
        btnClose:SetScript("OnClick", function() PROMPT:Hide() end)

        local e = CreateFrame("EditBox", nil, PROMPT, "InputBoxTemplate")
        e:SetAutoFocus(true)
        e:SetSize(200, 20)
        e:SetTextColor(1,1,1)
        e:SetPoint("TOP", 0, -30)
        PROMPT.EditBox = e
        e:SetScript("OnEscapePressed", function(self) PROMPT:Hide() end)

        local ok = CreateFrame("Button", nil, PROMPT, "UIPanelButtonTemplate")
        ok:SetSize(60, 20)
        ok:SetPoint("BOTTOM", 0, 10)
        ok:SetText("OK")
        PROMPT.OkBtn = ok
    end

    if not PROMPT.Title then
        PROMPT.Title = PROMPT:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        PROMPT.Title:SetPoint("TOP", 0, -10)
    end

    PROMPT.Title:SetText(title or "Enter Value")
    PROMPT:Show()
    PROMPT.EditBox:SetText(defaultText or "")
    PROMPT.EditBox:SetFocus()

    PROMPT.OkBtn:SetScript("OnClick", function()
        local text = PROMPT.EditBox:GetText()
        if text and text~="" then
            onOk(text)
        else
            UIErrorsFrame:AddMessage(MultiBot.tips.quests.gobsnameerror, 1, 0.2, 0.2, 1)
            return
        end
        PROMPT:Hide()
    end)
    PROMPT.EditBox:SetScript("OnEnterPressed", function(self)
        PROMPT.OkBtn:Click()
    end)
end

-- BOUTON PRINCIPAL "Use Game Object"
-- Boutons "Use Game Object"
local btnGob = tQuestMenu.addButton("BotUseGOB", 0, 150, 
    "Interface\\Icons\\inv_misc_spyglass_01", MultiBot.tips.quests.gobsmaster)

local btnGobName = tQuestMenu.addButton("BotUseGOBName", 31, 150,
    "Interface\\Icons\\inv_misc_note_05", MultiBot.tips.quests.gobenter)
btnGobName:doHide()

local btnGobSearch = tQuestMenu.addButton("BotUseGOBSearch", 61, 150,
    "Interface\\Icons\\inv_misc_spyglass_02", MultiBot.tips.quests.gobsearch)
btnGobSearch:doHide()

btnGob.doLeft = function()
    if btnGobName:IsShown() then
        btnGobName:doHide()
        btnGobSearch:doHide()
    else
        btnGobName:doShow()
        btnGobSearch:doShow()
    end
end

-- Sous-bouton : prompt pour le nom du GOB
btnGobName.doLeft = function()
    ShowPrompt(
        MultiBot.tips.quests.gobpromptname,
        function(gobName)
            gobName = gobName:gsub("^%s+", ""):gsub("%s+$", "")
            if gobName == "" then
                UIErrorsFrame:AddMessage(MultiBot.tips.quests.goberrorname , 1, 0.2, 0.2, 1)
                return
            end
            local bot = UnitName("target")
            if not bot or not UnitIsPlayer("target") then
                UIErrorsFrame:AddMessage(MultiBot.tips.quests.gobselectboterror, 1, 0.2, 0.2, 1)
                return
            end
            SendChatMessage("u " .. gobName, "WHISPER", nil, bot)
        end
    )
end

-- Sous-bouton envoi la commande "los" à tout le groupe
btnGobSearch.doLeft = function()
    MultiBot.ActionToGroup("los")
end

-- Register dans le handler MultiBot si besoin
tRight.buttons["BotUseGOB"]      = btnGob
tRight.buttons["BotUseGOBName"]  = btnGobName
tRight.buttons["BotUseGOBSearch"]= btnGobSearch
-- END NEW QUESTS --

-- DRINK --

tRight.addButton("Drink", 34, 0, "inv_drink_24_sealwhey", MultiBot.tips.drink.group)
.doLeft = function(pButton)
	MultiBot.ActionToGroup("drink")
end

-- RELEASE --

tRight.addButton("Release", 68, 0, "achievement_bg_xkills_avgraveyard", MultiBot.tips.release.group)
.doLeft = function(pButton)
	MultiBot.ActionToGroup("release")
end

-- REVIVE --

tRight.addButton("Revive", 102, 0, "spell_holy_guardianspirit", MultiBot.tips.revive.group)
.doLeft = function(pButton)
	MultiBot.ActionToGroup("revive")
end

-- SUMALL --

tRight.addButton("Summon", 136, 0, "ability_hunter_beastcall", MultiBot.tips.summon.group)
.doLeft = function(pButton)
	MultiBot.ActionToGroup("summon")
end

-- INVENTORY --

MultiBot.inventory = MultiBot.newFrame(MultiBot, -700, -144, 32, 442, 884)
MultiBot.inventory.addTexture("Interface\\AddOns\\MultiBot\\Textures\\Inventory.blp")
MultiBot.inventory.addText("Title", "Inventory", "CENTER", -58, 429, 12)
MultiBot.inventory.action = "s"
MultiBot.inventory:SetMovable(true)
MultiBot.inventory:Hide()

MultiBot.inventory.movButton("Move", -406, 849, 34, MultiBot.tips.move.inventory)

MultiBot.inventory.wowButton("X", -126, 862, 15, 18, 13)
.doLeft = function(pButton)
	local tUnits = MultiBot.frames["MultiBar"].frames["Units"]
	local tButton = tUnits.frames[MultiBot.inventory.name].buttons["Inventory"]
	tButton.doLeft(tButton)
end

MultiBot.inventory.addButton("Sell", -94, 806, "inv_misc_coin_16", MultiBot.tips.inventory.sell).setEnable()
.doLeft = function(pButton)
	if(pButton.state) then
		MultiBot.inventory.action = ""
		pButton.setDisable()
	else
		CancelTrade()
		MultiBot.inventory.action = "s"
		pButton.getButton("Destroy").setDisable()
		pButton.getButton("Equip").setDisable()
		pButton.getButton("Trade").setDisable()
		pButton.getButton("Use").setDisable()
		pButton.setEnable()
	end
end

MultiBot.inventory.addButton("Equip", -94, 768, "inv_helmet_22", MultiBot.tips.inventory.equip).setDisable()
.doLeft = function(pButton)
	if(pButton.state) then
		MultiBot.inventory.action = ""
		pButton.setDisable()
	else
		CancelTrade()
		MultiBot.inventory.action = "e"
		pButton.getButton("Destroy").setDisable()
		pButton.getButton("Trade").setDisable()
		pButton.getButton("Sell").setDisable()
		pButton.getButton("Use").setDisable()
		pButton.setEnable()
	end
end

MultiBot.inventory.addButton("Use", -94, 731, "inv_gauntlets_25", MultiBot.tips.inventory.use).setDisable()
.doLeft = function(pButton)
	if(pButton.state) then
		MultiBot.inventory.action = ""
		pButton.setDisable()
	else
		CancelTrade()
		MultiBot.inventory.action = "u"
		pButton.getButton("Destroy").setDisable()
		pButton.getButton("Equip").setDisable()
		pButton.getButton("Trade").setDisable()
		pButton.getButton("Sell").setDisable()
		pButton.setEnable()
	end
end

MultiBot.inventory.addButton("Trade", -94, 694, "achievement_reputation_01", MultiBot.tips.inventory.trade).setDisable()
.doLeft = function(pButton)
	if(pButton.state) then
		MultiBot.inventory.action = ""
		pButton.setDisable()
		CancelTrade()
	else
		InitiateTrade(pButton.getName())
		MultiBot.inventory.action = "give"
		pButton.getButton("Destroy").setDisable()
		pButton.getButton("Equip").setDisable()
		pButton.getButton("Sell").setDisable()
		pButton.getButton("Use").setDisable()
		pButton.setEnable()
	end
end

MultiBot.inventory.addButton("Destroy", -94, 657, "inv_hammer_15", MultiBot.tips.inventory.drop).setDisable()
.doLeft = function(pButton)
	if(pButton.state) then
		MultiBot.inventory.action = ""
		pButton.setDisable()
	else
		CancelTrade()
		MultiBot.inventory.action = "destroy"
		pButton.getButton("Equip").setDisable()
		pButton.getButton("Trade").setDisable()
		pButton.getButton("Sell").setDisable()
		pButton.getButton("Use").setDisable()
		pButton.setEnable()
	end
end

MultiBot.inventory.addButton("Open", -94, 322.5, "inv_misc_gift_05", MultiBot.tips.inventory.open)
.doLeft = function(pButton)
	SendChatMessage("open items", "WHISPER", nil, pButton.getName())
end

local tFrame = MultiBot.inventory.addFrame("Items", -397, 807, 32)
tFrame:Show()

-- STATS --

MultiBot.stats = MultiBot.newFrame(MultiBot, -60, 560, 32)
MultiBot.stats:SetMovable(true)
MultiBot.stats:Hide()

MultiBot.stats.movButton("Move", 0, -80, 160, MultiBot.tips.move.stats)

MultiBot.addStats(MultiBot.stats, "party1", 0,    0, 32, 192, 96)
MultiBot.addStats(MultiBot.stats, "party2", 0,  -60, 32, 192, 96)
MultiBot.addStats(MultiBot.stats, "party3", 0, -120, 32, 192, 96)
MultiBot.addStats(MultiBot.stats, "party4", 0, -180, 32, 192, 96)

-- ITEMUS --

MultiBot.itemus = MultiBot.newFrame(MultiBot, -860, -144, 32, 442, 884)
MultiBot.itemus.addTexture("Interface\\AddOns\\MultiBot\\Textures\\Inventory.blp")
MultiBot.itemus.addText("Title", "Itemus", "CENTER", -57, 429, 13)
MultiBot.itemus.addText("Pages", "0/0", "CENTER", -57, 409, 13)
MultiBot.itemus.name = UnitName("Player")
MultiBot.itemus.index = {}
MultiBot.itemus.color = "cff9d9d9d"
MultiBot.itemus.level = "L10"
MultiBot.itemus.rare = "R00"
MultiBot.itemus.slot = "S00"
MultiBot.itemus.type = "PC"
MultiBot.itemus.max = 1
MultiBot.itemus.now = 1
MultiBot.itemus:SetMovable(true)
MultiBot.itemus:Hide()

MultiBot.itemus.movButton("Move", -407, 850, 32, MultiBot.tips.move.itemus)

MultiBot.itemus.wowButton("<", -319, 841, 15, 18, 13).doHide()
.doLeft = function(pButton)
	MultiBot.itemus.now = MultiBot.itemus.now - 1
	MultiBot.itemus.addItems()
end

MultiBot.itemus.wowButton(">", -225, 841, 15, 18, 13).doHide()
.doLeft = function(pButton)
	MultiBot.itemus.now = MultiBot.itemus.now + 1
	MultiBot.itemus.addItems()
end

MultiBot.itemus.wowButton("X", -126, 862, 15, 18, 13)
.doLeft = function(pButton)
	MultiBot.itemus:Hide()
end

local tFrame = MultiBot.itemus.addFrame("Items", -397, 807, 32)
tFrame:Show()

-- ITEMUS:LEVEL --

MultiBot.itemus.addButton("Level", -94, 806, "achievement_level_10", MultiBot.tips.itemus.level.master).setEnable()
.doLeft = function(pButton)
	MultiBot.ShowHideSwitch(pButton.parent.frames["Level"])
end

local tFrame = MultiBot.itemus.addFrame("Level", -61, 808, 28)
tFrame:Hide()

tFrame.addButton("L10", 0, 0, "achievement_level_10", MultiBot.tips.itemus.level.L10)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Level", pButton.texture)
	MultiBot.itemus.level = "L10"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("L20", 30, 0, "achievement_level_20", MultiBot.tips.itemus.level.L20)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Level", pButton.texture)
	MultiBot.itemus.level = "L20"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("L30", 60, 0, "achievement_level_30", MultiBot.tips.itemus.level.L30)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Level", pButton.texture)
	MultiBot.itemus.level = "L30"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("L40", 90, 0, "achievement_level_40", MultiBot.tips.itemus.level.L40)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Level", pButton.texture)
	MultiBot.itemus.level = "L40"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("L50", 120, 0, "achievement_level_50", MultiBot.tips.itemus.level.L50)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Level", pButton.texture)
	MultiBot.itemus.level = "L50"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("L60", 150, 0, "achievement_level_60", MultiBot.tips.itemus.level.L60)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Level", pButton.texture)
	MultiBot.itemus.level = "L60"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("L70", 180, 0, "achievement_level_70", MultiBot.tips.itemus.level.L70)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Level", pButton.texture)
	MultiBot.itemus.level = "L70"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("L80", 210, 0, "achievement_level_80", MultiBot.tips.itemus.level.L80)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Level", pButton.texture)
	MultiBot.itemus.level = "L80"
	MultiBot.itemus.addItems(1)
end

-- ITEMUS:RARE --

MultiBot.itemus.addButton("Rare", -94, 768, "achievement_quests_completed_01", MultiBot.tips.itemus.rare.master)
.doLeft = function(pButton)
	MultiBot.ShowHideSwitch(pButton.parent.frames["Rare"])
end

local tFrame = MultiBot.itemus.addFrame("Rare", -61, 770)
tFrame:Hide()

tFrame.addButton("R00", 0, 0, "achievement_quests_completed_01", MultiBot.tips.itemus.rare.R00)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Rare", pButton.texture)
	MultiBot.itemus.color = "cff9d9d9d"
	MultiBot.itemus.rare = "R00"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("R01", 30, 0, "achievement_quests_completed_02", MultiBot.tips.itemus.rare.R01)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Rare", pButton.texture)
	MultiBot.itemus.color = "cffffffff"
	MultiBot.itemus.rare = "R01"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("R02", 60, 0, "achievement_quests_completed_03", MultiBot.tips.itemus.rare.R02)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Rare", pButton.texture)
	MultiBot.itemus.color = "cff1eff00"
	MultiBot.itemus.rare = "R02"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("R03", 90, 0, "achievement_quests_completed_04", MultiBot.tips.itemus.rare.R03)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Rare", pButton.texture)
	MultiBot.itemus.color = "cff0070dd"
	MultiBot.itemus.rare = "R03"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("R04", 120, 0, "achievement_quests_completed_05", MultiBot.tips.itemus.rare.R04)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Rare", pButton.texture)
	MultiBot.itemus.color = "cffa335ee"
	MultiBot.itemus.rare = "R04"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("R05", 150, 0, "achievement_quests_completed_06", MultiBot.tips.itemus.rare.R05)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Rare", pButton.texture)
	MultiBot.itemus.color = "cffff8000"
	MultiBot.itemus.rare = "R05"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("R06", 180, 0, "achievement_quests_completed_07", MultiBot.tips.itemus.rare.R06)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Rare", pButton.texture)
	MultiBot.itemus.color = "cffff0000"
	MultiBot.itemus.rare = "R06"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("R07", 210, 0, "achievement_quests_completed_08", MultiBot.tips.itemus.rare.R07)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Rare", pButton.texture)
	MultiBot.itemus.color = "cffe6cc80"
	MultiBot.itemus.rare = "R07"
	MultiBot.itemus.addItems(1)
end

-- ITEMUS:SLOT --

MultiBot.itemus.addButton("Slot", -94, 731, "inv_drink_18", MultiBot.tips.itemus.slot.master)
.doLeft = function(pButton)
	MultiBot.ShowHideSwitch(pButton.parent.frames["Slot"])
end

local tFrame = MultiBot.itemus.addFrame("Slot", -61, 733)
tFrame:Hide()

tFrame.addButton("S00", 0, 0, "inv_drink_18", MultiBot.tips.itemus.slot.S00)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Slot", pButton.texture)
	MultiBot.itemus.slot = "S00"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("S01", 30, 0, "inv_misc_desecrated_platehelm", MultiBot.tips.itemus.slot.S01)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Slot", pButton.texture)
	MultiBot.itemus.slot = "S01"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("S02", 60, 0, "inv_jewelry_necklace_22", MultiBot.tips.itemus.slot.S02)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Slot", pButton.texture)
	MultiBot.itemus.slot = "S02"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("S03", 90, 0, "inv_misc_desecrated_plateshoulder", MultiBot.tips.itemus.slot.S03)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Slot", pButton.texture)
	MultiBot.itemus.slot = "S03"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("S04", 120, 0, "inv_shirt_grey_01", MultiBot.tips.itemus.slot.S04)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Slot", pButton.texture)
	MultiBot.itemus.slot = "S04"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("S05", 150, 0, "inv_misc_desecrated_platechest", MultiBot.tips.itemus.slot.S05)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Slot", pButton.texture)
	MultiBot.itemus.slot = "S05"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("S06", 180, 0, "inv_misc_desecrated_platebelt", MultiBot.tips.itemus.slot.S06)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Slot", pButton.texture)
	MultiBot.itemus.slot = "S06"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("S07", 210, 0, "inv_misc_desecrated_platepants", MultiBot.tips.itemus.slot.S07)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Slot", pButton.texture)
	MultiBot.itemus.slot = "S07"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("S08", 0, -30, "inv_misc_desecrated_plateboots", MultiBot.tips.itemus.slot.S08)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Slot", pButton.texture)
	MultiBot.itemus.slot = "S08"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("S09", 30, -30, "inv_misc_desecrated_platebracer", MultiBot.tips.itemus.slot.S09)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Slot", pButton.texture)
	MultiBot.itemus.slot = "S09"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("S10", 60, -30, "inv_misc_desecrated_plategloves", MultiBot.tips.itemus.slot.S10)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Slot", pButton.texture)
	MultiBot.itemus.slot = "S10"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("S11", 90, -30, "inv_jewelry_ring_19", MultiBot.tips.itemus.slot.S11)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Slot", pButton.texture)
	MultiBot.itemus.slot = "S11"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("S12", 120, -30, "inv_jewelry_ring_07", MultiBot.tips.itemus.slot.S12)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Slot", pButton.texture)
	MultiBot.itemus.slot = "S12"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("S13", 150, -30, "inv_sword_23", MultiBot.tips.itemus.slot.S13)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Slot", pButton.texture)
	MultiBot.itemus.slot = "S13"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("S14", 180, -30, "inv_shield_04", MultiBot.tips.itemus.slot.S14)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Slot", pButton.texture)
	MultiBot.itemus.slot = "S14"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("S15", 210, -30, "inv_weapon_bow_05", MultiBot.tips.itemus.slot.S15)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Slot", pButton.texture)
	MultiBot.itemus.slot = "S15"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("S16", 0, -60, "inv_misc_cape_20", MultiBot.tips.itemus.slot.S16)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Slot", pButton.texture)
	MultiBot.itemus.slot = "S16"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("S17", 30, -60, "inv_axe_14", MultiBot.tips.itemus.slot.S17)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Slot", pButton.texture)
	MultiBot.itemus.slot = "S17"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("S18", 60, -60, "inv_misc_bag_07_black", MultiBot.tips.itemus.slot.S18)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Slot", pButton.texture)
	MultiBot.itemus.slot = "S18"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("S19", 90, -60, "inv_shirt_guildtabard_01", MultiBot.tips.itemus.slot.S19)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Slot", pButton.texture)
	MultiBot.itemus.slot = "S19"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("S20", 120, -60, "inv_misc_desecrated_clothchest", MultiBot.tips.itemus.slot.S20)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Slot", pButton.texture)
	MultiBot.itemus.slot = "S20"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("S21", 150, -60, "inv_hammer_07", MultiBot.tips.itemus.slot.S21)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Slot", pButton.texture)
	MultiBot.itemus.slot = "S21"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("S22", 180, -60, "inv_sword_15", MultiBot.tips.itemus.slot.S22)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Slot", pButton.texture)
	MultiBot.itemus.slot = "S22"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("S23", 210, -60, "inv_misc_book_09", MultiBot.tips.itemus.slot.S23)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Slot", pButton.texture)
	MultiBot.itemus.slot = "S23"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("S24", 0, -90, "inv_misc_ammo_arrow_01", MultiBot.tips.itemus.slot.S24)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Slot", pButton.texture)
	MultiBot.itemus.slot = "S24"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("S25", 30, -90, "inv_throwingknife_02", MultiBot.tips.itemus.slot.S25)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Slot", pButton.texture)
	MultiBot.itemus.slot = "S25"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("S26", 60, -90, "inv_wand_07", MultiBot.tips.itemus.slot.S26)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Slot", pButton.texture)
	MultiBot.itemus.slot = "S26"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("S27", 90, -90, "inv_misc_quiver_07", MultiBot.tips.itemus.slot.S27)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Slot", pButton.texture)
	MultiBot.itemus.slot = "S26"
	MultiBot.itemus.addItems(1)
end

tFrame.addButton("S28", 120, -90, "inv_relics_idolofrejuvenation", MultiBot.tips.itemus.slot.S28)
.doLeft = function(pButton)
	MultiBot.Select(MultiBot.itemus, "Slot", pButton.texture)
	MultiBot.itemus.slot = "S28"
	MultiBot.itemus.addItems(1)
end

-- ITEMUS:TYPE --

MultiBot.itemus.addButton("Type", -94, 694, "inv_misc_head_clockworkgnome_01", MultiBot.tips.itemus.type).setDisable()
.doLeft = function(pButton)
	MultiBot.itemus.type = MultiBot.IF(MultiBot.OnOffSwitch(pButton), "NPC", "PC")
	MultiBot.itemus.addItems(1)
end

-- ICONOS --

MultiBot.iconos = MultiBot.newFrame(MultiBot, -860, -144, 32, 442, 884)
MultiBot.iconos.addTexture("Interface\\AddOns\\MultiBot\\Textures\\Iconos.blp")
MultiBot.iconos.addText("Title", "Iconos", "CENTER", -57, 429, 13)
MultiBot.iconos.addText("Pages", "0/0", "CENTER", -57, 409, 13)
MultiBot.iconos.max = 1
MultiBot.iconos.now = 1
MultiBot.iconos:SetMovable(true)
MultiBot.iconos:Hide()

MultiBot.iconos.movButton("Move", -407, 850, 32, MultiBot.tips.move.iconos)

MultiBot.iconos.wowButton("<", -319, 841, 15, 18, 13).doHide()
.doLeft = function(pButton)
	MultiBot.iconos.now = MultiBot.iconos.now - 1
	MultiBot.iconos.addIcons()
end

MultiBot.iconos.wowButton(">", -225, 841, 15, 18, 13).doHide()
.doLeft = function(pButton)
	MultiBot.iconos.now = MultiBot.iconos.now + 1
	MultiBot.iconos.addIcons()
end

MultiBot.iconos.wowButton("X", -126, 862, 15, 18, 13)
.doLeft = function(pButton)
	MultiBot.iconos:Hide()
end

local tFrame = MultiBot.iconos.addFrame("Icons", -397, 807, 32)
tFrame:Show()

-- SPELLBOOK --

MultiBot.spellbook = MultiBot.newFrame(MultiBot, -802, 302, 28, 336, 448)
MultiBot.spellbook.spells = {}
MultiBot.spellbook.icons = {}
MultiBot.spellbook.max = 1
MultiBot.spellbook.now = 1
MultiBot.spellbook:SetMovable(true)
MultiBot.spellbook:Hide()

for i = 1, GetNumMacroIcons() do MultiBot.spellbook.icons[GetMacroIconInfo(i)] = i end

local tFrame = MultiBot.spellbook.addFrame("Icon", -276, 392, 28, 50, 50)
tFrame.addTexture("Interface/Spellbook/Spellbook-Icon")
tFrame:SetFrameLevel(0)

local tFrame = MultiBot.spellbook.addFrame("TopLeft", -112, 224, 28, 224, 224)
tFrame.addTexture("Interface/ItemTextFrame/UI-ItemText-TopLeft")
tFrame:SetFrameLevel(1)

local tFrame = MultiBot.spellbook.addFrame("TopRight", -0, 224, 28, 112, 224)
tFrame.addTexture("Interface/Spellbook/UI-SpellbookPanel-TopRight")
tFrame:SetFrameLevel(2)

local tFrame = MultiBot.spellbook.addFrame("BottomLeft", -112, 0, 28, 224, 224)
tFrame.addTexture("Interface/ItemTextFrame/UI-ItemText-BotLeft")
tFrame:SetFrameLevel(3)

local tFrame = MultiBot.spellbook.addFrame("BottomRight", -0, 0, 28, 112, 224)
tFrame.addTexture("Interface/Spellbook/UI-SpellbookPanel-BotRight")
tFrame:SetFrameLevel(4)

local tOverlay = MultiBot.spellbook.addFrame("Overlay", -47, 81, 28, 258, 292)
tOverlay.addText("Title", "Spellbook", "CENTER", 14, 200, 13)
tOverlay.addText("Pages", "0/0", "CENTER", 14, 173, 13)
tOverlay:SetFrameLevel(5)

tOverlay.movButton("Move", -226, 310, 50, MultiBot.tips.move.spellbook, MultiBot.spellbook)

tOverlay.wowButton("<", -159, 309, 15, 18, 13)
.doLeft = function(pButton)
	MultiBot.spellbook.to = MultiBot.spellbook.to - 16
	MultiBot.spellbook.now = MultiBot.spellbook.now - 1
	MultiBot.spellbook.from = MultiBot.spellbook.from - 16
	MultiBot.spellbook.frames["Overlay"].setText("Pages", MultiBot.spellbook.now .. "/" .. MultiBot.spellbook.max)
	MultiBot.spellbook.frames["Overlay"].buttons[">"].doShow()
	
	if(MultiBot.spellbook.now == 1) then pButton.doHide() end
	local tIndex = 1
	
	for i = MultiBot.spellbook.from, MultiBot.spellbook.to do
		MultiBot.setSpell(tIndex, MultiBot.spellbook.spells[i], pButton.getName())
		tIndex = tIndex + 1
	end
end

tOverlay.wowButton(">", -59, 309, 15, 18, 11)
.doLeft = function(pButton)
	MultiBot.spellbook.to = MultiBot.spellbook.to + 16
	MultiBot.spellbook.now = MultiBot.spellbook.now + 1
	MultiBot.spellbook.from = MultiBot.spellbook.from + 16
	MultiBot.spellbook.frames["Overlay"].setText("Pages", MultiBot.spellbook.now .. "/" .. MultiBot.spellbook.max)
	MultiBot.spellbook.frames["Overlay"].buttons["<"].doShow()
	
	if(MultiBot.spellbook.now == MultiBot.spellbook.max) then pButton.doHide() end
	local tIndex = 1
	
	for i = MultiBot.spellbook.from, MultiBot.spellbook.to do
		MultiBot.setSpell(tIndex, MultiBot.spellbook.spells[i], pButton.getName())
		tIndex = tIndex + 1
	end
end

tOverlay.wowButton("X", 16, 336, 15, 18, 11)
.doLeft = function(pButton)
	local tUnits = MultiBot.frames["MultiBar"].frames["Units"]
	local tButton = tUnits.frames[MultiBot.spellbook.name].buttons["Spellbook"]
	tButton.doLeft(tButton)
end

tOverlay.addText("R01", "|cff402000Rank|r", "TOPLEFT", 44, -16, 11)
tOverlay.addText("T01", "|cffffcc00Title|r", "TOPLEFT", 30, -2, 12)
local tButton = tOverlay.addButton("S01", -230, 264, "inv_misc_questionmark", "Text")
tButton.doRight = function(pButton)
	MultiBot.SpellToMacro(MultiBot.spellbook.name, pButton.spell, pButton.texture)
end
tButton.doLeft = function(pButton)
	SendChatMessage("cast " .. pButton.spell, "WHISPER", nil, MultiBot.spellbook.name)
end

tOverlay.addText("R02", "|cff402000Rank|r", "TOPLEFT", 172, -16, 11)
tOverlay.addText("T02", "|cffffcc00Title|r", "TOPLEFT", 159, -2, 12)
local tButton = tOverlay.addButton("S02", -101, 264, "inv_misc_questionmark", "Text")
tButton.doRight = function(pButton)
	MultiBot.SpellToMacro(MultiBot.spellbook.name, pButton.spell, pButton.texture)
end
tButton.doLeft = function(pButton)
	SendChatMessage("cast " .. pButton.spell, "WHISPER", nil, MultiBot.spellbook.name)
end

tOverlay.addText("R03", "|cff402000Rank|r", "TOPLEFT", 44, -52, 11)
tOverlay.addText("T03", "|cffffcc00Title|r", "TOPLEFT", 30, -38, 12)
local tButton = tOverlay.addButton("S03", -230, 228, "inv_misc_questionmark", "Text")
tButton.doRight = function(pButton)
	MultiBot.SpellToMacro(MultiBot.spellbook.name, pButton.spell, pButton.texture)
end
tButton.doLeft = function(pButton)
	SendChatMessage("cast " .. pButton.spell, "WHISPER", nil, MultiBot.spellbook.name)
end

tOverlay.addText("R04", "|cff402000Rank|r", "TOPLEFT", 172, -52, 11)
tOverlay.addText("T04", "|cffffcc00Title|r", "TOPLEFT", 159, -38, 12)
local tButton = tOverlay.addButton("S04", -101, 228, "inv_misc_questionmark", "Text")
tButton.doRight = function(pButton)
	MultiBot.SpellToMacro(MultiBot.spellbook.name, pButton.spell, pButton.texture)
end
tButton.doLeft = function(pButton)
	SendChatMessage("cast " .. pButton.spell, "WHISPER", nil, MultiBot.spellbook.name)
end

tOverlay.addText("R05", "|cff402000Rank|r", "TOPLEFT", 44, -88, 11)
tOverlay.addText("T05", "|cffffcc00Title|r", "TOPLEFT", 30, -74, 12)
local tButton = tOverlay.addButton("S05", -230, 192, "inv_misc_questionmark", "Text")
tButton.doRight = function(pButton)
	MultiBot.SpellToMacro(MultiBot.spellbook.name, pButton.spell, pButton.texture)
end
tButton.doLeft = function(pButton)
	SendChatMessage("cast " .. pButton.spell, "WHISPER", nil, MultiBot.spellbook.name)
end

tOverlay.addText("R06", "|cff402000Rank|r", "TOPLEFT", 172, -88, 11)
tOverlay.addText("T06", "|cffffcc00Title|r", "TOPLEFT", 159, -74, 12)
local tButton = tOverlay.addButton("S06", -101, 192, "inv_misc_questionmark", "Text")
tButton.doRight = function(pButton)
	MultiBot.SpellToMacro(MultiBot.spellbook.name, pButton.spell, pButton.texture)
end
tButton.doLeft = function(pButton)
	SendChatMessage("cast " .. pButton.spell, "WHISPER", nil, MultiBot.spellbook.name)
end

tOverlay.addText("R07", "|cff402000Rank|r", "TOPLEFT", 44, -124, 11)
tOverlay.addText("T07", "|cffffcc00Title|r", "TOPLEFT", 30, -110, 12)
local tButton = tOverlay.addButton("S07", -230, 156, "inv_misc_questionmark", "Text")
tButton.doRight = function(pButton)
	MultiBot.SpellToMacro(MultiBot.spellbook.name, pButton.spell, pButton.texture)
end
tButton.doLeft = function(pButton)
	SendChatMessage("cast " .. pButton.spell, "WHISPER", nil, MultiBot.spellbook.name)
end

tOverlay.addText("R08", "|cff402000Rank|r", "TOPLEFT", 172, -124, 11)
tOverlay.addText("T08", "|cffffcc00Title|r", "TOPLEFT", 159, -110, 12)
local tButton = tOverlay.addButton("S08", -101, 156, "inv_misc_questionmark", "Text")
tButton.doRight = function(pButton)
	MultiBot.SpellToMacro(MultiBot.spellbook.name, pButton.spell, pButton.texture)
end
tButton.doLeft = function(pButton)
	SendChatMessage("cast " .. pButton.spell, "WHISPER", nil, MultiBot.spellbook.name)
end

tOverlay.addText("R09", "|cff402000Rank|r", "TOPLEFT", 44, -160, 11)
tOverlay.addText("T09", "|cffffcc00Title|r", "TOPLEFT", 30, -146, 12)
local tButton = tOverlay.addButton("S09", -230, 120, "inv_misc_questionmark", "Text")
tButton.doRight = function(pButton)
	MultiBot.SpellToMacro(MultiBot.spellbook.name, pButton.spell, pButton.texture)
end
tButton.doLeft = function(pButton)
	SendChatMessage("cast " .. pButton.spell, "WHISPER", nil, MultiBot.spellbook.name)
end

tOverlay.addText("R10", "|cff402000Rank|r", "TOPLEFT", 172, -160, 11)
tOverlay.addText("T10", "|cffffcc00Title|r", "TOPLEFT", 159, -146, 12)
local tButton = tOverlay.addButton("S10", -101, 120, "inv_misc_questionmark", "Text")
tButton.doRight = function(pButton)
	MultiBot.SpellToMacro(MultiBot.spellbook.name, pButton.spell, pButton.texture)
end
tButton.doLeft = function(pButton)
	SendChatMessage("cast " .. pButton.spell, "WHISPER", nil, MultiBot.spellbook.name)
end

tOverlay.addText("R11", "|cff402000Rank|r", "TOPLEFT", 44, -196, 11)
tOverlay.addText("T11", "|cffffcc00Title|r", "TOPLEFT", 30, -182, 12)
local tButton = tOverlay.addButton("S11", -230, 84, "inv_misc_questionmark", "Text")
tButton.doRight = function(pButton)
	MultiBot.SpellToMacro(MultiBot.spellbook.name, pButton.spell, pButton.texture)
end
tButton.doLeft = function(pButton)
	SendChatMessage("cast " .. pButton.spell, "WHISPER", nil, MultiBot.spellbook.name)
end

tOverlay.addText("R12", "|cff402000Rank|r", "TOPLEFT", 172, -196, 11)
tOverlay.addText("T12", "|cffffcc00Title|r", "TOPLEFT", 159, -182, 12)
local tButton = tOverlay.addButton("S12", -101, 84, "inv_misc_questionmark", "Text")
tButton.doRight = function(pButton)
	MultiBot.SpellToMacro(MultiBot.spellbook.name, pButton.spell, pButton.texture)
end
tButton.doLeft = function(pButton)
	SendChatMessage("cast " .. pButton.spell, "WHISPER", nil, MultiBot.spellbook.name)
end

tOverlay.addText("R13", "|cff402000Rank|r", "TOPLEFT", 44, -232, 11)
tOverlay.addText("T13", "|cffffcc00Title|r", "TOPLEFT", 30, -218, 12)
local tButton = tOverlay.addButton("S13", -230, 48, "inv_misc_questionmark", "Text")
tButton.doRight = function(pButton)
	MultiBot.SpellToMacro(MultiBot.spellbook.name, pButton.spell, pButton.texture)
end
tButton.doLeft = function(pButton)
	SendChatMessage("cast " .. pButton.spell, "WHISPER", nil, MultiBot.spellbook.name)
end

tOverlay.addText("R14", "|cff402000Rank|r", "TOPLEFT", 172, -232, 11)
tOverlay.addText("T14", "|cffffcc00Title|r", "TOPLEFT", 159, -218, 12)
local tButton = tOverlay.addButton("S14", -101, 48, "inv_misc_questionmark", "Text")
tButton.doRight = function(pButton)
	MultiBot.SpellToMacro(MultiBot.spellbook.name, pButton.spell, pButton.texture)
end
tButton.doLeft = function(pButton)
	SendChatMessage("cast " .. pButton.spell, "WHISPER", nil, MultiBot.spellbook.name)
end

tOverlay.addText("R15", "|cff402000Rank|r", "TOPLEFT", 44, -268, 11)
tOverlay.addText("T15", "|cffffcc00Title|r", "TOPLEFT", 30, -254, 12)
local tButton = tOverlay.addButton("S15", -230, 12, "inv_misc_questionmark", "Text")
tButton.doRight = function(pButton)
	MultiBot.SpellToMacro(MultiBot.spellbook.name, pButton.spell, pButton.texture)
end
tButton.doLeft = function(pButton)
	SendChatMessage("cast " .. pButton.spell, "WHISPER", nil, MultiBot.spellbook.name)
end

tOverlay.addText("R16", "|cff402000Rank|r", "TOPLEFT", 172, -268, 11)
tOverlay.addText("T16", "|cffffcc00Title|r", "TOPLEFT", 159, -254, 12)
local tButton = tOverlay.addButton("S16", -101, 12, "inv_misc_questionmark", "Text")
tButton.doRight = function(pButton)
	MultiBot.SpellToMacro(MultiBot.spellbook.name, pButton.spell, pButton.texture)
end
tButton.doLeft = function(pButton)
	SendChatMessage("cast " .. pButton.spell, "WHISPER", nil, MultiBot.spellbook.name)
end

tOverlay.boxButton("C01", -214, 262, 16, true)
tOverlay.boxButton("C02",  -85, 262, 16, true)
tOverlay.boxButton("C03", -214, 226, 16, true)
tOverlay.boxButton("C04",  -85, 226, 16, true)
tOverlay.boxButton("C05", -214, 190, 16, true)
tOverlay.boxButton("C06",  -85, 190, 16, true)
tOverlay.boxButton("C07", -214, 154, 16, true)
tOverlay.boxButton("C08",  -85, 154, 16, true)
tOverlay.boxButton("C09", -214, 118, 16, true)
tOverlay.boxButton("C10",  -85, 118, 16, true)
tOverlay.boxButton("C11", -214,  82, 16, true)
tOverlay.boxButton("C12",  -85,  82, 16, true)
tOverlay.boxButton("C13", -214,  46, 16, true)
tOverlay.boxButton("C14",  -85,  46, 16, true)
tOverlay.boxButton("C15", -214,  10, 16, true)
tOverlay.boxButton("C16",  -85,  10, 16, true)

-- REWARD --

MultiBot.reward = MultiBot.newFrame(MultiBot, -754, 238, 28, 384, 512)
MultiBot.reward.rewards = {}
MultiBot.reward.units = {}
MultiBot.reward.from = 1
MultiBot.reward.max = 1
MultiBot.reward.now = 1
MultiBot.reward.to = 12
MultiBot.reward:SetMovable(true)
MultiBot.reward:Hide()

MultiBot.reward.doClose = function()
	local tOverlay = MultiBot.reward.frames["Overlay"]
	for key, value in pairs(MultiBot.reward.units) do if(value.rewarded == false) then return end end
	MultiBot.reward:Hide()
end

local tFrame = MultiBot.reward.addFrame("Icon", -313, 443, 28, 64, 64)
tFrame.addTexture("Interface\\AddOns\\MultiBot\\Textures\\Reward.blp")
tFrame:SetFrameLevel(0)

local tFrame = MultiBot.reward.addFrame("TopLeft", -128, 256, 28, 256, 256)
tFrame.addTexture("Interface/ItemTextFrame/UI-ItemText-TopLeft")
tFrame:SetFrameLevel(1)

local tFrame = MultiBot.reward.addFrame("TopRight", -0, 256, 28, 128, 256)
tFrame.addTexture("Interface/Spellbook/UI-SpellbookPanel-TopRight")
tFrame:SetFrameLevel(2)

local tFrame = MultiBot.reward.addFrame("BottomLeft", -128, 0, 28, 256, 256)
tFrame.addTexture("Interface/ItemTextFrame/UI-ItemText-BotLeft")
tFrame:SetFrameLevel(3)

local tFrame = MultiBot.reward.addFrame("BottomRight", -0, 0, 28, 128, 256)
tFrame.addTexture("Interface/Spellbook/UI-SpellbookPanel-BotRight")
tFrame:SetFrameLevel(4)

local tOverlay = MultiBot.reward.addFrame("Overlay", -48, 97, 28, 310, 330)
tOverlay.addText("Title", MultiBot.info.reward, "CENTER", 16, 226, 13)
tOverlay.addText("Pages", "0/0", "CENTER", 16, 196, 13)
tOverlay:SetFrameLevel(5)

tOverlay.movButton("Move", -270, 354, 50, MultiBot.tips.move.reward, MultiBot.reward)

tOverlay.wowButton("<", -182, 351, 15, 18, 13)
.doLeft = function(pButton)
	local tOverlay = MultiBot.reward.frames["Overlay"]
	local tReward = MultiBot.reward
	
	tReward.to = tReward.to - 12
	tReward.now = tReward.now - 1
	tReward.from = tReward.from - 12
	tOverlay.setText("Pages", tReward.now .. "/" .. tReward.max)
	tOverlay.buttons[">"].doShow()
	
	if(tReward.now == 1) then pButton.doHide() end
	local tIndex = 1
	
	for i = tReward.from, tReward.to do
		MultiBot.setReward(tIndex, MultiBot.reward.units[i])
		tIndex = tIndex + 1
	end
end

tOverlay.wowButton(">", -82, 351, 15, 18, 11)
.doLeft = function(pButton)
	local tOverlay = MultiBot.reward.frames["Overlay"]
	local tReward = MultiBot.reward
	
	tReward.to = tReward.to + 12
	tReward.now = tReward.now + 1
	tReward.from = tReward.from + 12
	tOverlay.setText("Pages", tReward.now .. "/" .. tReward.max)
	tOverlay.buttons["<"].doShow()
	
	if(tReward.now == tReward.max) then pButton.doHide() end
	local tIndex = 1
	
	for i = tReward.from, tReward.to do
		MultiBot.setReward(tIndex, MultiBot.reward.units[i])
		tIndex = tIndex + 1
	end
end

tOverlay.wowButton("X", 13, 381, 17, 20, 11)
.doLeft = function(pButton)
	MultiBot.reward:Hide()
end

-- GROUP:U01 --

local tFrame = tOverlay.addFrame("U01", -156, 282, 23, 154, 48)
tFrame.addText("U01", "|cffffcc00NAME - CLASS|r", "BOTTOMLEFT", 20, 28, 13)
tFrame.addButton("R1", -130, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R2", -104, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R3", -78, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R4", -52, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R5", -26, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R6", -0, 0, "inv_misc_questionmark", "Text")
tFrame.addFrame("Inspector", -137, 26, 16)
.addButton("Inspect", 0, 0, "Interface\\AddOns\\MultiBot\\Icons\\filter_none.blp", "Inspect")
.doLeft = function(pButton)
	InspectUnit(pButton.getName())
end

-- GROUP:U02 --

local tFrame = tOverlay.addFrame("U02", 0, 282, 23, 154, 48)
tFrame.addText("U02", "|cffffcc00NAME - CLASS|r", "BOTTOMLEFT", 20, 28, 13)
tFrame.addButton("R1", -130, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R2", -104, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R3", -78, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R4", -52, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R5", -26, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R6", -0, 0, "inv_misc_questionmark", "Text")
tFrame.addFrame("Inspector", -137, 26, 16)
.addButton("Inspect", 0, 0, "Interface\\AddOns\\MultiBot\\Icons\\filter_none.blp", "Inspect")
.doLeft = function(pButton)
	InspectUnit(pButton.getName())
end

-- GROUP:U03 --

local tFrame = tOverlay.addFrame("U03", -156, 228, 23, 154, 48)
tFrame.addText("U03", "|cffffcc00NAME - CLASS|r", "BOTTOMLEFT", 20, 28, 13)
tFrame.addButton("R1", -130, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R2", -104, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R3", -78, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R4", -52, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R5", -26, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R6", -0, 0, "inv_misc_questionmark", "Text")
tFrame.addFrame("Inspector", -137, 26, 16)
.addButton("Inspect", 0, 0, "Interface\\AddOns\\MultiBot\\Icons\\filter_none.blp", "Inspect")
.doLeft = function(pButton)
	InspectUnit(pButton.getName())
end

-- GROUP:U04 --

local tFrame = tOverlay.addFrame("U04", 0, 228, 23, 154, 48)
tFrame.addText("U04", "|cffffcc00NAME - CLASS|r", "BOTTOMLEFT", 20, 28, 13)
tFrame.addButton("R1", -130, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R2", -104, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R3", -78, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R4", -52, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R5", -26, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R6", -0, 0, "inv_misc_questionmark", "Text")
tFrame.addFrame("Inspector", -137, 26, 16)
.addButton("Inspect", 0, 0, "Interface\\AddOns\\MultiBot\\Icons\\filter_none.blp", "Inspect")
.doLeft = function(pButton)
	InspectUnit(pButton.getName())
end

-- GROUP:U05 --

local tFrame = tOverlay.addFrame("U05", -156, 174, 23, 154, 48)
tFrame.addText("U05", "|cffffcc00NAME - CLASS|r", "BOTTOMLEFT", 20, 28, 13)
tFrame.addButton("R1", -130, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R2", -104, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R3", -78, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R4", -52, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R5", -26, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R6", -0, 0, "inv_misc_questionmark", "Text")
tFrame.addFrame("Inspector", -137, 26, 16)
.addButton("Inspect", 0, 0, "Interface\\AddOns\\MultiBot\\Icons\\filter_none.blp", "Inspect")
.doLeft = function(pButton)
	InspectUnit(pButton.getName())
end

-- GROUP:U06 --

local tFrame = tOverlay.addFrame("U06", 0, 174, 23, 154, 48)
tFrame.addText("U06", "|cffffcc00NAME - CLASS|r", "BOTTOMLEFT", 20, 28, 13)
tFrame.addButton("R1", -130, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R2", -104, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R3", -78, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R4", -52, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R5", -26, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R6", -0, 0, "inv_misc_questionmark", "Text")
tFrame.addFrame("Inspector", -137, 26, 16)
.addButton("Inspect", 0, 0, "Interface\\AddOns\\MultiBot\\Icons\\filter_none.blp", "Inspect")
.doLeft = function(pButton)
	InspectUnit(pButton.getName())
end

-- GROUP:U07 --

local tFrame = tOverlay.addFrame("U07", -156, 120, 23, 154, 48)
tFrame.addText("U07", "|cffffcc00NAME - CLASS|r", "BOTTOMLEFT", 20, 28, 13)
tFrame.addButton("R1", -130, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R2", -104, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R3", -78, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R4", -52, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R5", -26, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R6", -0, 0, "inv_misc_questionmark", "Text")
tFrame.addFrame("Inspector", -137, 26, 16)
.addButton("Inspect", 0, 0, "Interface\\AddOns\\MultiBot\\Icons\\filter_none.blp", "Inspect")
.doLeft = function(pButton)
	InspectUnit(pButton.getName())
end

-- GROUP:U08 --

local tFrame = tOverlay.addFrame("U08", 0, 120, 23, 154, 48)
tFrame.addText("U08", "|cffffcc00NAME - CLASS|r", "BOTTOMLEFT", 20, 28, 13)
tFrame.addButton("R1", -130, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R2", -104, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R3", -78, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R4", -52, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R5", -26, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R6", -0, 0, "inv_misc_questionmark", "Text")
tFrame.addFrame("Inspector", -137, 26, 16)
.addButton("Inspect", 0, 0, "Interface\\AddOns\\MultiBot\\Icons\\filter_none.blp", "Inspect")
.doLeft = function(pButton)
	InspectUnit(pButton.getName())
end

-- GROUP:U09 --

local tFrame = tOverlay.addFrame("U09", -156, 66, 23, 154, 48)
tFrame.addText("U09", "|cffffcc00NAME - CLASS|r", "BOTTOMLEFT", 20, 28, 13)
tFrame.addButton("R1", -130, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R2", -104, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R3", -78, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R4", -52, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R5", -26, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R6", -0, 0, "inv_misc_questionmark", "Text")
tFrame.addFrame("Inspector", -137, 26, 16)
.addButton("Inspect", 0, 0, "Interface\\AddOns\\MultiBot\\Icons\\filter_none.blp", "Inspect")
.doLeft = function(pButton)
	InspectUnit(pButton.getName())
end

-- GROUP:U10 --

local tFrame = tOverlay.addFrame("U10", 0, 66, 23, 154, 48)
tFrame.addText("U10", "|cffffcc00NAME - CLASS|r", "BOTTOMLEFT", 20, 28, 13)
tFrame.addButton("R1", -130, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R2", -104, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R3", -78, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R4", -52, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R5", -26, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R6", -0, 0, "inv_misc_questionmark", "Text")
tFrame.addFrame("Inspector", -137, 26, 16)
.addButton("Inspect", 0, 0, "Interface\\AddOns\\MultiBot\\Icons\\filter_none.blp", "Inspect")
.doLeft = function(pButton)
	InspectUnit(pButton.getName())
end

-- GROUP:U11 --

local tFrame = tOverlay.addFrame("U11", -156, 12, 23, 154, 48)
tFrame.addText("U11", "|cffffcc00NAME - CLASS|r", "BOTTOMLEFT", 20, 28, 13)
tFrame.addButton("R1", -130, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R2", -104, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R3", -78, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R4", -52, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R5", -26, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R6", -0, 0, "inv_misc_questionmark", "Text")
tFrame.addFrame("Inspector", -137, 26, 16)
.addButton("Inspect", 0, 0, "Interface\\AddOns\\MultiBot\\Icons\\filter_none.blp", "Inspect")
.doLeft = function(pButton)
	InspectUnit(pButton.getName())
end

-- GROUP:U12 --

local tFrame = tOverlay.addFrame("U12", 0, 12, 23, 154, 48)
tFrame.addText("U12", "|cffffcc00NAME - CLASS|r", "BOTTOMLEFT", 20, 28, 13)
tFrame.addButton("R1", -130, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R2", -104, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R3", -78, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R4", -52, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R5", -26, 0, "inv_misc_questionmark", "Text")
tFrame.addButton("R6", -0, 0, "inv_misc_questionmark", "Text")
tFrame.addFrame("Inspector", -137, 26, 16)
.addButton("Inspect", 0, 0, "Interface\\AddOns\\MultiBot\\Icons\\filter_none.blp", "Inspect")
.doLeft = function(pButton)
	InspectUnit(pButton.getName())
end

-- TALENT --

MultiBot.talent = MultiBot.newFrame(MultiBot, -104, -276, 28, 1024, 1024)
MultiBot.talent.addTexture("Interface\\AddOns\\MultiBot\\Textures\\Talent.blp")
MultiBot.talent.addText("Points", MultiBot.info.talent["Points"], "CENTER", -228, -8, 13)
MultiBot.talent.addText("Title", MultiBot.info.talent["Title"], "CENTER", -228, 491, 13)
MultiBot.talent:SetMovable(true)
MultiBot.talent:Hide()

MultiBot.talent.movButton("Move", -960, 960, 64, MultiBot.tips.move.talent)

MultiBot.talent.wowButton(MultiBot.info.talent.Apply, -474, 966, 100, 20, 12).doHide()
.doLeft = function(pButton)
	local tValues = ""
	
	for i = 1, 3 do
		local tTab = MultiBot.talent.frames["Tab" .. i]
		
		for j = 1, table.getn(tTab.buttons) do
			tValues = tValues .. tTab.buttons[j].value
		end
		
		if(i < 3) then tValues = tValues .. "-" end
	end
	
	SendChatMessage("talents apply " ..tValues, "WHISPER", nil, MultiBot.talent.name)
	pButton.doHide()
end

local tApply = MultiBot.talent.buttons[ MultiBot.info.talent.Apply ]

MultiBot.talent.wowButton(MultiBot.info.talent.Copy, -854, 966, 100, 20, 12)
local copyBtn = MultiBot.talent.buttons[MultiBot.info.talent.Copy]

copyBtn.doLeft = function(pButton)
	local tName = UnitName("target")
	if(tName == nil or tName == "Unknown Entity") then return SendChatMessage(MultiBot.info.target, "SAY") end
	
	local tLocClass, tClass = UnitClass("target")
	if(MultiBot.talent.class ~= MultiBot.toClass(tClass)) then return SendChatMessage("The Classes do not match.", "SAY") end
	
	local tUnit = MultiBot.toUnit(MultiBot.talent.name)
	if(UnitLevel(tUnit) ~= UnitLevel("target")) then return SendChatMessage("The Levels do not match.", "SAY") end
	
	local tValues = ""
	
	for i = 1, 3 do
		local tTab = MultiBot.talent.frames["Tab" .. i]
		
		for j = 1, table.getn(tTab.buttons) do
			tValues = tValues .. tTab.buttons[j].value
		end
		
		if(i < 3) then tValues = tValues .. "-" end
	end

	SendChatMessage("talents apply " ..tValues, "WHISPER", nil, tName)
end

MultiBot.talent.wowButton("X", -470, 992, 17, 20, 13)
.doLeft = function(pButton)
	local tUnits = MultiBot.frames["MultiBar"].frames["Units"]
	local tButton = tUnits.frames[MultiBot.talent.name].buttons["Talent"]
	tButton.doLeft(tButton)
end

local tTab = MultiBot.talent.addFrame("Tab1", -830, 518, 28, 170, 408)
tTab.addTexture("Interface\\AddOns\\MultiBot\\Textures\\White.blp")
tTab.addText("Title", "Title", "CENTER", 0, 214, 13)
tTab.arrows = {}
tTab.value = 0
tTab.id = 1

local tTab = MultiBot.talent.addFrame("Tab2", -656, 518, 28, 170, 408)
tTab.addTexture("Interface\\AddOns\\MultiBot\\Textures\\White.blp")
tTab.addText("Title", "Title", "CENTER", 0, 214, 13)
tTab.arrows = {}
tTab.value = 0
tTab.id = 2

local tTab = MultiBot.talent.addFrame("Tab3", -482, 518, 28, 170, 408)
tTab.addTexture("Interface\\AddOns\\MultiBot\\Textures\\White.blp")
tTab.addText("Title", "Title", "CENTER", 0, 214, 13)
tTab.arrows = {}
tTab.value = 0
tTab.id = 3

-- ACTUAL GLYPHES START --

-- Minimum level for each Socket (in order 1→6)
local socketReq = { 15, 15, 30, 50, 70, 80 }

local function ShowGlyphTooltip(self)
    local id = self.glyphID
    if not id then return end
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")

    -- 1) try like a spell
    if GameTooltip:SetSpellByID(id) then
        return
    end

    -- 2) try like a item
    GameTooltip:SetHyperlink("item:"..id..":0:0:0:0:0:0:0")
end

local function HideGlyphTooltip()
    GameTooltip:Hide()
end

function MultiBot.FillDefaultGlyphs()
    local botName = MultiBot.talent.name
    local unit    = MultiBot.toUnit(botName)
    if not unit then return end

    -- rec is the table received from the handler, in the following format
    -- { [1]={id=…,type=…}, …, [6]={…} }
    local rec = MultiBot.receivedGlyphs and MultiBot.receivedGlyphs[botName]
    if not rec then
        DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[MultiBot]|r Waiting for glyphs…")
        return
    end

    -- Derive the class key to access glyphDB
    local _, classFile = UnitClass(unit)
    local classKey = (classFile == "DEATHKNIGHT" and "DeathKnight")
                   or (classFile:sub(1,1) .. classFile:sub(2):lower())
    local glyphDB = MultiBot.data.talent.glyphs[classKey] or {}

    -- Loop through each slot i = 1..6
    for i, entry in ipairs(rec) do
        local id, typ = entry.id, entry.type
        local f = MultiBot.talent.frames["Tab4"].frames["Socket"..i]
        if f and f.frames then
            -- 1) Glow
            f.type, f.item = typ, id
            f.frames.Glow:Show()

            -- 2) Rune
            local raw = glyphDB[typ] and glyphDB[typ][id] or ""
            local _, runeIdx = strsplit(",%s*", raw)
            runeIdx = runeIdx or "1"
            local rFrame = f.frames.Rune
            if rFrame then
                rFrame:Hide()
                local runeTex = rFrame.texture or rFrame
                runeTex:SetTexture("Interface\\Spellbook\\UI-Glyph-Rune"..runeIdx)
            end

            -- 3) Icon + Tooltip
            local tex = GetSpellTexture(id)
                     or select(10, GetItemInfo(id))
                     -- or "Interface\\Icons\\INV_Misc_QuestionMark"
					 or "Interface\\AddOns\\MultiBot\\Textures\\UI-GlyphFrame-Glow.blp"
            local btn = f.frames.IconBtn
            if not btn then
                btn = CreateFrame("Button", nil, f)
                btn:SetAllPoints(f)
                btn:SetScript("OnEnter", ShowGlyphTooltip)
                btn:SetScript("OnLeave", HideGlyphTooltip)

                -- Creating the texture
                local icon = btn:CreateTexture(nil, "ARTWORK")
                icon:ClearAllPoints()
                icon:SetPoint("CENTER", btn, "CENTER", -9, 8)

                -- resizing
                local factor = (typ == "Major") and 0.64 or 0.66
                icon:SetSize(f:GetWidth() * factor, f:GetHeight() * factor)

                -- croping
                local crop = (typ == "Major") and 0.14 or 0.20
                icon:SetTexCoord(crop, 1 - crop, crop, 1 - crop)

                btn.icon = icon
                f.frames.IconBtn = btn
            end

            -- Update icon
            btn.glyphID = id
            btn.icon:SetTexture(tex)
            btn:Show()

            -- Overlay circle
            local ov = f.frames.Overlay
            if ov and not ov.texture then
                ov.texture = ov:CreateTexture(nil, "BORDER")
                ov.texture:SetAllPoints(ov)
                local base = "Interface\\AddOns\\MultiBot\\Textures\\"
                ov.texture:SetTexture(
                    base .. (typ == "Major"
                            and "gliph_majeur_layout.blp"
                            or "gliph_mineur_layout.blp"))
            end
            if ov then ov:Show() end
        end
    end

    -- Chat display (optional)
    local names = {}
    for _, entry in ipairs(rec) do
        local n = select(1, GetItemInfo(entry.id))   -- name of object (glyphe)
              or GetSpellInfo(entry.id)              -- fallback if no objecy
              or ("ID "..entry.id)
        table.insert(names,
            (entry.type=="Major" and "|cffffff00" or "|cff00ff00") .. n .. "|r")
    end
    --[[DEFAULT_CHAT_FRAME:AddMessage(
        "|cff66ccff[MultiBot]|r Glyphs for "..botName.." : "..table.concat(names, ", "))]]--
end

-- Add a custom background to the Glyphs Frame (tTab)
local tTab = MultiBot.talent.addFrame("Tab4", -513, 518, 28, 456, 430) -- offset x, offset y, strata level, widht, height
tTab.addFrame("Glow", 0, 0, 28, 456, 430).setAlpha(0.5).doHide()-- .addTexture("Interface/Spellbook/Talent_Glyphs_Glow.blp")
tTab.addTexture("Interface\\AddOns\\MultiBot\\Textures\\Background-GlyphFrame.blp")
tTab:Hide()

local parentTab4 = MultiBot.talent.frames["Tab4"]   -- alias

-- Bouton “Apply Glyphs” – créé **une seule fois** :
gApply = parentTab4.wowButton("Apply Glyphs", 0, 0, 100, 20, 12)
gApply:ClearAllPoints()
gApply:SetPoint("TOPRIGHT", parentTab4, "TOPRIGHT", -20, -20)
gApply:SetFrameLevel(parentTab4:GetFrameLevel() + 10)
gApply:Hide()          -- invisible till no modif
gApply:SetScript("OnClick", function()
    local ids = {}
    for i = 1, 6 do
        ids[i] = parentTab4.frames["Socket"..i].item or 0
    end
    local payload = "glyph equip " .. table.concat(ids, " ")
    DEFAULT_CHAT_FRAME:AddMessage("|cff66ccff[DBG]|r " ..
        (MultiBot.talent.name or "?") .. " : " .. payload)
    SendChatMessage(payload, "WHISPER", nil, MultiBot.talent.name)
    gApply:Hide()
end)

-- GLYPH:SOCKET1 --

-- Level 15
local tGlyph = tTab.addFrame("Socket1", -176.5, 310, 102) -- 1st socket at the top: Major (offset x, offset y, frame size)
tGlyph.addFrame("Glow",   0,  0, 102).setLevel(7).doHide().addTexture("Interface/Spellbook/UI-Glyph-Slot-Major.blp")
tGlyph.addFrame("Rune", -29, 29,  44).setLevel(8).setAlpha(0.7).doHide().addTexture("Interface/Spellbook/UI-Glyph-Rune-1")
tGlyph.frames = tGlyph.frames or {}
tGlyph.type = "Major"
tGlyph.item = 0

tGlyph.addFrame("Overlay", -12, 12, 96).setLevel(9).doHide()

-- GLYPH:SOCKET2 --

-- Level 15
local tGlyph = tTab.addFrame("Socket2", -187, 18.5, 82) -- Minor socket at the very bottom: Minor
tGlyph.addFrame("Glow",   0,  0, 82).setLevel(7).doHide().addTexture("Interface\\Spellbook\\UI-Glyph-Slot-Minor.blp")
tGlyph.addFrame("Rune", -25, 25, 32).setLevel(8).setAlpha(0.7).doHide().addTexture("Interface/Spellbook/UI-Glyph-Rune-1")
tGlyph.frames = tGlyph.frames or {}
tGlyph.type = "Minor"

tGlyph.addFrame("Overlay", -9, 9, 80).setLevel(9).doHide()

-- GLYPH:SOCKET3 --

-- Level 30
local tGlyph = tTab.addFrame("Socket3", -18.5, 50.5, 102) -- Bottom-right socket: Major
tGlyph.addFrame("Glow",   0,  0, 102).setLevel(7).doHide().addTexture("Interface\\Spellbook\\UI-Glyph-Slot-Major.blp")
tGlyph.addFrame("Rune", -29, 29,  44).setLevel(8).setAlpha(0.7).doHide().addTexture("Interface/Spellbook/UI-Glyph-Rune-1")
tGlyph.frames = tGlyph.frames or {}
tGlyph.type = "Major"

tGlyph.addFrame("Overlay", -12, 12, 96) .setLevel(9).doHide()

-- GLYPH:SOCKET4 --

-- Level 50
local tGlyph = tTab.addFrame("Socket4", -302.5, 218, 82) -- Top-left socket: Minor
tGlyph.addFrame("Glow",   0,  0, 82).setLevel(7).doHide().addTexture("Interface\\Spellbook\\UI-Glyph-Slot-Minor.blp")
tGlyph.addFrame("Rune", -25, 25, 32).setLevel(8).setAlpha(0.7).doHide().addTexture("Interface/Spellbook/UI-Glyph-Rune-1")
tGlyph.frames = tGlyph.frames or {}
tGlyph.type = "Minor"

tGlyph.addFrame("Overlay", -9, 9, 80).setLevel(9).doHide()

-- GLYPH:SOCKET5 --

-- Level 70
local tGlyph = tTab.addFrame("Socket5", -72.5, 218, 82) -- Top-right socket: Minor
tGlyph.addFrame("Glow",   0,  0, 82).setLevel(7).doHide().addTexture("Interface\\Spellbook\\UI-Glyph-Slot-Minor.blp")
tGlyph.addFrame("Rune", -25, 25, 32).setLevel(8).setAlpha(0.7).doHide().addTexture("Interface/Spellbook/UI-Glyph-Rune-1")
tGlyph.frames = tGlyph.frames or {}
tGlyph.type = "Minor"

tGlyph.addFrame("Overlay", -9, 9, 80).setLevel(9).doHide()

-- GLYPH:SOCKET6 --

-- Level 80
local tGlyph = tTab.addFrame("Socket6", -336, 50.5, 102) -- Bottom-left socket: Major
tGlyph.addFrame("Glow",   0,  0, 102).setLevel(7).doHide().addTexture("Interface\\Spellbook\\UI-Glyph-Slot-Major.blp")
tGlyph.addFrame("Rune", -29, 29,  44).setLevel(8).setAlpha(0.7).doHide().addTexture("Interface/Spellbook/UI-Glyph-Rune-1")
tGlyph.frames = tGlyph.frames or {}
tGlyph.type = "Major"

tGlyph.addFrame("Overlay", -12, 12, 96) .setLevel(9).doHide()

-- TAB TALENTS --
local tTab = MultiBot.talent.addFrame("Tab5", -900, 461, 28, 96, 24)
tTab.addTexture("Interface\\AddOns\\MultiBot\\Textures\\Talent_Tab.blp")
tTab.wowButton("Talents", -2, 6, 92, 17, 11)
.doLeft = function(pButton)
	if gApply then gApply:Hide() end
    -- Update UI
    MultiBot.talent.setText("Title", MultiBot.doReplace(MultiBot.info.talent.Title, "NAME", MultiBot.talent.name))
    MultiBot.talent.texts["Points"]:Show()
    MultiBot.talent.frames["Tab1"]:Show()
    MultiBot.talent.frames["Tab2"]:Show()
    MultiBot.talent.frames["Tab3"]:Show()
    MultiBot.talent.frames["Tab4"]:Hide()
	copyBtn:doShow()
end

-- TAB GLYPHS --
local tTab = MultiBot.talent.addFrame("Tab6", -800, 461, 28, 96, 24)
tTab.addTexture("Interface\\AddOns\\MultiBot\\Textures\\Talent_Tab.blp")
tTab.wowButton("Glyphs", -2, 6, 92, 17, 11)

.doLeft = function(pButton)
	if gApply then gApply:Hide() end
    -- UI
    MultiBot.talent.setText("Title", "|cffffff00" .. MultiBot.info.glyphsglyphsfor .. " |r" .. (MultiBot.talent.name or "?"))
    MultiBot.talent.texts["Points"]:Hide()
    MultiBot.talent.frames["Tab1"]:Hide()
    MultiBot.talent.frames["Tab2"]:Hide()
    MultiBot.talent.frames["Tab3"]:Hide()
    MultiBot.talent.frames["Tab4"]:Show()
	copyBtn:doHide() 
    local botName = MultiBot.talent.name
    MultiBot.awaitGlyphs = botName
    SendChatMessage("glyphs", "WHISPER", nil, botName)
end

-- GLYPHES END --

MultiBot.talent.setGrid = function(pTab)
	pTab.grid = {}
	pTab.grid.icons = {}
	pTab.grid.icons.size = pTab.size + 8
	pTab.grid.icons.x = pTab.width / 2 + pTab.grid.icons.size * 2 + 4
	pTab.grid.icons.y = pTab.height / 2 + pTab.grid.icons.size * 5.5 + 4
	pTab.grid.arrows = {}
	pTab.grid.arrows.size = pTab.grid.icons.size + 8
	pTab.grid.arrows.x = pTab.width / 2 + pTab.grid.icons.size * 2 - 4
	pTab.grid.arrows.y = pTab.height / 2 + pTab.grid.icons.size * 5.5 - 4
	pTab.grid.values = {}
	pTab.grid.values.x = pTab.width / 2 + pTab.grid.icons.size * 2
	pTab.grid.values.y = pTab.height / 2 + pTab.grid.icons.size * 5.5
	return pTab
end

MultiBot.talent.addArrow = function(pTab, pID, pNeeds, piX, piY, pTexture)
	local tArrow = pTab.addFrame("Arrow" .. pID, piX * pTab.grid.icons.size - pTab.grid.arrows.x, pTab.grid.arrows.y - piY * pTab.grid.icons.size, pTab.grid.arrows.size)
	tArrow.addTexture("Interface\\AddOns\\MultiBot\\Textures\\Talent_Silver_" .. pTexture .. ".blp")
	tArrow.active = "Interface\\AddOns\\MultiBot\\Textures\\Talent_Gold_" .. pTexture .. ".blp"
	tArrow.needs = pNeeds
	tArrow:SetFrameLevel(7)
	return tArrow
end

MultiBot.talent.addTalent = function(pTab, pID, pNeeds, pValue, pMax, piX, piY, pTexture, pTips)
	local tTalent = pTab.addButton(pID, piX * pTab.grid.icons.size - pTab.grid.icons.x, pTab.grid.icons.y - piY * pTab.grid.icons.size, pTexture, pTips[pValue + 1])
    tTalent:RegisterForClicks("LeftButtonUp", "RightButtonUp") 	-- Added for custom talents accept right and left click
	tTalent.points = piY * 5 - 5
	tTalent.needs = pNeeds
	tTalent.value = pValue
	tTalent.tips = pTips
	tTalent.max = pMax
	tTalent.id = pID
	
	tTalent.doLeft = function(pButton)
		if(MultiBot.talent.points == 0) then return end
		
		local tButtons = pButton.parent.buttons
		local tValue = pButton.parent.frames[pButton.id]
		local tTab = pButton.parent
		
		if(pButton.state == false) then return end
		if(pButton.value == pButton.max) then return end
		if(pButton.needs > 0 and tButtons[pButton.needs].value == 0) then return end
		
		MultiBot.talent.points = MultiBot.talent.points - 1
		MultiBot.talent.setText("Points", MultiBot.info.talent["Points"] .. MultiBot.talent.points)
		
		tTab.value = tTab.value + 1
		tTab.setText("Title", MultiBot.info.talent[pButton.getClass() .. tTab.id] .. " ("  .. tTab.value .. ")")
		
		pButton.value = pButton.value + 1
		pButton.tip = pButton.tips[pButton.value + 1]
		
		local tColor = MultiBot.IF(pButton.value < pButton.max, "|cff4db24d", "|cffffcc00")
		tValue.setText("Value", tColor .. pButton.value .. "/" .. pButton.max .. "|r")
		tValue:Show()
		
		for i = 1, table.getn(tButtons) do
			if(tButtons[i].points > tTab.value)
			then tButtons[i].setDisable()
			else
				if(tButtons[i].needs > 0)
				then if(tButtons[tButtons[i].needs].value > 0) then tButtons[i].setEnable() end
				else tButtons[i].setEnable()
				end
			end
		end
		
		MultiBot.talent.buttons[MultiBot.info.talent.Apply].doShow()
		MultiBot.talent.doState()
	end
	
	-- Add right click to remove custom Points
	-- Right click : –1 point
	tTalent.doRight = function(pButton)
		if pButton.value == 0 then return end          -- Nothing to remove
	
		local tTab   = pButton.parent                  -- Tab (tree)
		local tValue = tTab.frames[pButton.id]         -- Text 1/5
	
		-- Restore the global point
		MultiBot.talent.points = MultiBot.talent.points + 1
		MultiBot.talent.setText("Points",
			MultiBot.info.talent["Points"] .. MultiBot.talent.points)
	
		-- -- Update this talent + the tab
		pButton.value = pButton.value - 1
		pButton.tip   = pButton.tips[pButton.value + 1]
		tTab.value    = tTab.value  - 1
		-- Updates the title at the top of the tree
		tTab.setText("Title",
			MultiBot.info.talent[pButton.getClass() .. tTab.id] ..
			" (" .. tTab.value .. ")")
	
		-- Color based on rank
		local c = (pButton.value == 0)      and "|cffffffff"
			or (pButton.value < pButton.max) and "|cff4db24d"
			or "|cffffcc00"
		tValue.setText("Value",
			c .. pButton.value .. "/" .. pButton.max .. "|r")
		if MultiBot.talent.points == 0 and pButton.value == 0 then
			tValue:Hide()
		else
			tValue:Show()
		end
	
		-- -- Re-evaluate the state of all buttons/arrows
		MultiBot.talent.doState()
	
		-- -- Re-display the "Apply" button (modified build)
		MultiBot.talent.buttons[MultiBot.info.talent.Apply].doShow()
	end
		tTalent:SetFrameLevel(8)
		return tTalent
end

MultiBot.talent.addValue = function(pTab, pID, piX, piY, pRank, pMax)
	local tColor = MultiBot.IF(pRank > 0, MultiBot.IF(pRank < pMax, "|cff4db24d", "|cffffcc00"), "|cffffffff")
	local tValue = pTab.addFrame(pID, piX * pTab.grid.icons.size - pTab.grid.values.x, pTab.grid.values.y - piY * pTab.grid.icons.size, 24, 18, 12)
	tValue.addTexture("Interface\\AddOns\\MultiBot\\Textures\\Talent_Black.blp")
	tValue.addText("Value", tColor .. pRank .. "/" .. pMax .. "|r", "CENTER", -0.5, 1, 10)
	if(MultiBot.talent.points == 0 and pRank == 0) then tValue:Hide() end
	tValue:SetFrameLevel(9)
	return tValue
end

MultiBot.talent.setTalents = function()
    -- 1) Check datas
    local tClass = MultiBot.data.talent.talents[ MultiBot.talent.class ]
    if not tClass then
        print("|cffff0000[MultiBot] No build found for class "
              .. tostring(MultiBot.talent.class) .. "!|r")
        return
    end

    local tArrow = MultiBot.data.talent.arrows[ MultiBot.talent.class ]
    if not tArrow then
        print("|cffff0000[MultiBot] No arrow schem found for class "
              .. tostring(MultiBot.talent.class) .. "!|r")
        return
    end

	local activeGroup = GetActiveTalentGroup(true) or 1
	
    -- No talents loaded yet ? we retry in 0,1 s
    if not GetTalentInfo(1, 1, true) then
        TimerAfter(0.1, MultiBot.talent.setTalents)
        return
    end

    -- 2) Frame update
    MultiBot.talent.points = tonumber(GetUnspentTalentPoints(true))
    MultiBot.talent.setText("Points",
        MultiBot.info.talent["Points"] .. MultiBot.talent.points)
    MultiBot.talent.setText("Title",
        MultiBot.doReplace(MultiBot.info.talent["Title"], "NAME",
                           MultiBot.talent.name))

    for i = 1, 3 do
        local tMarker = MultiBot.talent.class .. i
        local tTab    = MultiBot.talent.setGrid(
                            MultiBot.talent.frames["Tab" .. i])
        tTab.setTexture("Interface\\AddOns\\MultiBot\\Textures\\Talent_" ..
                        tMarker .. ".blp")
        tTab.value, tTab.id = 0, i

        -- arrows
        for j = 1, #tArrow[i] do
            local tData = MultiBot.doSplit(tArrow[i][j], ", ")
            local tNeed = tonumber(tData[1])
            tTab.arrows[j] = MultiBot.talent.addArrow(
                                 tTab, j, tNeed, tData[2], tData[3], tData[4])
        end

        -- talents
        for j = 1, #tClass[i] do
            local link = GetTalentLink(i,j,true,nil,activeGroup)
            
            local tTale = MultiBot.doSplit(MultiBot.doSplit(link, "|")[3], ":")[2]

            local iName, iIcon, iTier, iColumn, iRank = GetTalentInfo(i, j, true, nil, activeGroup)

            if not iName then
                TimerAfter(0.1, MultiBot.talent.setTalents)
                return
            end

            local tData = MultiBot.doSplit(tClass[i][j], ", ")
            local tMax  = #tData - 4
            local tNeed = tonumber(tData[1])
            local tRank = tonumber(iRank)
            local tTips = {}

            tTab.value = tTab.value + tRank
            table.insert(tTips,
                "|cff4e96f7|Htalent:" .. tTale ..":-1|h[" .. iName .. "]|h|r")
            for k = 5, #tData do
                table.insert(tTips,
                    "|cff4e96f7|Htalent:" .. tTale ..":" .. (k - 5) ..
                    "|h[" .. iName .. "]|h|r")
            end

            MultiBot.talent.addTalent(
                tTab, j, tNeed, tRank, tMax,
                tData[2], tData[3], tData[4], tTips)
            MultiBot.talent.addValue(
                tTab, j, tData[2], tData[3], tRank, tMax)
        end

        tTab.setText("Title",
            MultiBot.info.talent[tMarker] .. " (" .. tTab.value .. ")")
    end

    -- 3) Final display
    MultiBot.talent.doState()
	MultiBot.talent:Show()
	MultiBot.auto.talent = false
end

MultiBot.talent.doState = function()
	for i = 1, 3 do
		local tTab = MultiBot.talent.frames["Tab" .. i]
		
		for j = 1, table.getn(tTab.buttons) do
			local tTalent = tTab.buttons[j]
			local tValue = tTab.frames[j]
			
			if(MultiBot.talent.points == 0) then
				if(tTalent.value == 0) then
					tTalent.setDisable(false)
					tValue:Hide()
				else
					tTalent.setEnable(false)
					tValue:Show()
				end
			else
				if(tTab.value < tTalent.points) then
					tTalent.setDisable(false)
					tValue:Hide()
				else
					tTalent.setEnable(false)
					tValue:Show()
				end
			end
		end
		
		for j = 1, table.getn(tTab.arrows) do
			if(tTab.buttons[tTab.arrows[j].needs].value > 0) then
				tTab.arrows[j].setTexture(tTab.arrows[j].active)
			end
		end
	end
end

MultiBot.talent.doClear = function()
	for i = 1, 3 do
		local tTab = MultiBot.talent.frames["Tab" .. i]
		for j = 1, table.getn(tTab.buttons) do tTab.buttons[j]:Hide() end
		for j = 1, table.getn(tTab.frames) do tTab.frames[j]:Hide() end
		for j = 1, table.getn(tTab.arrows) do tTab.arrows[j]:Hide() end
		table.wipe(tTab.buttons)
		table.wipe(tTab.frames)
		table.wipe(tTab.arrows)
		tTab.buttons = {}
		tTab.frames = {}
		tTab.arrows = {}
	end
end

--[[
Add a custom tab to talents windows to make custom builds (Tab7)
]]--

local tTab = MultiBot.talent.addFrame("Tab7", -700, 461, 28, 96, 24)
tTab.addTexture("Interface\\AddOns\\MultiBot\\Textures\\Talent_Tab.blp")
local tBtn = tTab.wowButton("Custom Talents", -2, 6, 92, 17, 11)

-- 1) FONCTION to INITIALIZE CUSTOM TAB
function MultiBot.talent.setTalentsCustom()
    -- Protection if data from Talents still not.
    if not GetTalentInfo(1, 1, true) then
        TimerAfter(0.05, MultiBot.talent.setTalentsCustom)
        return
    end
    -- 0) visual Reset
    MultiBot.talent.doClear()
    MultiBot.talent.custom = true

    -- 1) Load existing datas class/arrows
    local tClass = MultiBot.data.talent.talents[ MultiBot.talent.class ]
    local tArrow = MultiBot.data.talent.arrows[  MultiBot.talent.class ]
    if not (tClass and tArrow) then
        print("|cffff0000[MultiBot] Class data missing for custom talents!|r")
        return
    end

    -- 2) Available points (level - 9)
    local unit  = MultiBot.toUnit(MultiBot.talent.name)
    local level = UnitLevel(unit) or 80
    MultiBot.talent.points = math.max(level - 9, 0)

    MultiBot.talent.setText("Points",   MultiBot.info.talent["Points"] .. MultiBot.talent.points)
	MultiBot.talent.setText("Title", "|cffffff00" .. MultiBot.info.talentscustomtalentsfor .. " |r" .. (MultiBot.talent.name or "?"))

    -- 3) Construction of the 3 empty trees
    for i = 1, 3 do
        local marker = MultiBot.talent.class .. i
        local pTab   = MultiBot.talent.setGrid( MultiBot.talent.frames["Tab"..i] )
        pTab.setTexture("Interface\\AddOns\\MultiBot\\Textures\\Talent_"..marker..".blp")
        pTab.value, pTab.id = 0, i

        -- arrows/requireds
        for j = 1, #tArrow[i] do
            local d = MultiBot.doSplit(tArrow[i][j], ", ")
            local need = tonumber(d[1])
            pTab.arrows[j] = MultiBot.talent.addArrow(pTab, j, need, d[2], d[3], d[4])
        end

        -- talents (rank 0 everywhere)
        for j = 1, #tClass[i] do
            local data = MultiBot.doSplit(tClass[i][j], ", ")
            local max  = #data - 4
            local need = tonumber(data[1])
            local tips = {}
            local link = GetTalentLink(i,j,true)
            local tale = MultiBot.doSplit(MultiBot.doSplit(link,"|")[3],":")[2]
            local name, icon = GetTalentInfo(i, j, true)
            table.insert(tips, "|cff4e96f7|Htalent:"..tale..":-1|h["..name.."]|h|r")
            for k=5,#data do
                table.insert(tips, "|cff4e96f7|Htalent:"..tale..":"..(k-5) .."|h["..name.."]|h|r")
            end

            MultiBot.talent.addTalent(pTab, j, need, 0, max, data[2], data[3], data[4], tips)
            MultiBot.talent.addValue (pTab, j, data[2], data[3], 0, max)
        end

        pTab.setText("Title", MultiBot.info.talent[marker] .. " (0)")
    end

    -- 4) Ajustement final + affichage
    MultiBot.talent.texts["Points"]:Show()
    MultiBot.talent.frames["Tab1"]:Show()
    MultiBot.talent.frames["Tab2"]:Show()
    MultiBot.talent.frames["Tab3"]:Show()
    MultiBot.talent.frames["Tab4"]:Hide()   -- glyphs
	if gApply then gApply:Hide() end
	copyBtn:doHide()
    MultiBot.talent.doState()
    MultiBot.talent:Show()
end

-- CALLBACK OF BUTTON (CUSTOM TAB)
tBtn.doLeft = function(btn)
    MultiBot.talent.setTalentsCustom()
end

-- RETURN FROM CUSTOM TO TALENTS
local tabTalentsBtn = MultiBot.talent.frames["Tab5"]
                     and MultiBot.talent.frames["Tab5"].buttons
                     and MultiBot.talent.frames["Tab5"].buttons["Talents"]
if tabTalentsBtn then
    local oldTalentsClick = tabTalentsBtn.doLeft
    tabTalentsBtn.doLeft = function(btn)
        if MultiBot.talent.custom then
            MultiBot.talent.custom = false
            MultiBot.talent.setTalents()   -- Rebuild the actual spec tree
            if oldTalentsClick then
                oldTalentsClick(btn)
            end			
        else
            if oldTalentsClick then oldTalentsClick(btn) end
        end
    end
end

-- END TAB CUSTOM TAMENTS --

--[[
Add a new tab to use custom Glyphs (Tab8)
]]--

local gTab = MultiBot.talent.addFrame("Tab8", -600, 461, 28, 96, 24)
gTab.addTexture("Interface\\AddOns\\MultiBot\\Textures\\Talent_Tab.blp")
local gBtn = gTab.wowButton("Custom Glyphs", -2, 6, 92, 17, 11)

-- 1) Cache for tooltips
local glyphTip

-- 2) Detect Major / Minor glyph via tooltip
local function GetGlyphItemType(itemID)
    if not glyphTip then
        glyphTip = CreateFrame("GameTooltip","MBHiddenTip",nil,"GameTooltipTemplate")
        glyphTip:SetOwner(UIParent,"ANCHOR_NONE")
    end
    glyphTip:ClearLines()
    glyphTip:SetHyperlink("item:"..itemID..":0:0:0:0:0:0:0")
    for i = 2, glyphTip:NumLines() do
        local line = _G[glyphTip:GetName().."TextLeft"..i]
        local txt = (line and line:GetText() or ""):lower()
        if txt:find("major glyph") then return "Major" end
        if txt:find("minor glyph") then return "Minor" end
    end
    return nil
end

-- 3) Build the itemID→classKey table once
local function BuildGlyphClassTable()
    if MultiBot.__glyphClass then return end
    if not MultiBot.data or not MultiBot.data.talent or not MultiBot.data.talent.glyphs then return end
    MultiBot.__glyphClass = {}
    for clsKey, data in pairs(MultiBot.data.talent.glyphs) do
        for id in pairs(data.Major or {}) do
            MultiBot.__glyphClass[id] = clsKey
        end
        for id in pairs(data.Minor or {}) do
            MultiBot.__glyphClass[id] = clsKey
        end
    end
end

-- Preloading during ADDON_LOADED
local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("ADDON_LOADED")
initFrame:SetScript("OnEvent", function(self, event, name)
    if name == "MultiBot" then
        BuildGlyphClassTable()
        self:UnregisterEvent("ADDON_LOADED")
    end
end)

-- Send true if a least a glyph socket are filled
local function HasPendingGlyph()
    for i = 1, 6 do
        if parentTab4.frames["Socket"..i].item ~= 0 then
            return true
        end
    end
    return false
end

-- 4) Oups i drag the wrong glyph
local function ClearGlyphSocket(socketFrame)
    socketFrame.item = 0          -- plus d’ID enregistré

    -- partie visuelle
    if socketFrame.frames.Rune  then socketFrame.frames.Rune:Hide()  end
    if socketFrame.frames.IconBtn then
        local btn = socketFrame.frames.IconBtn
        if btn.icon then btn.icon:SetTexture(nil) end
        if btn.bg   then btn.bg:Show()            end
        btn.glyphID = nil
        btn:Show()          -- on laisse le bouton visible pour un futur drop
    end

    if gApply then
	   if HasPendingGlyph() then
	      gApply:Show()
	   else
	      gApply:Hide()
	    end
	end	
end

-- 5) Shared drag/click handler
local function CG_OnReceiveDrag(self)
    local typ, itemID = GetCursorInfo()
    if typ ~= "item" then return end

    BuildGlyphClassTable()
    local socket = self:GetParent()
	
	-- Reject drop if required level is not reached
local botUnit = MultiBot.toUnit(MultiBot.talent.name)
local lvl     = UnitLevel(botUnit or "player")
	
local idx = socket:GetID()

if idx == 0 then
    idx = tonumber(socket:GetName():match("Socket(%d+)"))
end
if lvl < socketReq[idx] then
    UIErrorsFrame:AddMessage(MultiBot.info.glyphssocketnotunlocked,1,0.3,0.3,1)
    return
end

    local unit   = MultiBot.toUnit(MultiBot.talent.name)
    local _, cf  = UnitClass(unit or "player")
    local classKey = (cf == "DEATHKNIGHT") and "DeathKnight" or (cf:sub(1,1)..cf:sub(2):lower())
    local gDB = (MultiBot.data.talent.glyphs or {})[classKey] or {}

    local glyphClass = MultiBot.__glyphClass and MultiBot.__glyphClass[itemID]
    if glyphClass and glyphClass ~= classKey then
        UIErrorsFrame:AddMessage(MultiBot.info.glyphswrongclass, 1,0.3,0.3,1)
        return
    end

    local gType, info
    if gDB.Major and gDB.Major[itemID] then
        gType, info = "Major", gDB.Major[itemID]
    elseif gDB.Minor and gDB.Minor[itemID] then
        gType, info = "Minor", gDB.Minor[itemID]
    else
        gType = GetGlyphItemType(itemID)
        if not gType then
            UIErrorsFrame:AddMessage(MultiBot.info.glyphsunknowglyph,1,0.3,0.3,1)
            return
        end
    end

    if gType ~= (socket.type or "Major") then
        UIErrorsFrame:AddMessage(MultiBot.info.glyphsglyphtype .. gType .. " : " .. MultiBot.info.glyphsglyphsocket, 1, 0.3, 0.3, 1)
        return
    end

    if info then
        local reqLvl = tonumber((strsplit(",%s*", info)))
        if reqLvl and reqLvl > lvl then
            UIErrorsFrame:AddMessage(MultiBot.info.glyphsleveltoolow,1,0.3,0.3,1)
            return
        end
    end

    if socket.frames.Glow    then socket.frames.Glow:Show()    end
    if socket.frames.Overlay then socket.frames.Overlay:Show() end
    if self.bg then self.bg:Hide() end

    local runeIdx = info and select(2, strsplit(",%s*", info)) or "1"
    local r = socket.frames.Rune
    if r then
        (r.texture or r):SetTexture("Interface/Spellbook/UI-Glyph-Rune-"..runeIdx)
        r:Show()
    end
    -- local tex = select(10, GetItemInfo(itemID)) or GetSpellTexture(itemID) or "Interface\\Icons\\INV_Misc_QuestionMark"
	local tex = select(10, GetItemInfo(itemID)) or GetSpellTexture(itemID) or "Interface\\AddOns\\MultiBot\\Textures\\UI-GlyphFrame-Glow.blp"
    self.icon:SetTexture(tex)
    self.glyphID = itemID
    socket.item = itemID
    ClearCursor()
    gApply:Show()
end

--[[-- 6) Create the Apply button
	gApply = MultiBot.talent.wowButton("Apply Glyphs", -474, 966, 100, 20, 12)
	gApply:Hide()  -- Always hidden until a modification is made
	gApply:SetScript("OnClick", function()
    -- 1) Collect the 6 IDs (0 if slot is empty)
    local ids = {}
    for i = 1, 6 do
        ids[i] = MultiBot.talent.frames["Tab4"].frames["Socket"..i].item or 0
    end

    -- 2) Local DEBUG message
    local payload = "glyph equip "..table.concat(ids, " ")
    DEFAULT_CHAT_FRAME:AddMessage(
        ("|cff66ccff[DBG]|r %s  :  %s")
        :format(MultiBot.talent.name or "?", payload)
    )

    -- 3) Send the new unique command to the bot
    SendChatMessage(payload, "WHISPER", nil, MultiBot.talent.name)

    -- 4) Hide the button again until the next modification
    gApply:Hide()
end)]]--

-- 7) Prepare Tab4 for custom mode
function MultiBot.talent.showCustomGlyphs()
    MultiBot.talent.texts["Points"]:Hide()
    for i=1,3 do MultiBot.talent.frames["Tab"..i]:Hide() end
    -- local parentTab4 = MultiBot.talent.frames["Tab4"]
    parentTab4:Show()

    for i=1,6 do
        local s = parentTab4.frames["Socket"..i]
        if s then
		    s:SetID(i) -- Add an ID to the socket
		    -- Check the bot's level
            local botUnit  = MultiBot.toUnit(MultiBot.talent.name)
			local lvl      = UnitLevel(botUnit or "player")
			local unlocked = lvl >= socketReq[i] -- Ajout pour test
			-- Ensure the Overlay already has its "empty circle" texture
			local ov = s.frames.Overlay
			if ov and not ov.texture then
				ov.texture = ov:CreateTexture(nil, "BORDER")
				ov.texture:SetAllPoints(ov)
				local base = "Interface\\AddOns\\MultiBot\\Textures\\"
				ov.texture:SetTexture(
					base .. (s.type == "Major"
							and "gliph_majeur_layout.blp"
							or  "gliph_mineur_layout.blp"))
			end

        -- If the slot is not yet available, hide everything  
        if not unlocked then
            if s.frames.Glow    then s.frames.Glow:Hide()    end
            if s.frames.Overlay then s.frames.Overlay:Hide() end
            if s.frames.Rune    then s.frames.Rune:Hide()    end
            if s.frames.IconBtn then s.frames.IconBtn:Hide() end
            s.locked = true
        else
            s.locked = false
			
            if s.frames.Glow    then s.frames.Glow:Show()    end
            if s.frames.Overlay then s.frames.Overlay:Show() end
            if s.frames.Rune    then s.frames.Rune:Hide()    end

            local btn = s.frames.IconBtn
            if not btn then
                btn = CreateFrame("Button", nil, s)
                btn:SetAllPoints(s)
                btn.bg = btn:CreateTexture(nil, "BACKGROUND")
                btn.bg:SetAllPoints(s)
                local texSlot = (s.type == "Minor") and
                                 "Interface\\Spellbook\\UI-Glyph-Slot-Minor.blp" or
                                 "Interface\\Spellbook\\UI-Glyph-Slot-Major.blp"
                btn.bg:SetTexture(texSlot)
                local ic = btn:CreateTexture(nil, "ARTWORK")
                ic:SetPoint("CENTER", btn, "CENTER", -9, 8)
                ic:SetSize(s:GetWidth()*0.66, s:GetHeight()*0.66)
                ic:SetTexCoord(0.15, 0.85, 0.15, 0.85)
                btn.icon = ic
                s.frames.IconBtn = btn
            end
			
			if not btn.bg then
				btn.bg = btn:CreateTexture(nil, "BACKGROUND")
				btn.bg:SetAllPoints(s)
				local texSlot = (s.type == "Minor") and
								"Interface\\Spellbook\\UI-Glyph-Slot-Minor.blp" or
								"Interface\\Spellbook\\UI-Glyph-Slot-Major.blp"
				btn.bg:SetTexture(texSlot)
			end

            btn.bg:Show()
            btn.icon:SetTexture(nil)
            btn.icon:Show()
            btn.glyphID = nil
			
            btn:RegisterForDrag("LeftButton")
            btn:RegisterForClicks("LeftButtonUp")
			
            btn:SetScript("OnEnter", ShowGlyphTooltip)
            btn:SetScript("OnLeave", HideGlyphTooltip)
            btn:SetScript("OnReceiveDrag", CG_OnReceiveDrag)
			btn:SetScript("OnClick", CG_OnReceiveDrag)
			-- Yesss i can remove the wrong glyph!
			btn:SetScript("OnMouseUp", function(self, button)
				if button == "RightButton" then
					ClearGlyphSocket(self:GetParent())
				end
			end)
            s.item = 0
        end
    end
end 
    gApply:Hide()
	if copyBtn then copyBtn:doHide() end
	if tApply then tApply:Hide() end
    MultiBot.talent.setText("Title", "|cffffff00" .. MultiBot.info.glyphscustomglyphsfor .. " |r" .. (MultiBot.talent.name or "?"))
end

-- 8) Assignation du clic onglet
gBtn.doLeft = MultiBot.talent.showCustomGlyphs

-- EN TAB CUSTOM GLYPHS --

-- RTSC --

local tRTSC = tMultiBar.addFrame("RTSC", -2, -34, 32).doHide()

local tButton = tRTSC.addButton("RTSC", 0, 0, "ability_hunter_markedfordeath", MultiBot.tips.rtsc.master, "SecureActionButtonTemplate").addMacro("type1", "/cast aedm")
tButton.doRight = function(pButton)
	MultiBot.ActionToGroup("co +rtsc,+guard,?")
	MultiBot.ActionToGroup("nc +rtsc,+guard,?")
end
tButton.doLeft = function(pButton)
	local tFrame = pButton.parent.frames["Selector"]
	tFrame.doReset(tFrame)
end

-- RTSC:STORAGE --

local tSelector = tRTSC.addFrame("Selector", 0, 2, 28)
tSelector.selector = ""

tSelector.doExecute = function(pButton, pAction)
	if(pButton.parent.selector == "") then return MultiBot.ActionToGroup(pAction) end
	local tGroups = MultiBot.doSplit(pButton.parent.selector, " ")
	
	for i = 1, table.getn(tGroups) do
		MultiBot.ActionToGroup(tGroups[i] .. " " .. pAction)
		pButton.parent.buttons[tGroups[i]].setDisable()
	end
	
	pButton.parent.selector = ""
end

tSelector.doSelect = function(pButton, pSelector)
	if(pButton.parent.selector == "")
	then pButton.parent.selector = pSelector
	else pButton.parent.selector = pButton.parent.selector .. " " .. pSelector
	end
end

tSelector.doReset = function(pFrame)
	if(pFrame.selector == "") then return end
	local tGroups = MultiBot.doSplit(pFrame.selector, " ")
	for i = 1, table.getn(tGroups) do pFrame.buttons[tGroups[i]].setDisable() end
	pFrame.selector = ""
end

tSelector.addButton("MACRO9", -34, 0, "achievement_bg_winwsg_3-0", MultiBot.tips.rtsc.macro, "SecureActionButtonTemplate").addMacro("type1", "/cast aedm").setDisable()
.doLeft = function(pButton)
	MultiBot.ActionToGroup("rtsc save 9")
	pButton.parent.buttons["RTSC9"].doShow()
	pButton.doHide()
end

local tButton = tSelector.addButton("RTSC9", -34, 0, "achievement_bg_winwsg_3-0", MultiBot.tips.rtsc.spot, "SecureActionButtonTemplate").doHide()
tButton.doRight = function(pButton)
	MultiBot.ActionToGroup("rtsc unsave 9")
	pButton.parent.buttons["MACRO9"].doShow()
	pButton.doHide()
end
tButton.doLeft = function(pButton)
	pButton.parent.doExecute(pButton, "rtsc go 9")
end

tSelector.addButton("MACRO8", -64, 0, "achievement_bg_winwsg_3-0", MultiBot.tips.rtsc.macro, "SecureActionButtonTemplate").addMacro("type1", "/cast aedm").setDisable()
.doLeft = function(pButton)
	MultiBot.ActionToGroup("rtsc save 8")
	pButton.parent.buttons["RTSC8"].doShow()
	pButton.doHide()
end

local tButton = tSelector.addButton("RTSC8", -64, 0, "achievement_bg_winwsg_3-0", MultiBot.tips.rtsc.spot, "SecureActionButtonTemplate").doHide()
tButton.doRight = function(pButton)
	MultiBot.ActionToGroup("rtsc unsave 8")
	pButton.parent.buttons["MACRO8"].doShow()
	pButton.doHide()
end
tButton.doLeft = function(pButton)
	pButton.parent.doExecute(pButton, "rtsc go 8")
end

tSelector.addButton("MACRO7", -94, 0, "achievement_bg_winwsg_3-0", MultiBot.tips.rtsc.macro, "SecureActionButtonTemplate").addMacro("type1", "/cast aedm").setDisable()
.doLeft = function(pButton)
	MultiBot.ActionToGroup("rtsc save 7")
	pButton.parent.buttons["RTSC7"].doShow()
	pButton.doHide()
end

local tButton = tSelector.addButton("RTSC7", -94, 0, "achievement_bg_winwsg_3-0", MultiBot.tips.rtsc.spot, "SecureActionButtonTemplate").doHide()
tButton.doRight = function(pButton)
	MultiBot.ActionToGroup("rtsc unsave 7")
	pButton.parent.buttons["MACRO7"].doShow()
	pButton.doHide()
end
tButton.doLeft = function(pButton)
	pButton.parent.doExecute(pButton, "rtsc go 7")
end

tSelector.addButton("MACRO6", -124, 0, "achievement_bg_winwsg_3-0", MultiBot.tips.rtsc.macro, "SecureActionButtonTemplate").addMacro("type1", "/cast aedm").setDisable()
.doLeft = function(pButton)
	MultiBot.ActionToGroup("rtsc save 6")
	pButton.parent.buttons["RTSC6"].doShow()
	pButton.doHide()
end

local tButton = tSelector.addButton("RTSC6", -124, 0, "achievement_bg_winwsg_3-0", MultiBot.tips.rtsc.spot, "SecureActionButtonTemplate").doHide()
tButton.doRight = function(pButton)
	MultiBot.ActionToGroup("rtsc unsave 6")
	pButton.parent.buttons["MACRO6"].doShow()
	pButton.doHide()
end
tButton.doLeft = function(pButton)
	pButton.parent.doExecute(pButton, "rtsc go 6")
end

tSelector.addButton("MACRO5", -154, 0, "achievement_bg_winwsg_3-0", MultiBot.tips.rtsc.macro, "SecureActionButtonTemplate").addMacro("type1", "/cast aedm").setDisable()
.doLeft = function(pButton)
	MultiBot.ActionToGroup("rtsc save 5")
	pButton.parent.buttons["RTSC5"].doShow()
	pButton.doHide()
end

local tButton = tSelector.addButton("RTSC5", -154, 0, "achievement_bg_winwsg_3-0", MultiBot.tips.rtsc.spot, "SecureActionButtonTemplate").doHide()
tButton.doRight = function(pButton)
	MultiBot.ActionToGroup("rtsc unsave 5")
	pButton.parent.buttons["MACRO5"].doShow()
	pButton.doHide()
end
tButton.doLeft = function(pButton)
	pButton.parent.doExecute(pButton, "rtsc go 5")
end

tSelector.addButton("MACRO4", -184, 0, "achievement_bg_winwsg_3-0", MultiBot.tips.rtsc.macro, "SecureActionButtonTemplate").addMacro("type1", "/cast aedm").setDisable()
.doLeft = function(pButton)
	MultiBot.ActionToGroup("rtsc save 4")
	pButton.parent.buttons["RTSC4"].doShow()
	pButton.doHide()
end

local tButton = tSelector.addButton("RTSC4", -184, 0, "achievement_bg_winwsg_3-0", MultiBot.tips.rtsc.spot, "SecureActionButtonTemplate").doHide()
tButton.doRight = function(pButton)
	MultiBot.ActionToGroup("rtsc unsave 4")
	pButton.parent.buttons["MACRO4"].doShow()
	pButton.doHide()
end
tButton.doLeft = function(pButton)
	pButton.parent.doExecute(pButton, "rtsc go 4")
end

tSelector.addButton("MACRO3", -214, 0, "achievement_bg_winwsg_3-0", MultiBot.tips.rtsc.macro, "SecureActionButtonTemplate").addMacro("type1", "/cast aedm").setDisable()
.doLeft = function(pButton)
	MultiBot.ActionToGroup("rtsc save 3")
	pButton.parent.buttons["RTSC3"].doShow()
	pButton.doHide()
end

local tButton = tSelector.addButton("RTSC3", -214, 0, "achievement_bg_winwsg_3-0", MultiBot.tips.rtsc.spot, "SecureActionButtonTemplate").doHide()
tButton.doRight = function(pButton)
	MultiBot.ActionToGroup("rtsc unsave 3")
	pButton.parent.buttons["MACRO3"].doShow()
	pButton.doHide()
end
tButton.doLeft = function(pButton)
	pButton.parent.doExecute(pButton, "rtsc go 3")
end

tSelector.addButton("MACRO2", -244, 0, "achievement_bg_winwsg_3-0", MultiBot.tips.rtsc.macro, "SecureActionButtonTemplate").addMacro("type1", "/cast aedm").setDisable()
.doLeft = function(pButton)
	MultiBot.ActionToGroup("rtsc save 2")
	pButton.parent.buttons["RTSC2"].doShow()
	pButton.doHide()
end

local tButton = tSelector.addButton("RTSC2", -244, 0, "achievement_bg_winwsg_3-0", MultiBot.tips.rtsc.spot, "SecureActionButtonTemplate").doHide()
tButton.doRight = function(pButton)
	MultiBot.ActionToGroup("rtsc unsave 2")
	pButton.parent.buttons["MACRO2"].doShow()
	pButton.doHide()
end
tButton.doLeft = function(pButton)
	pButton.parent.doExecute(pButton, "rtsc go 2")
end

tSelector.addButton("MACRO1", -274, 0, "achievement_bg_winwsg_3-0", MultiBot.tips.rtsc.macro, "SecureActionButtonTemplate").addMacro("type1", "/cast aedm").setDisable()
.doLeft = function(pButton)
	MultiBot.ActionToGroup("rtsc save 1")
	pButton.parent.buttons["RTSC1"].doShow()
	pButton.doHide()
end

local tButton = tSelector.addButton("RTSC1", -274, 0, "achievement_bg_winwsg_3-0", MultiBot.tips.rtsc.spot, "SecureActionButtonTemplate").doHide()
tButton.doRight = function(pButton)
	MultiBot.ActionToGroup("rtsc unsave 1")
	pButton.parent.buttons["MACRO1"].doShow()
	pButton.doHide()
end
tButton.doLeft = function(pButton)
	pButton.parent.doExecute(pButton, "rtsc go 1")
end

-- RTSC:SELECTOR --

local tButton = tSelector.addButton("@group1", 30, 0, "Interface\\AddOns\\MultiBot\\Icons\\rtsc_group1.blp", MultiBot.tips.rtsc.group1, "SecureActionButtonTemplate").addMacro("type1", "/cast aedm").doHide().setDisable()
tButton.doRight = function(pButton)
	MultiBot.ActionToGroup("@group1 rtsc select")
	pButton.parent.doSelect(pButton, "@group1")
	pButton.setEnable()
end
tButton.doLeft = function(pButton)
	MultiBot.ActionToGroup("@group1 rtsc select")
	pButton.parent.doReset(pButton.parent)
end

local tButton = tSelector.addButton("@group2", 60, 0, "Interface\\AddOns\\MultiBot\\Icons\\rtsc_group2.blp", MultiBot.tips.rtsc.group2, "SecureActionButtonTemplate").addMacro("type1", "/cast aedm").doHide().setDisable()
tButton.doRight = function(pButton)
	MultiBot.ActionToGroup("@group2 rtsc select")
	pButton.parent.doSelect(pButton, "@group2")
	pButton.setEnable()
end
tButton.doLeft = function(pButton)
	MultiBot.ActionToGroup("@group2 rtsc select")
	pButton.parent.doReset(pButton.parent)
end

local tButton = tSelector.addButton("@group3", 90, 0, "Interface\\AddOns\\MultiBot\\Icons\\rtsc_group3.blp", MultiBot.tips.rtsc.group3, "SecureActionButtonTemplate").addMacro("type1", "/cast aedm").doHide().setDisable()
tButton.doRight = function(pButton)
	MultiBot.ActionToGroup("@group3 rtsc select")
	pButton.parent.doSelect(pButton, "@group3")
	pButton.setEnable()
end
tButton.doLeft = function(pButton)
	MultiBot.ActionToGroup("@group3 rtsc select")
	pButton.parent.doReset(pButton.parent)
end

local tButton = tSelector.addButton("@group4", 120, 0, "Interface\\AddOns\\MultiBot\\Icons\\rtsc_group4.blp", MultiBot.tips.rtsc.group4, "SecureActionButtonTemplate").addMacro("type1", "/cast aedm").doHide().setDisable()
tButton.doRight = function(pButton)
	MultiBot.ActionToGroup("@group4 rtsc select")
	pButton.parent.doSelect(pButton, "@group4")
	pButton.setEnable()
end
tButton.doLeft = function(pButton)
	MultiBot.ActionToGroup("@group4 rtsc select")
	pButton.parent.doReset(pButton.parent)
end

local tButton = tSelector.addButton("@group5", 150, 0, "Interface\\AddOns\\MultiBot\\Icons\\rtsc_group5.blp", MultiBot.tips.rtsc.group5, "SecureActionButtonTemplate").addMacro("type1", "/cast aedm").doHide().setDisable()
tButton.doRight = function(pButton)
	MultiBot.ActionToGroup("@group5 rtsc select")
	pButton.parent.doSelect(pButton, "@group5")
	pButton.setEnable()
end
tButton.doLeft = function(pButton)
	MultiBot.ActionToGroup("@group5 rtsc select")
	pButton.parent.doReset(pButton.parent)
end

local tButton = tSelector.addButton("@tank", 30, 0, "Interface\\AddOns\\MultiBot\\Icons\\rtsc_tank.blp", MultiBot.tips.rtsc.tank, "SecureActionButtonTemplate").addMacro("type1", "/cast aedm").setDisable()
tButton.doRight = function(pButton)
	MultiBot.ActionToGroup("@tank rtsc select")
	pButton.parent.doSelect(pButton, "@tank")
	pButton.setEnable()
end
tButton.doLeft = function(pButton)
	MultiBot.ActionToGroup("@tank rtsc select")
	pButton.parent.doReset(pButton.parent)
end

local tButton = tSelector.addButton("@dps", 60, 0, "Interface\\AddOns\\MultiBot\\Icons\\rtsc_dps.blp", MultiBot.tips.rtsc.dps, "SecureActionButtonTemplate").addMacro("type1", "/cast aedm").setDisable()
tButton.doRight = function(pButton)
	MultiBot.ActionToGroup("@dps rtsc select")
	pButton.parent.doSelect(pButton, "@dps")
	pButton.setEnable()
end
tButton.doLeft = function(pButton)
	MultiBot.ActionToGroup("@dps rtsc select")
	pButton.parent.doReset(pButton.parent)
end

local tButton = tSelector.addButton("@healer", 90, 0, "Interface\\AddOns\\MultiBot\\Icons\\rtsc_healer.blp", MultiBot.tips.rtsc.healer, "SecureActionButtonTemplate").addMacro("type1", "/cast aedm").setDisable()
tButton.doRight = function(pButton)
	MultiBot.ActionToGroup("@healer rtsc select")
	pButton.parent.doSelect(pButton, "@healer")
	pButton.setEnable()
end
tButton.doLeft = function(pButton)
	MultiBot.ActionToGroup("@healer rtsc select")
	pButton.parent.doReset(pButton.parent)
end

local tButton = tSelector.addButton("@melee", 120, 0, "Interface\\AddOns\\MultiBot\\Icons\\rtsc_melee.blp", MultiBot.tips.rtsc.melee, "SecureActionButtonTemplate").addMacro("type1", "/cast aedm").setDisable()
tButton.doRight = function(pButton)
	MultiBot.ActionToGroup("@melee rtsc select")
	pButton.parent.doSelect(pButton, "@melee")
	pButton.setEnable()
end
tButton.doLeft = function(pButton)
	MultiBot.ActionToGroup("@melee rtsc select")
	pButton.parent.doReset(pButton.parent)
end

local tButton = tSelector.addButton("@ranged", 150, 0, "Interface\\AddOns\\MultiBot\\Icons\\rtsc_ranged.blp", MultiBot.tips.rtsc.ranged, "SecureActionButtonTemplate").addMacro("type1", "/cast aedm").setDisable()
tButton.doRight = function(pButton)
	MultiBot.ActionToGroup("@ranged rtsc select")
	pButton.parent.doSelect(pButton, "@ranged")
	pButton.setEnable()
end
tButton.doLeft = function(pButton)
	MultiBot.ActionToGroup("@ranged rtsc select")
	pButton.parent.doReset(pButton.parent)
end

local tButton = tSelector.addButton("@all", 180, 0, "Interface\\AddOns\\MultiBot\\Icons\\rtsc.blp", MultiBot.tips.rtsc.all, "SecureActionButtonTemplate").addMacro("type1", "/cast aedm")
tButton.doRight = function(pButton)
	MultiBot.ActionToGroup("rtsc select")
	pButton.parent.doReset(pButton.parent)
end
tButton.doLeft = function(pButton)
	MultiBot.ActionToGroup("rtsc select")
	pButton.parent.doReset(pButton.parent)
end

local tButton = tSelector.addButton("Browse", 210, 0, "Interface\\AddOns\\MultiBot\\Icons\\rtsc_browse.blp", MultiBot.tips.rtsc.browse)
tButton.doRight = function(pButton)
	MultiBot.ActionToGroup("rtsc cancel")
	pButton.parent.doReset(pButton.parent)
end
tButton.doLeft = function(pButton)
	local tFrame = pButton.parent
	
	if(pButton.state) then
		tFrame.buttons["@dps"].doShow()
		tFrame.buttons["@tank"].doShow()
		tFrame.buttons["@melee"].doShow()
		tFrame.buttons["@healer"].doShow()
		tFrame.buttons["@ranged"].doShow()
		tFrame.buttons["@group1"].doHide()
		tFrame.buttons["@group2"].doHide()
		tFrame.buttons["@group3"].doHide()
		tFrame.buttons["@group4"].doHide()
		tFrame.buttons["@group5"].doHide()
		pButton.state = false
	else
		tFrame.buttons["@dps"].doHide()
		tFrame.buttons["@tank"].doHide()
		tFrame.buttons["@healer"].doHide()
		tFrame.buttons["@melee"].doHide()
		tFrame.buttons["@ranged"].doHide()
		tFrame.buttons["@group1"].doShow()
		tFrame.buttons["@group2"].doShow()
		tFrame.buttons["@group3"].doShow()
		tFrame.buttons["@group4"].doShow()
		tFrame.buttons["@group5"].doShow()
		pButton.state = true
	end
end

-- FINISH --

MultiBot.state = true
print("MultiBot")