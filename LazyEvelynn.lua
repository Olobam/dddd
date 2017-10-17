class "LazyEvelynn"

Callback.Add("Load", function() LazyEvelynn:OnLoad() end)

function LazyEvelynn:OnLoad()

	require "DamageLib"

	self.Nudes = 	
	{ 	
		Hero = "https://i.imgur.com/yI88AJB.png",
		Q = "https://i.imgur.com/kTJJM2L.png",
		W = "https://i.imgur.com/IILMoXZ.png",
		E = "https://i.imgur.com/8kfl4WT.png",
		R = "https://i.imgur.com/Wgj9csG.png",
		Tear = "https://i.imgur.com/7sREK0V.png"
	}

	self:LoadMenu()
	self:LoadSpells()

	Callback.Add("Tick", function() self:OnTick() end)
	Callback.Add("Draw", function() self:OnDraw() end)
end

function LazyEvelynn:LoadSpells()

	self.Q = { range = 775, width = myHero:GetSpellData(_Q).width, delay = 0.25, speed = myHero:GetSpellData(_Q).speed }
    self.W = { range = 800, width = myHero:GetSpellData(_W).width, delay = 0.25, speed = myHero:GetSpellData(_W).speed }
    self.E = { range = 275, width = myHero:GetSpellData(_E).width, delay = 0.25, speed = myHero:GetSpellData(_E).speed }
    self.R = { range = 450, width = 100, delay = 0.25, speed = math.huge }
end

function LazyEvelynn:LoadMenu()

	self.menu = MenuElement({id = "menu", name = "Lazy Evelynn", type = MENU, leftIcon = self.Nudes.Hero })

	self.menu:MenuElement({id = "Combo", name = "Combo", type = MENU})
	self.menu:MenuElement({id = "Harass", name = "Harras", type = MENU})
	self.menu:MenuElement({id = "Clears", name = "Clear", type = MENU})
	--self.menu:MenuElement({id = "LastHit", name = "LastHit", type = MENU})
	--self.menu:MenuElement({id = "Misc", name = "Misc", type = MENU})
	self.menu:MenuElement({id = "Draw", name = "Drawings", type = MENU})
	self.menu:MenuElement({id = "Key", name = "Key Settings", type = MENU})

    -- Drawings
    self.menu.Draw:MenuElement({id = "drawQ", name = "Draw Q Range", value = true, leftIcon = self.Nudes.Q})
    self.menu.Draw:MenuElement({id = "drawW", name = "Draw W Range", value = true, leftIcon = self.Nudes.W})
    self.menu.Draw:MenuElement({id = "drawE", name = "Draw E Range", value = true, leftIcon = self.Nudes.E})
    self.menu.Draw:MenuElement({id = "drawR", name = "Draw R Range", value = true, leftIcon = self.Nudes.R})

	-- Keys
	self.menu.Key:MenuElement({id = "Combo", name = "Combo", key = string.byte(" ")})
	self.menu.Key:MenuElement({id = "Harass", name = "Harass", key = string.byte("C")})
	self.menu.Key:MenuElement({id = "Clear", name = "Lane/JungleClear", key = string.byte("V")})
	self.menu.Key:MenuElement({id = "LastHit", name = "LastHit", key = string.byte("X")})

	-- Combo
	self.menu.Combo:MenuElement({id = "useQ", name = "Use Q", value = true, leftIcon = self.Nudes.Q}) -- bool
	self.menu.Combo:MenuElement({id = "useW", name = "Use W", value = true, leftIcon = self.Nudes.W}) -- bool
	self.menu.Combo:MenuElement({id = "useE", name = "Use E", value = true, leftIcon = self.Nudes.E}) -- bool
	self.menu.Combo:MenuElement({id = "useR", name = "Use R", value = true, leftIcon = self.Nudes.R}) -- bool

	-- Harass
	self.menu.Harass:MenuElement({id = "useQ", name = "Use Q", value = true, leftIcon = self.Nudes.Q})
	self.menu.Harass:MenuElement({id = "useQmana", name = "Mana to use Q", value = 20, min = 0, max = 100, step = 1, leftIcon = self.Nudes.Tear}) -- slider
	self.menu.Harass:MenuElement({id = "useW", name = "Use W", value = true, leftIcon = self.Nudes.W})
	self.menu.Harass:MenuElement({id = "useWmana", name = "Mana to use W", value = 60, min = 0, max = 100, step = 1, leftIcon = self.Nudes.Tear}) -- slider
	self.menu.Harass:MenuElement({id = "useE", name = "Use E", value = true, leftIcon = self.Nudes.E})
	self.menu.Harass:MenuElement({id = "useEmana", name = "Mana to use E", value = 40, min = 0, max = 100, step = 1, leftIcon = self.Nudes.Tear}) -- slider

	-- Clear
	self.menu.Clears:MenuElement({id = "useQ", name = "Use Q", value = true, leftIcon = self.Nudes.Q})
	self.menu.Clears:MenuElement({id = "useQmana", name = "Mana to use Q", value = 60, min = 0, max = 100, step = 1, leftIcon = self.Nudes.Tear}) -- slider

	-- LastHit
	--self.menu.LastHit:MenuElement({id = "useQ", name = "Use Q", value = true, leftIcon = self.Nudes.Q})
	--self.menu.LastHit:MenuElement({id = "useQmana", name = "Mana to use Q", value = 60, min = 0, max = 100, step = 1, leftIcon = self.Nudes.Tear}) -- slider
end

function LazyEvelynn:GetTarget(range)

	if _G.EOWLoaded then
		return EOW:GetTarget(range, EOW.ap_dec, myHero.pos)
	elseif _G.SDK and _G.SDK.TargetSelector then
		return _G.SDK.TargetSelector:GetTarget(range, _G.SDK.DAMAGE_TYPE_MAGICAL)
	elseif _G.GOS then
		return GOS:GetTarget(range, "AP")
	end
end

function LazyEvelynn:IsReadyToCast(slot)
	return Game.CanUseSpell(slot) == 0
end

function LazyEvelynn:IsValid(range, unit)
	return unit:IsValidTarget(range, nil, myHero) and not unit.isImmortal and unit.health > 0 and not unit.dead and self:GetDistance(myHero.pos, unit.pos) <= range
end

function LazyEvelynn:GetDistanceSqr(p1, p2)
    local dx = p1.x - p2.x
    local dz = p1.z - p2.z
    return (dx * dx + dz * dz)
end

function LazyEvelynn:GetDistance(p1, p2)
    return math.sqrt(self:GetDistanceSqr(p1, p2))
end

function LazyEvelynn:GetDistance2D(p1,p2)
    return math.sqrt((p2.x - p1.x)*(p2.x - p1.x) + (p2.y - p1.y)*(p2.y - p1.y))
end

function LazyEvelynn:GetHpPercent(unit)
    return unit.health / unit.maxHealth * 100
end

function LazyEvelynn:GetManaPercent(unit)
	return unit.mana / unit.maxMana * 100
end

function LazyEvelynn:Rdmg(target)
    local rLevel = myHero:GetSpellData(_R).level
    if myHero.dead then return 0 end
	if self:IsReadyToCast(_R) then
		if rLevel == 1 then
			if self:GetHpPercent(self.target) > 30 then
    			return CalcMagicalDamage(myHero, self.target, (150 + (myHero.ap * 0.75)))
    		else
    			return CalcMagicalDamage(myHero, self.target, (150 + (myHero.ap * 0.75))) * 2
    		end
    	elseif rLevel == 2 then
    		if self:GetHpPercent(self.target) > 30 then
    			return CalcMagicalDamage(myHero, self.target, (275 + (myHero.ap * 0.75)))
    		else
    			return CalcMagicalDamage(myHero, self.target, (275 + (myHero.ap * 0.75))) * 2
    		end
    	elseif rLevel == 3 then
    		if self:GetHpPercent(self.target) > 30 then
    			return CalcMagicalDamage(myHero, self.target, (400 + (myHero.ap * 0.75)))
    		else
    			return CalcMagicalDamage(myHero, self.target, (400 + (myHero.ap * 0.75))) * 2
    		end
    	end
	end
	return 0
end

function LazyEvelynn:OnDraw()
	
	if myHero.dead then return end

	if self.menu.Draw.drawQ:Value() then
		local qColor
		local qCd = myHero:GetSpellData(_Q).currentCd
			if qCd > 0 then
				qColor = Draw.Color(255, 255, 0, 0)
			else qColor = Draw.Color(255, 0, 255, 0)
			end
		Draw.Circle(myHero.pos, self.Q.range, 1, qColor)
	end

	if self.menu.Draw.drawW:Value() then
		local wColor
		local wCd = myHero:GetSpellData(_W).currentCd
		local wName = myHero:GetSpellData(_W).name
			if wCd > 0 or wName ~= "EvelynnW" then
				wColor = Draw.Color(255, 255, 0, 0)
			else wColor = Draw.Color(255, 0, 255, 0)
			end
		Draw.Circle(myHero.pos, self.W.range, 1, wColor)
	end

	if self.menu.Draw.drawE:Value() then
		local eColor
		local eCd = myHero:GetSpellData(_E).currentCd
			if eCd > 0 then
				eColor = Draw.Color(255, 255, 0, 0)
				else eColor = Draw.Color(255, 0, 255, 0)
			end
		Draw.Circle(myHero.pos, self.E.range, 1, eColor)
	end

	if self.menu.Draw.drawR:Value() then
		local rColor
		local rCd = myHero:GetSpellData(_R).currentCd
			if rCd > 0 then
				rColor = Draw.Color(255, 255, 0, 0)
				else rColor = Draw.Color(255, 0, 255, 0)
			end
		Draw.Circle(myHero.pos, self.R.range, 1, rColor)
	end
end

function LazyEvelynn:OnTick()

	if myHero.dead then return end

	Orb:GetMode()

	self.target = self:GetTarget(800)

	if Orb.combo and self.target ~= nil then
		self:Combo(self.target)
	elseif Orb.harass and target ~= nil then
		self:Harass(target)
	elseif Orb.lastHit then
		--self:LastHit()
	elseif Orb.laneClear or Orb.jungleClear then
		self:Clear()
	end
end

local isQ1 = myHero:GetSpellData(_Q).name == "EvelynnQ"
local wName = myHero:GetSpellData(_W).name
local qAmmo = myHero:GetSpellData(_Q).ammo
local heroMana = myHero.mana

function LazyEvelynn:Combo(target)

	local wQmana = myHero:GetSpellData(_Q).mana + myHero:GetSpellData(_W).mana

	if self.target == nil then return end

    -- Q --
    if self:IsReadyToCast(_Q) and self:IsValid(self.Q.range, self.target) and self.menu.Combo.useQ:Value() then
		
		if isQ1 then
        	if self.target:GetCollision(self.Q.width, self.Q.speed, self.Q.delay) == 0 then
				Control.CastSpell(HK_Q, self.target.pos)
			elseif self:GetHpPercent(self.target) < 40 then
				Control.CastSpell(HK_Q, self.target.pos)
			return end
		elseif not isQ1 and qAmmo > 0 then
			Control.KeyDown(HK_Q)
			DelayAction(function()
				Control.KeyUp(HK_Q) end, 0.0420)
		end
	return end

	-- W --
	if self:IsReadyToCast(_W) and heroMana > wQmana and self:IsValid(self.W.range, self.target) and self.menu.Combo.useW:Value() and wName == "EvelynnW" then
		Control.CastSpell(HK_W, self.target)
	return end

	if self:IsReadyToCast(_E) and self:IsValid(self.E.range, self.target) and self.menu.Combo.useE:Value() then
		Control.CastSpell(HK_E, self.target)
	return end

	if self:IsReadyToCast(_R) and self:IsValid(self.R.range, self.target) and self.menu.Combo.useR:Value() then -- CastRangeDisplayOverride???
		if self:Rdmg(self.target) > self.target.health then
			Control.CastSpell(HK_R, self.target)
		end
	end
end

function LazyEvelynn:Harass(target)

	local wQmana = myHero:GetSpellData(_Q).mana + myHero:GetSpellData(_W).mana

	if self.target == nil then return end

    -- Q --
 	if self:IsReadyToCast(_Q) and self:IsValid(self.Q.range, self.target) then
		local qAmmo = myHero:GetSpellData(_Q).ammo
		if isQ1 then
        	if self.target:GetCollision(self.Q.width, self.Q.speed, self.Q.delay) == 0 then
				Control.CastSpell(HK_Q, self.target.pos)
			elseif self:GetHpPercent(self.target) < 40 then
				Control.CastSpell(HK_Q, self.target.pos)
			return end
		elseif not isQ1 and qAmmo > 0 then
			Control.KeyDown(HK_Q)
			DelayAction(function()
				Control.KeyUp(HK_Q) end, 0.0420)	
		end
	return end

	-- W --
	if self:IsReadyToCast(_W) and heroMana > wQmana and self:IsValid(self.W.range, self.target) and wName == "EvelynnW" and
 		self.menu.Harass.useW:Value() and self:GetManaPercent(myHero) > self.menu.Harass.useWmana:Value() then
		Control.CastSpell(HK_W, self.target)
	return end

	if self:IsReadyToCast(_E) and self:IsValid(self.E.range, self.target) and
 		self.menu.Harass.useE:Value() and self:GetManaPercent(myHero) > self.menu.Harass.useEmana:Value() then
		Control.CastSpell(HK_E, self.target)
	end
end

function LazyEvelynn:Clear()

	local qMinion

	if Game.MinionCount() > 0 then
		for i = 0, Game.MinionCount() do

			local m = Game.Minion(i)
			if m and m.isEnemy and m.valid and not m.dead then
				if self:GetDistance2D(myHero.pos:To2D(), m.pos:To2D()) < self.Q.range then
					qMinion = m
					break
				end
			end
		end
	end

	if qMinion ~= nil and self:IsReadyToCast(_Q) and self.menu.Clears.useQ:Value() and
			self:GetManaPercent(myHero) > self.menu.Clears.useQmana:Value() then
		if isQ1 then
			Control.CastSpell(HK_Q, qMinion.pos)
		return end
		if qAmmo > 0 then
			Control.KeyDown(HK_Q)
			Control.KeyUp(HK_Q)
		end
	end
end

--------------------------------------------------------------------------------------------------------------------------------------------------

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

