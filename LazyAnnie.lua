
Callback.Add("Load", function() Program:OnLoad() end)

--_______________________________________________________________________________________________________________________________________________________________

--[[
 _______  _______  _______  _        _       
(  ____ \(  ____ )(  ____ \( \      ( \      
| (    \/| (    )|| (    \/| (      | (      
| (_____ | (____)|| (__    | |      | |      
(_____  )|  _____)|  __)   | |      | |      
      ) || (      | (      | |      | |      
/\____) || )      | (____/\| (____/\| (____/\
\_______)|/       (_______/(_______/(_______/
                                             
]]--

function IsReadyToCast(slot)
	return Game.CanUseSpell(slot) == 0
end

function IsValid(range, unit)
	return unit:IsValidTarget(range, nil, myHero) and not unit.isImmortal and unit.health > 0 and not unit.dead
end

function GetLastSpellCast()
	local timer = 0
	if myHero.activeSpell.valid and myHero.isChanneling then 
		timer = GetTickCount()
	end
	return timer
end

function CastQ(unit)

	if IsReadyToCast(_Q) and IsValid(Annie.Q.range, unit) and myHero.pos:DistanceTo(unit.pos) < Annie.Q.range and GetLastSpellCast() + 250 < GetTickCount() then
		if Annie.menu.customCast:Value() then 
			CastSpell2(HK_Q, unit.pos)
		else
			Control.CastSpell(HK_Q, unit.pos)
		end
	end
end

function CastW(unit)

	if IsReadyToCast(_W) and IsValid(Annie.W.range, unit) and myHero.pos:DistanceTo(unit.pos) < Annie.W.range and GetLastSpellCast() + 250 < GetTickCount() then
		if Annie.menu.customCast:Value() then 
			CastSpell2(HK_W, unit.pos)
		else
			Control.CastSpell(HK_W, unit.pos)
		end
	end
end

function CastR(unit)

	if IsReadyToCast(_R) and IsValid(Annie.R.range, unit) and myHero.pos:DistanceTo(unit.pos) < Annie.R.range and GetLastSpellCast() + 250 < GetTickCount() then
		if Annie.menu.customCast:Value() then 
			CastSpell2(HK_R, unit.pos)
		else
			Control.CastSpell(HK_R, unit.pos)
		end
	end
end

--_______________________________________________________________________________________________________________________________________________________________

--[[
          _______  _______  _______ 
|\     /|(  ____ \(  ____ )(  ___  )
| )   ( || (    \/| (    )|| (   ) |
| (___) || (__    | (____)|| |   | |
|  ___  ||  __)   |     __)| |   | |
| (   ) || (      | (\ (   | |   | |
| )   ( || (____/\| ) \ \__| (___) |
|/     \|(_______/|/   \__/(_______)
                           
]]--

class "Annie"

function Annie:GetDmg(unit)

	local damage = 0

	if IsReadyToCast(_Q) then
		damage = damage + getdmg("Q", unit, myHero)
	end
	if IsReadyToCast(_W) then
		damage = damage + getdmg("W", unit, myHero)
	end
	if IsReadyToCast(_R) then
		damage = damage + getdmg("R", unit, myHero)
	end

	return damage
end

function Annie:GetManaPercent(unit)
	return unit.mana / unit.maxMana * 100
end

function Annie:GetTarget(range)

	if _G.EOWLoaded then
		return EOW:GetTarget(range, EOW.ap_dec, myHero.pos)
	elseif _G.SDK then
		return _G.SDK.TargetSelector:GetTarget(range, _G.SDK.DAMAGE_TYPE_MAGICAL)
	elseif _G.GOS then
		return GOS:GetTarget(range, "AP")
	end
end

function Annie:__init()

	self.Nudes = 	
	{ 	
		Swaghetti = "https://i.imgur.com/KdslWVD.png",
		Hero = "https://i.imgur.com/dxui3s2.png",
		Passive = "https://i.imgur.com/f4p3IjG.png",
		Q = "https://i.imgur.com/HUj9ZuK.png",
		W = "https://i.imgur.com/AXcQ7Z4.png",
		E = "https://i.imgur.com/d2ZsLKd.png",
		R = "https://i.imgur.com/blVeTd5.png",
		Tear = "https://i.imgur.com/7sREK0V.png"
	}

	self.RecallData = {}

	self:LoadMenu()
	self:LoadSpells()

	Callback.Add("Tick", function() self:OnTick() end)
	Callback.Add("Draw", function() self:OnDraw() end)
	Callback.Add("ProcessRecall", function(unit, proc) self:OnRecall(unit, proc) end)
end

function Annie:OnRecall(unit, proc)
	if unit.networkID == myHero.networkID then
		if proc.isStart then
    		table.insert(self.RecallData, {object = unit})
    	else
      		for i, rc in pairs(self.RecallData) do
        		if rc.object.networkID == unit.networkID then
         	 		table.remove(self.RecallData, i)
        		end
      		end
      	end
	end
end

function Annie:IsRecalling()
	for i, recall in pairs(self.RecallData) do
    	if recall.object.networkID == myHero.networkID then
    		return true
	    end
	end
	return false
end

function Annie:LoadSpells()
	self.Q = { range = myHero:GetSpellData(_Q).range }
    self.W = { range = myHero:GetSpellData(_W).range, width = myHero:GetSpellData(_W).width, delay = 0.25, angle = myHero:GetSpellData(_W).coneAngle,  speed = 0 } -- Maybe soonTM Kappa
    self.R = { range = myHero:GetSpellData(_R).range, width = myHero:GetSpellData(_R).width, delay = 0.25 , speed = 0 }
end

function Annie:LoadMenu()

	self.menu = MenuElement({id = "menu", name = "Lazy Annie", type = MENU, leftIcon = self.Nudes.Hero })

	self.menu:MenuElement({id = "customCast", name = "Use Custom SpellCast", value = true, leftIcon = self.Nudes.Swaghetti}) -- bool
	self.menu:MenuElement({id = "Combo", name = "Combo", type = MENU})
	self.menu:MenuElement({id = "Harass", name = "Harras", type = MENU})
	self.menu:MenuElement({id = "LaneClear", name = "LaneClear", type = MENU})
	self.menu:MenuElement({id = "JungleClear", name = "JungleClear", type = MENU})
	self.menu:MenuElement({id = "LastHit", name = "LastHit", type = MENU})
	self.menu:MenuElement({id = "Misc", name = "Misc", type = MENU})
	self.menu:MenuElement({id = "Key", name = "Key Settings", type = MENU})

	self.menu.Key:MenuElement({id = "Combo", name = "Combo", key = string.byte(" ")})
	self.menu.Key:MenuElement({id = "Harass", name = "Harass", key = string.byte("C")})
	self.menu.Key:MenuElement({id = "Clear", name = "Lane/JungleClear", key = string.byte("V")})
	self.menu.Key:MenuElement({id = "LastHit", name = "LastHit", key = string.byte("X")})

	-- Combo
	self.menu.Combo:MenuElement({id = "useQ", name = "Use Q", value = true, leftIcon = self.Nudes.Q}) -- bool
	self.menu.Combo:MenuElement({id = "useW", name = "Use W", value = true, leftIcon = self.Nudes.W}) -- bool
	self.menu.Combo:MenuElement({id = "useR", name = "Use R", value = true, leftIcon = self.Nudes.R}) -- bool

	-- Harass
	self.menu.Harass:MenuElement({id = "useQ", name = "Use Q", value = true, leftIcon = self.Nudes.Q})
	self.menu.Harass:MenuElement({id = "useQmana", name = "Mana to use Q", value = 60, min = 0, max = 100, step = 1, leftIcon = self.Nudes.Tear}) -- slider
	self.menu.Harass:MenuElement({id = "useW", name = "Use W", value = true, leftIcon = self.Nudes.W})
	self.menu.Harass:MenuElement({id = "useWmana", name = "Mana to use W", value = 60, min = 0, max = 100, step = 1, leftIcon = self.Nudes.Tear}) -- slider

	-- LaneClear
	self.menu.LaneClear:MenuElement({id = "useQ", name = "Use Q", value = true, leftIcon = self.Nudes.Q})
	self.menu.LaneClear:MenuElement({id = "useQmana", name = "Mana to use Q", value = 60, min = 0, max = 100, step = 1, leftIcon = self.Nudes.Tear}) -- slider

	-- JungleClear
	self.menu.JungleClear:MenuElement({id = "useQ", name = "Use Q", value = true, leftIcon = self.Nudes.Q})
	self.menu.JungleClear:MenuElement({id = "useQmana", name = "Mana to use Q", value = 60, min = 0, max = 100, step = 1, leftIcon = self.Nudes.Tear}) -- slider
	self.menu.JungleClear:MenuElement({id = "useW", name = "Use W", value = true, leftIcon = self.Nudes.W})
	self.menu.JungleClear:MenuElement({id = "useWmana", name = "Mana to use W", value = 60, min = 0, max = 100, step = 1, leftIcon = self.Nudes.Tear}) -- slider

	-- LastHit
	self.menu.LastHit:MenuElement({id = "useQ", name = "Use Q", value = true, leftIcon = self.Nudes.Q})
	self.menu.LastHit:MenuElement({id = "useQmana", name = "Mana to use Q", value = 60, min = 0, max = 100, step = 1, leftIcon = self.Nudes.Tear}) -- slider

	-- Misc
	self.menu.Misc:MenuElement({id = "stack", name = "Stack passive with E", key = string.byte("T"), toggle = true, leftIcon = self.Nudes.Passive})

end

function Annie:OnTick()

	if myHero.dead then return end

	Orb:GetMode()
	GetLastSpellCast()

	local target = self:GetTarget(800)

	if Orb.combo and target ~= nil then
		self:Combo(target)
	elseif Orb.harass and target ~= nil then
		self:Harass(target)
	elseif Orb.lastHit then
		self:LastHit()
	elseif Orb.laneClear then
		self:LaneClear()		
	end

	if self.menu.Misc.stack:Value() and not self:IsRecalling() then
		self:AutoStack()
	end
end

function Annie:OnDraw()

	local heroPos2D = myHero.pos:To2D()

	if self.menu.Misc.stack:Value() then
		Draw.Text("Stacking ENABLED", 10, heroPos2D.x - 40, heroPos2D.y + 80, Draw.Color(255, 222, 000, 088)) -- Not even random
	end
end

function Annie:AutoStack()

	local fountain = Obj_AI_SpawnPoint

	if IsReadyToCast(_W) and GetLastSpellCast() + 250 < GetTickCount() then

		if myHero.pos:DistanceTo(fountain) <= 900 and myHero.hudAmmo ~= myHero.hudMaxAmmo then
			Control.KeyDown(HK_W) 
			Control.KeyUp(HK_W)
		end
	end

	if IsReadyToCast(_E) and GetLastSpellCast() + 250 < GetTickCount() then 
		
		if myHero.hudAmmo ~= myHero.hudMaxAmmo then
			Control.KeyDown(HK_E) 
			Control.KeyUp(HK_E)
		end
	end
end

function CastSpell2(spell,pos,delay) -- Noddy

	local castSpell = {state = 0, tick = GetTickCount(), casting = GetTickCount() - 1000, mouse = mousePos}
	local delay = delay or 250
	local ticker = GetTickCount()

	if pos == nil then return end

	if castSpell.state == 0 and ticker - castSpell.casting > delay + Game.Latency() then
		castSpell.state = 1
		castSpell.mouse = mousePos
		castSpell.tick = ticker
	end

	if castSpell.state == 1 then

		if ticker - castSpell.tick < Game.Latency() then
			Control.SetCursorPos(pos)
			Control.KeyDown(spell)
			Control.KeyUp(spell)
			castSpell.casting = ticker + delay
			DelayAction(function()
				if castSpell.state == 1 then
					Control.SetCursorPos(castSpell.mouse)
					castSpell.state = 0
				end
			end, Game.Latency()/1000)
		end

		if ticker - castSpell.casting > Game.Latency() then
			Control.SetCursorPos(castSpell.mouse)
			castSpell.state = 0
		end
	end
end

function Annie:Combo(target)

	-- Q --
	if self.menu.Combo.useQ:Value() then
		CastQ(target)
	end

	-- W --
	if self.menu.Combo.useW:Value() then
		CastW(target)
	end

	-- R --
	if self.menu.Combo.useR:Value() then
		if target.health <= self:GetDmg(target) then
			CastR(target)
		end
	end
end

function Annie:Harass(target)

	-- Q --
	if self.menu.Harass.useQ:Value() and self:GetManaPercent(myHero) > self.menu.Harass.useQmana:Value() then
		CastQ(target)
	end

	-- W --
	if self.menu.Harass.useW:Value() and self:GetManaPercent(myHero) > self.menu.Harass.useQmana:Value() then
		CastW(target)
	end
end

function Annie:LaneClear()

	local qMinion
	
	if Game.MinionCount() > 0 then
		for i = 0, Game.MinionCount() do

			local m = Game.Minion(i)
			if m and m.isEnemy and m.valid and not m.dead and m.health < getdmg("Q", m) and myHero.pos:DistanceTo(m.pos) < self.Q.range then
				qMinion = m
				break
			end
		end
	end

	if qMinion ~= nil then
		if self.menu.LaneClear.useQ:Value() and
			self:GetManaPercent(myHero) > self.menu.LaneClear.useQmana:Value() then
			CastQ(qMinion)
		end
	end
end

function Annie:LastHit()

	local qMinion
	
	if Game.MinionCount() > 0 then
		for i = 0, Game.MinionCount() do

			local m = Game.Minion(i)
			if m and m.isEnemy and m.valid and not m.dead and m.health < getdmg("Q", m) and myHero.pos:DistanceTo(m.pos) < self.Q.range then
				qMinion = m
				break
			end
		end
	end

	if qMinion ~= nil then
		if self.menu.LastHit.useQ:Value() and
			self:GetManaPercent(myHero) > self.menu.LastHit.useQmana:Value() then
			CastQ(qMinion)
		end
	end
end

--_______________________________________________________________________________________________________________________________________________________________

--[[
 _______  _______  _______  _______  _______  _______  _______ 
(  ____ )(  ____ )(  ___  )(  ____ \(  ____ )(  ___  )(       )
| (    )|| (    )|| (   ) || (    \/| (    )|| (   ) || () () |
| (____)|| (____)|| |   | || |      | (____)|| (___) || || || |
|  _____)|     __)| |   | || | ____ |     __)|  ___  || |(_)| |
| (      | (\ (   | |   | || | \_  )| (\ (   | (   ) || |   | |
| )      | ) \ \__| (___) || (___) || ) \ \__| )   ( || )   ( |
|/       |/   \__/(_______)(_______)|/   \__/|/     \||/     \|
                                                              
]]--

class "Program"

function Program:OnLoad()

	if myHero.charName == "Annie" then
		PrintChat("Lazy Annie Loaded! Enjoy ;)")
		Annie:__init()
	else PrintChat("Champ not supported!") return end

	require("DamageLib")

	local orb = ""

	if _G.SDK then
		orb = "IC's Orbwalker"
	elseif _G.EOWLoaded then	
		orb = "Eternal Orbwalker"	
	elseif _G.GOS then
		orb = "Noddy's Orbwalker"
	else
		orb = "Orbwalker not found"		
	end

	PrintChat(orb.. " loaded!")
end

--_______________________________________________________________________________________________________________________________________________________________

--[[
 _______  _______  ______  
(  ___  )(  ____ )(  ___ \ 
| (   ) || (    )|| (   ) )
| |   | || (____)|| (__/ / 
| |   | ||     __)|  __ (  
| |   | || (\ (   | (  \ \ 
| (___) || ) \ \__| )___) )
(_______)|/   \__/|/ \___/ 

]]--


class "Orb"

function Orb:GetMode()

	self.combo, self.harass, self.lastHit, self.laneClear, self.jungleClear, self.canMove, self.canAttack = nil,nil,nil,nil,nil,nil,nil

		
	if _G.EOWLoaded then

		local mode = EOW:Mode()

		self.combo = mode == 1
		self.harass = mode == 2
	    self.lastHit = mode == 3
	    self.laneClear = mode == 4
	    self.jungleClear = mode == 4

		self.canmove = EOW:CanMove()
		self.canattack = EOW:CanAttack()
	elseif _G.SDK then

		self.combo = _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_COMBO]
		self.harass = _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_HARASS]
	   	self.lastHit = _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_LASTHIT]
	   	self.laneClear = _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_LANECLEAR]
	   	self.jungleClear = _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_JUNGLECLEAR]

		self.canmove = _G.SDK.Orbwalker:CanMove(myHero)
		self.canattack = _G.SDK.Orbwalker:CanAttack(myHero)
	elseif _G.GOS then

		local mode = GOS:GetMode()

		self.combo = mode == "Combo"
		self.harass = mode == "Harass"
	    self.lastHit = mode == "Lasthit"
	    self.laneClear = mode == "Clear"
	    self.jungleClear = mode == "Clear"

		self.canMove = GOS:CanMove()
		self.canAttack = GOS:CanAttack()	
	end
end

function Orb:Disable(bool)

	if _G.SDK then
		_G.SDK.Orbwalker:SetMovement(not bool)
		_G.SDK.Orbwalker:SetAttack(not bool)
	elseif _G.EOWLoaded then
		EOW:SetAttacks(not bool)
		EOW:SetMovements(not bool)
	elseif _G.GOS then
		GOS.BlockMovement = bool
		GOS.BlockAttack = bool
	end
end

function Orb:DisableAttacks(bool)

	if _G.SDK then
		_G.SDK.Orbwalker:SetAttack(not bool)
	elseif _G.EOWLoaded then
		EOW:SetAttacks(not bool)
	elseif _G.GOS then
		GOS.BlockAttack = bool
	end
end

function Orb:DisableMovement(bool)

	if _G.SDK then
		_G.SDK.Orbwalker:SetMovement(not bool)
	elseif _G.EOWLoaded then
		EOW:SetMovements(not bool)
	elseif _G.GOS then
		GOS.BlockMovement = bool
	end
end

--_______________________________________________________________________________________________________________________________________________________________