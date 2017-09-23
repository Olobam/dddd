
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

class "Spell"

function Spell:IsReadyToCast(slot)
	return Game.CanUseSpell(slot) == 0
end

function Spell:CastQ(unit)

	if unit ~= nil then

		if Spell:IsReadyToCast(_Q) then
			if myHero.pos:DistanceTo(unit.pos) <= Annie.Q.range + unit.boundingRadius + myHero.boundingRadius then
				Orb:DisableAttacks(true)
				if myHero.pos:DistanceTo(unit.pos) <= Annie.Q.range then
					Orb:Disable(true)
					Control.SetCursorPos(unit.pos)
					Control.KeyDown(HK_Q)
					Control.KeyUp(HK_Q)
					DelayAction(function() Orb:Disable(false) end, 0.25)
				end
			end
		end	
	end
end

function Spell:CastW(unit)

	if unit ~= nil then

		local wPred = unit:GetPrediction(Annie.W.speed, Annie.W.delay)

		if Spell:IsReadyToCast(_W) then 
			if myHero.pos:DistanceTo(wPred) < Annie.W.range then
				Orb:Disable(true)
				Control.SetCursorPos(wPred)
				Control.KeyDown(HK_W)
				Control.KeyUp(HK_W)
				DelayAction(function() Orb:Disable(false) end, 0.25)
			end
		end
	end
end

function Spell:CastR(unit)

	if unit ~= nil and myHero:GetSpellData(_R).name == "InfernalGuardian" then

		local rPred = unit:GetPrediction(Annie.R.speed, Annie.R.delay)

		if Spell:IsReadyToCast(_R) then 
			if myHero.pos:DistanceTo(rPred) < Annie.R.range + 125 then
				Orb:Disable(true)
				Control.SetCursorPos(rPred)
				Control.KeyDown(HK_R)
				Control.KeyUp(HK_R)
				DelayAction(function() Orb:Disable(false) end, 0.25)
			end
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

function Annie:Qdmg(unit)

	local qSpellData = myHero:GetSpellData(_Q)

	if myHero.mana >= qSpellData.mana and qSpellData.level > 0 then 
		return getdmg("Q", unit, myHero)
	else return 0 end
end

function Annie:Wdmg(unit)

	local wSpellData = myHero:GetSpellData(_W)

	if myHero.mana >= wSpellData.mana and wSpellData.level > 0 then 
		return getdmg("W", unit, myHero)
	else return 0 end
end

function Annie:Rdmg(unit)

	local rSpellData = myHero:GetSpellData(_R)

	if Spell:IsReadyToCast(_R) then
		return getdmg("R", unit, myHero)
	else return 0 end		
end

function Annie:QWdmg(unit)

	local qSpellData = myHero:GetSpellData(_Q)
	local wSpellData = myHero:GetSpellData(_W)

	if myHero.mana >= qSpellData.mana + wSpellData.mana and
		qSpellData.level > 0 and wSpellData.level > 0 then
		return getdmg("Q", unit, myHero) + getdmg("W", unit, myHero)
	else return 0 end
end

function Annie:QRdmg(unit)

	local qSpellData = myHero:GetSpellData(_Q)
	local rSpellData = myHero:GetSpellData(_R)

	if myHero.mana >= qSpellData.mana + rSpellData.mana and
		qSpellData.level > 0 and Spell:IsReadyToCast(_R) then
		return getdmg("Q", unit, myHero) + getdmg("R", unit, myHero)
	else return 0 end
end

function Annie:QWRdmg(unit)

	local qSpellData = myHero:GetSpellData(_Q)
	local wSpellData = myHero:GetSpellData(_W)
	local rSpellData = myHero:GetSpellData(_R)

	if myHero.mana >= qSpellData.mana + wSpellData.mana + rSpellData.mana and
		qSpellData.level > 0 and wSpellData.level > 0 and Spell:IsReadyToCast(_R) then
		return getdmg("Q", unit, myHero) + getdmg("W", unit, myHero) + getdmg("R", unit, myHero)
	else return 0 end
end

function Annie:GetManaPercent(unit)
	return unit.mana / unit.maxMana * 100
end

function Annie:GetTarget(range)

	if _G.EOWLoaded then
		return _G.EOW:GetTarget(range, _G.EOW.ap_dec, myHero.pos)
	elseif _G.SDK.Orbwalker then
		return _G.SDK.TargetSelector:GetTarget(range, _G.SDK.DAMAGE_TYPE_MAGICAL)
	elseif _G.GOS then
		return _G.GOS:GetTarget(range, "AP")
	end
end

function Annie:__init()

	self.Nudes = 	
	{ 	
		Hero = "https://i.imgur.com/dxui3s2.png",
		Passive = "https://i.imgur.com/f4p3IjG.png",
		Q = "https://i.imgur.com/HUj9ZuK.png",
		W = "https://i.imgur.com/AXcQ7Z4.png",
		E = "https://i.imgur.com/d2ZsLKd.png",
		R = "https://i.imgur.com/blVeTd5.png",
		Tear = "https://i.imgur.com/7sREK0V.png"
	}

	self:LoadMenu()
	self:LoadSpells()

	Callback.Add("Tick", function() self:OnTick() end)
	Callback.Add("Draw", function() self:OnDraw() end)
end

function Annie:LoadSpells()
	self.Q = { range = myHero:GetSpellData(_Q).range }
    self.W = { range = myHero:GetSpellData(_W).range, width = myHero:GetSpellData(_W).width, delay = 0.25, angle = myHero:GetSpellData(_W).coneAngle,  speed = 0 } -- Maybe soonTM Kappa
    self.R = { range = myHero:GetSpellData(_R).range, width = myHero:GetSpellData(_R).width, delay = 0.25 , speed = 0 }
end

function Annie:LoadMenu()

	self.menu = MenuElement({id = "menu", name = "Lazy Annie", type = MENU, leftIcon = self.Nudes.Hero })

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

	Orb:GetMode()

	if Orb.combo then
		self:Combo()
	elseif Orb.harass then
		self:Harass()
	elseif Orb.lastHit then
		self:LastHit()
	elseif Orb.laneClear or Orb.jungleClear then
		self:LaneClear()
		self:JungleClear()		
	end

	if self.menu.Misc.stack:Value() then
		self:AutoStack()
	end
end

function Annie:OnDraw()

	local heroPos2D = myHero.pos:To2D()

	if self.menu.Misc.stack:Value() then
		Draw.Text("Stacking ENABLED", 10, heroPos2D.x - 40, heroPos2D.y + 80, Draw.Color(255, 222, 000, 022)) -- Not even random
	end
end

function Annie:AutoStack()

	local fountain = Obj_AI_SpawnPoint

	if Spell:IsReadyToCast(_W) then

		if myHero.pos:DistanceTo(fountain) <= 900 and myHero.hudAmmo ~= myHero.hudMaxAmmo then
			Control.KeyDown(HK_W)
			Control.KeyUp(HK_W)
		end
	end

	if Spell:IsReadyToCast(_E) then 
		
		if myHero.hudAmmo ~= myHero.hudMaxAmmo then
			Control.KeyDown(HK_E)
			Control.KeyUp(HK_E)
		end
	end
end

function Annie:Combo()

	-- Q --
	if self.menu.Combo.useQ:Value() and Spell:IsReadyToCast(_Q) then
		local target = self:GetTarget(self.Q.range + 100)

		if target ~= nil then
			Spell:CastQ(target)	return
		end
	end

	-- W --
	if self.menu.Combo.useW:Value() and Spell:IsReadyToCast(_W) then
		local target = self:GetTarget(self.W.range)

		if target ~= nil then
			Spell:CastW(target) return
		end
	end

	-- R --
	if self.menu.Combo.useR:Value() and Spell:IsReadyToCast(_R) then
		local target = self:GetTarget(725) 

		if target ~= nil then

			if target.health <= self:Rdmg(target) and myHero.pos:DistanceTo(target.pos) < self.R.range then
				Spell:CastR(target)
			elseif target.health <= self:QRdmg(target) and myHero.pos:DistanceTo(target.pos) < self.Q.range then
				Spell:CastR(target)
			elseif target.health <= self:QWRdmg(target) and myHero.pos:DistanceTo(target.pos) < self.W.range then
				Spell:CastR(target)
			end
		end
	end
end

function Annie:Harass()

	-- Q --
	if self.menu.Harass.useQ:Value() and Spell:IsReadyToCast(_Q) and self:GetManaPercent(myHero) > self.menu.Harass.useQmana:Value() then
		local target = self:GetTarget(self.Q.range + 100)

		if target ~= nil then
			Spell:CastQ(target) return
		end
	end

	-- W --
	if self.menu.Harass.useW:Value() and Spell:IsReadyToCast(_W) and self:GetManaPercent(myHero) > self.menu.Harass.useWmana:Value() then
		local target = self:GetTarget(self.W.range)

		if target ~= nil then
			Spell:CastW(target)
		end
	end
end

function Annie:LaneClear()

	local qMinion
	
	if Game.MinionCount() > 0 then
		for i = 0, Game.MinionCount() do

			local m = Game.Minion(i)
			if m and m.isEnemy and m.valid and not m.dead and m.health < self:Qdmg(m) and myHero.pos:DistanceTo(m.pos) < self.Q.range then
				qMinion = m
				break
			end
		end
	end

	if qMinion ~= nil then
		if Spell:IsReadyToCast(_Q) and self.menu.LaneClear.useQ:Value() and
			self:GetManaPercent(myHero) > self.menu.LaneClear.useQmana:Value() then
			Spell:CastQ(qMinion)
		end
	end
end

function Annie:LastHit()

	local qMinion
	
	if Game.MinionCount() > 0 then
		for i = 0, Game.MinionCount() do

			local m = Game.Minion(i)
			if m and m.isEnemy and m.valid and not m.dead and m.health < self:Qdmg(m) and myHero.pos:DistanceTo(m.pos) < self.Q.range then
				qMinion = m
				break
			end
		end
	end

	if qMinion ~= nil then
		if Spell:IsReadyToCast(_Q) and self.menu.LastHit.useQ:Value() and
			self:GetManaPercent(myHero) > self.menu.LastHit.useQmana:Value() then
			Spell:CastQ(qMinion)
		end
	end
end

function Annie:JungleClear()

	local mob
	
	if Game.CampCount() > 0 then
		for i = 0, Game.CampCount() do

			local m = Game.Camp(i)
			if m and m.isEnemy and m.valid and not m.dead and myHero.pos:DistanceTo(m.pos) < self.Q.range then
				mob = m
				break
			end
		end
	end

	if mob ~= nil then
		if Spell:IsReadyToCast(_Q) and self.menu.JungleClear.useQ:Value() and 
			self:GetManaPercent(myHero) > self.menu.JungleClear.useQmana:Value() then
			Spell:CastQ(mob) return
		end

		if Spell:IsReadyToCast(_W) and self.menu.JungleClear.useW:Value() and 
			self:GetManaPercent(myHero) > self.menu.JungleClear.useWmana:Value() then
			Spell:CastW(mob)
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

	if _G.SDK.Orbwalker then
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

		self.combo = _G.EOW:Mode() == 1
		self.harass = _G.EOW:Mode() == 2
	    self.lastHit = _G.EOW:Mode() == 3
	    self.laneClear = _G.EOW:Mode() == 4
	    self.jungleClear = _G.EOW:Mode() == 4

		self.canmove = _G.EOW:CanMove()
		self.canattack = _G.EOW:CanAttack()
	elseif _G.SDK.Orbwalker then

		self.combo = _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_COMBO]
		self.harass = _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_HARASS]
	   	self.lastHit = _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_LASTHIT]
	   	self.laneClear = _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_LANECLEAR]
	   	self.jungleClear = _G.SDK.Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_JUNGLECLEAR]

		self.canmove = _G.SDK.Orbwalker:CanMove(myHero)
		self.canattack = _G.SDK.Orbwalker:CanAttack(myHero)
	elseif _G.GOS then

		self.combo = _G.GOS:GetMode() == "Combo"
		self.harass = _G.GOS:GetMode() == "Harass"
	    self.lastHit = _G.GOS:GetMode() == "Lasthit"
	    self.laneClear = _G.GOS:GetMode() == "Clear"
	    self.jungleClear = _G.GOS:GetMode() == "Clear"

		self.canMove = _G.GOS:CanMove()
		self.canAttack = _G.GOS:CanAttack()	
	end
end

function Orb:Disable(bool)

	if _G.SDK.Orbwalker then
		_G.SDK.Orbwalker:SetMovement(not bool)
		_G.SDK.Orbwalker:SetAttack(not bool)
	elseif _G.EOWLoaded then
		_G.EOW:SetAttacks(not bool)
		_G.EOW:SetMovements(not bool)
	elseif _G.GOS then
		_G.GOS.BlockMovement = bool
		_G.GOS.BlockAttack = bool
	end
end

function Orb:DisableAttacks(bool)

	if _G.SDK.Orbwalker then
		_G.SDK.Orbwalker:SetAttack(not bool)
	elseif _G.EOWLoaded then
		_G.EOW:SetAttacks(not bool)
	elseif _G.GOS then
		_G.GOS.BlockAttack = bool
	end
end

function Orb:DisableMovement(bool)

	if _G.SDK.Orbwalker then
		_G.SDK.Orbwalker:SetMovement(not bool)
	elseif _G.EOWLoaded then
		_G.EOW:SetMovements(not bool)
	elseif _G.GOS then
		_G.GOS.BlockMovement = bool
	end
end

--_______________________________________________________________________________________________________________________________________________________________