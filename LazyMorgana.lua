class "LazyMorgana"

Callback.Add("Load", function() LazyMorgana:OnLoad() end)

function LazyMorgana:init()

    self:LoadSpells()
    self:LoadMenu()

    Callback.Add("Draw", function() self:Draw() end)
    Callback.Add("Tick", function() self:OnTick() end)
end

function LazyMorgana:LoadMenu()

	self.Menu = MenuElement({type = MENU, id = "LazyMorgana", name = "Lazy Morgana", leftIcon = "https://i.imgur.com/gMfL41n.png"})
	self.Menu:MenuElement({type = MENU, id = "Combo", name = "Combo Settings"})
	self.Menu.Combo:MenuElement({id = "qHotkey", name = "Q Hotkey | Wait for Spell", key = string.byte("T"), toggle = true, value = false})
	self.Menu.Combo:MenuElement({id = "UseQ", name = "Use Q", value = true})
	self.Menu.Combo:MenuElement({id = "UseW", name = "Use W", value = true})
	self.Menu.Combo:MenuElement({id = "UseE", name = "Use E", value = true})
	self.Menu.Combo:MenuElement({id = "UseR", name = "Use R if #Enemies", value = 2, min = 1, max = 6, step = 1, tooltip = "set to 6 to disable"})

	self.Menu:MenuElement({type = MENU, id = "Draw", name = "Draw Settings"})
	self.Menu.Draw:MenuElement({id = "DrawQ", name = "Q Range", value = true})
	self.Menu.Draw:MenuElement({id = "DrawW", name = "W Range", value = true})
	self.Menu.Draw:MenuElement({id = "DrawE", name = "E Range", value = true})
	self.Menu.Draw:MenuElement({id = "DrawR", name = "R Range", value = true})
	
end

function LazyMorgana:LoadSpells()

	self.Q = {range = 1150, delay = 0.25, speed = myHero:GetSpellData(_Q).speed, width = myHero:GetSpellData(_Q).width}
	self.W = {range = 900, delay = 0, width = myHero:GetSpellData(_W).width, speed = math.huge}
	self.E = {range = 800}
	self.R = {range = 625}
end

-------------------------------- Thnx Noddy ;) -----------------------------------

function LazyMorgana:GetEnemyHeroes()

	local _EnemyHeroes = {}	
  	if _EnemyHeroes then return _EnemyHeroes end

  	for i = 1, Game.HeroCount() do
    	local unit = Game.Hero(i)
    	if unit and unit.isEnemy and unit.team ~= 300 then
	  		if _EnemyHeroes == nil then
	  			table.insert(_EnemyHeroes, unit)
    		end
  		end
  	end
  	return _EnemyHeroes
end

function LazyMorgana:OnVision(unit)

	local _OnVision = {}
	if _OnVision[unit.networkID] == nil then _OnVision[unit.networkID] = {state = unit.visible , tick = GetTickCount(), pos = unit.pos} end
	if _OnVision[unit.networkID].state == true and not unit.visible then _OnVision[unit.networkID].state = false _OnVision[unit.networkID].tick = GetTickCount() end
	if _OnVision[unit.networkID].state == false and unit.visible then _OnVision[unit.networkID].state = true _OnVision[unit.networkID].tick = GetTickCount() end
	return _OnVision[unit.networkID]
end

function LazyMorgana:OnVisionF()

	local visionTick = GetTickCount()
	if GetTickCount() - visionTick > 100 then
		for k, v in pairs(self:GetEnemyHeroes()) do
			self:OnVision(v)
		end
	end
end

function LazyMorgana:OnWaypoint(unit)

	local _OnWaypoint = {}
	if _OnWaypoint[unit.networkID] == nil then _OnWaypoint[unit.networkID] = {pos = unit.posTo , speed = unit.ms, time = Game.Timer()} end
	if _OnWaypoint[unit.networkID].pos ~= unit.posTo then 
		_OnWaypoint[unit.networkID] = {startPos = unit.pos, pos = unit.posTo , speed = unit.ms, time = Game.Timer()}
			DelayAction(function()
				local time = (Game.Timer() - _OnWaypoint[unit.networkID].time)
				local speed = self:GetDistance2D(_OnWaypoint[unit.networkID].startPos,unit.pos)/(Game.Timer() - _OnWaypoint[unit.networkID].time)
				if speed > 1250 and time > 0 and unit.posTo == _OnWaypoint[unit.networkID].pos and self:GetDistance(unit.pos,_OnWaypoint[unit.networkID].pos) > 200 then
					_OnWaypoint[unit.networkID].speed = self:GetDistance2D(_OnWaypoint[unit.networkID].startPos,unit.pos)/(Game.Timer() - _OnWaypoint[unit.networkID].time)
				end
			end,0.05)
	end
	return _OnWaypoint[unit.networkID]
end

function LazyMorgana:GetPred(unit,speed,delay,sourcePos)

	local speed = speed or math.huge
	local delay = delay or 0.25
	local sourcePos = sourcePos or myHero.pos
	local unitSpeed = unit.ms

	if self:OnWaypoint(unit).speed > unitSpeed then unitSpeed = self:OnWaypoint(unit).speed end

	if self:OnVision(unit).state == false then
		local unitPos = unit.pos + Vector(unit.pos,unit.posTo):Normalized() * ((GetTickCount() - self:OnVision(unit).tick)/1000 * unitSpeed)
		local predPos = unitPos + Vector(unit.pos,unit.posTo):Normalized() * (unitSpeed * (delay + (self:GetDistance(sourcePos,unitPos)/speed)))
		if self:GetDistance(unit.pos,predPos) > self:GetDistance(unit.pos,unit.posTo) then predPos = unit.posTo end
		return predPos
	else
		if unitSpeed > unit.ms then
			local predPos = unit.pos + Vector(self:OnWaypoint(unit).startPos,unit.posTo):Normalized() * (unitSpeed * (delay + (self:GetDistance(sourcePos,unit.pos)/speed)))
			if self:GetDistance(unit.pos,predPos) > self:GetDistance(unit.pos,unit.posTo) then predPos = unit.posTo end
			return predPos
		elseif self:IsImmobile(unit) then
			return unit.pos
		else
			return unit:GetPrediction(speed,delay)
		end
	end
end

-------------------------------- Thnx Noddy ;) -----------------------------------

function LazyMorgana:GetEnemiesInRange(range)

	local enemyTable = {}
	for i = 1, Game.HeroCount() do
		local enemy = Game.Hero(i)
		if enemy and enemy.isEnemy and not enemy.dead and self:GetDistance(enemy.pos, myHero.pos) <= range and enemy:IsValidTarget(self.R.Range, nil, myHero) then
			table.insert(enemyTable, enemy)
		end
	end
	return enemyTable
end

function LazyMorgana:CanUseSpell(spell)

	return myHero:GetSpellData(spell).currentCd == 0 and myHero:GetSpellData(spell).level > 0 and myHero:GetSpellData(spell).mana <= myHero.mana
end

local items = { [ITEM_1] = HK_ITEM_1, [ITEM_2] = HK_ITEM_2, [ITEM_3] = HK_ITEM_3, [ITEM_4] = HK_ITEM_4, [ITEM_5] = HK_ITEM_5, [ITEM_6] = HK_ITEM_6 }

function LazyMorgana:GetInventoryItem(itemID)

	for k, v in pairs({ ITEM_1, ITEM_2, ITEM_3, ITEM_4, ITEM_5, ITEM_6 }) do
		if myHero:GetItemData(v).itemID == itemID and myHero:GetSpellData(v).currentCd == 0 then return v end
	end
	return nil
end

function LazyMorgana:GetTarget(range)

	if _G.EOWLoaded then
		return EOW:GetTarget(range, EOW.ap_dec, myHero.pos)
	elseif _G.SDK and _G.SDK.TargetSelector then
		return _G.SDK.TargetSelector:GetTarget(range, _G.SDK.DAMAGE_TYPE_MAGICAL)
	elseif _G.GOS then
		return GOS:GetTarget(range, "AP")
	end
end

function LazyMorgana:IsImmobile(unit)

	for i = 1, unit.buffCount do
		local buff = unit:GetBuff(i)
		if buff and (buff.type == 5 or buff.type == 11 or buff.type == 29 or buff.type == 24 or buff.name == "recall") and buff.count > 0 then
			return true
		end
	end
	return false	
end

function LazyMorgana:Ulting()

	if myHero.isChanneling then
		local check = myHero.activeSpell.valid and myHero.activeSpellSlot == _R
		if check then
			return true
		end
	end
	return false 
end

function LazyMorgana:LazyZhonyas()

	local zhonyas = self:GetInventoryItem(3157)
	if self:Ulting() and zhonyas then
		Control.CastSpell(items[zhonyas])
	end		
end

function LazyMorgana:IsReady(spell)

	return Game.CanUseSpell(spell) == 0 
end

function LazyMorgana:GetDistanceSqr(p1, p2)
    local dx = p1.x - p2.x
    local dz = p1.z - p2.z
    return (dx * dx + dz * dz)
end

function LazyMorgana:GetDistance(p1, p2)

    return math.sqrt(self:GetDistanceSqr(p1, p2))
end

function LazyMorgana:GetDistance2D(p1,p2)

    return math.sqrt((p2.x - p1.x)*(p2.x - p1.x) + (p2.y - p1.y)*(p2.y - p1.y))
end

function LazyMorgana:CastQ()

	local target = self:GetTarget(self.Q.range)

	if not target or not target:IsValidTarget(self.Q.range, nil, myHero) then return end

	local pred = self:GetPred(target, self.Q.speed, self.Q.delay)

	if not pred then return end

	if target:GetCollision(self.Q.width, self.Q.speed, self.Q.delay) == 0 then
		if target.activeSpell.windup > 0.1 and self.Menu.Combo.qHotkey:Value()  then
			Control.CastSpell(HK_Q, pred)
		elseif self.Menu.Combo.qHotkey:Value() ~= true then
			Control.CastSpell(HK_Q, pred)
		end
	end
end

function LazyMorgana:CastW()

	local target = self:GetTarget(self.W.range)
	if not target or not target:IsValidTarget(self.W.Range, nil, myHero) then return end

	if self:IsImmobile(target) then
		Control.CastSpell(HK_W, target.pos)
		self.tickAction = true
	end
end

function LazyMorgana:CastE()

	for i = 1, Game.HeroCount() do
		local hero = Game.Hero(i)
		if hero and hero.isEnemy and hero.activeSpell.valid and hero.isChanneling then

			local activeSpell = hero.activeSpell
			local spellPos = Vector(activeSpell.placementPos.x, activeSpell.placementPos.y, activeSpell.placementPos.z)
			for i = 1, Game.HeroCount() do

    			local ally = Game.Hero(i)
    			if ally and ally.isAlly and ally:IsValidTarget(self.E.Range, nil, myHero) then
	  				if (self:GetDistance(ally.pos, spellPos) < activeSpell.width + (ally.boundingRadius * 1.5)) or activeSpell.target == ally.handle then
	  					Control.CastSpell(HK_E, ally.pos)
						self.tickAction = true
    				end
  				end
  			end
		end
	end
end

function LazyMorgana:CastR()

	if #self:GetEnemiesInRange(self.R.range) >= self.Menu.Combo.UseR:Value() then
		Control.CastSpell(HK_R)
	end
end

function LazyMorgana:Draw()
	
	local text2d = myHero.pos:To2D()
	if self.Menu.Combo.qHotkey:Value() then
		Draw.Text("Korean Q", text2d.x - 20, text2d.y + 50)
	end
	if self.Menu.Draw.DrawQ:Value() then
		Draw.Circle(myHero.pos, self.Q.range, 1, Draw.Color(255, 255, 255, 255))
	end
	if self.Menu.Draw.DrawW:Value() then
		Draw.Circle(myHero.pos, self.W.range, 1, Draw.Color(255, 255, 255, 255))
	end
	if self.Menu.Draw.DrawE:Value() then
		Draw.Circle(myHero.pos, self.E.range, 1, Draw.Color(255, 255, 255, 255))
	end
	if self.Menu.Draw.DrawR:Value() then
		Draw.Circle(myHero.pos, self.R.range, 1, Draw.Color(255, 255, 255, 255))
	end
end

function LazyMorgana:OnLoad()

	self:init()
end

function LazyMorgana:OnTick()
	
	if myHero.dead then return end

	self.tickAction = nil

	if self.tickAction then self.tickAction = false return end

	self:LazyZhonyas()

	if self:IsReady(_E) and self.Menu.Combo.UseE:Value() then
		self:CastE()
	end
		
	self:GetOrbMode()

	if self.combo then
		if self:IsReady(_Q) and self.Menu.Combo.UseQ:Value() then
			self:CastQ()
		end	
		if self:IsReady(_W) and self.Menu.Combo.UseW:Value() then
			self:CastW()
		end
		if self:IsReady(_R) and self.Menu.Combo.UseR:Value() then
			self:CastR()
		end
	end
end

function LazyMorgana:GetOrbMode()

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
