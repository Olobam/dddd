class "KoreanMorgana"

Callback.Add("Load", function() KoreanMorgana:OnLoad() end)

function KoreanMorgana:init()
	

    self.spellNames = {
    		{name = "Q", buffName = ""},
    		{name = "R", buffName = "soulshackles"},
    		{name = "RStunned", buffName = "soulshacklesstunsound"}
	}

    self:LoadSpells()
    self:LoadMenu()
    Callback.Add("Draw", function() self:Draw() end)
    Callback.Add("Tick", function() self:OnTick() end)

    self.predictionModified = {champion = "Ezreal", dodger = false}
    self.misscount = 0
    self.lastPath = 0
    self.ShootDelay = {}

	self.dashAboutToHappend =
	{
		{name = "ezrealarcaneshift", duration = 0.25},
		{name = "deceive", duration = 0.25}, 
		{name = "riftwalk", duration = 0.25},
		{name = "gate", duration = 1.5},
		{name = "katarinae", duration = 0.25},
		{name = "elisespideredescent", duration = 0.25},
		{name = "elisespidere", duration = 0.25},
		{name = "ahritumble", duration = 0.25},
		{name = "akalishadowdance", duration = 0.25},
		{name = "headbutt", duration = 0.25},
		{name = "caitlynentrapment", duration = 0.25},
		{name = "carpetbomb", duration = 0.25},
		{name = "dianateleport", duration = 0.25},
		{name = "fizzpiercingstrike", duration = 0.25},
		{name = "fizzjump", duration = 0.25},
		{name = "gragasbodyslam", duration = 0.25},
		{name = "gravesmove", duration = 0.25},
		{name = "ireliagatotsu", duration = 0.25},
		{name = "jarvanivdragonstrike", duration = 0.25},
		{name = "jaxleapstrike", duration = 0.25},
		{name = "khazixe", duration = 0.25},
		{name = "leblancslide", duration = 0.25},
		{name = "leblancslidem", duration = 0.25},
		{name = "blindmonkqtwo", duration = 0.25}, 
		{name = "blindmonkwone", duration = 0.25},
		{name = "luciane", duration = 0.25},
		{name = "maokaiunstablegrowth", duration = 0.25},
		{name = "nocturneparanoia2", duration = 0.25},
		{name = "pantheon_leapbash", duration = 0.25},
		{name = "renektonsliceanddice", duration = 0.25},
		{name = "riventricleave", duration = 0.25},
		{name = "rivenfeint", duration = 0.25},
		{name = "sejuaniarcticassault", duration = 0.25},
		{name = "shenshadowdash", duration = 0.25},
		{name = "shyvanatransformcast", duration = 0.25},
		{name = "rocketjump", duration = 0.25},
		{name = "slashcast", duration = 0.25},
		{name = "vaynetumble", duration = 0.25},
		{name = "viq", duration = 0.25},
		{name = "monkeykingnimbus", duration = 0.25},
		{name = "xenzhaosweep", duration = 0.25},
		{name = "yasuodashwrapper", duration = 0.25},

	}
end

function KoreanMorgana:LoadMenu()
	self.Menu = MenuElement({type = MENU, id = "KoreanMorgana", name = "Korean Morgana", leftIcon = "http://i.imgur.com/B1yTPrK.png"})
	self.Menu:MenuElement({type = MENU, id = "Combo", name = "Korean Morgana - Combo Settings"})
	self.Menu.Combo:MenuElement({id = "HotKeyChanger", name = "Q Hotkey Changer | Wait for AA or Spell", key = 0x5a, toggle = true, value = false})
	self.Menu.Combo:MenuElement({id = "ComboQ", name = "Use Q", value = true})
	self.Menu.Combo:MenuElement({id = "ComboW", name = "Use W", value = true})
	self.Menu.Combo:MenuElement({id = "ComboE", name = "Use E", value = true})
	self.Menu:MenuElement({type = MENU, id = "Prediction", name = "Korean Morgana - xPrediction Settings"})
	self.Menu.Prediction:MenuElement({id = "Am", name = "Prediction Range", value = 80, min = 20, max = 200})
	self.Menu:MenuElement({type = MENU, id = "Harass", name = "Korean Morgana - Harass Settings"})
	self.Menu.Harass:MenuElement({id = "CS", name = "Comming Soon.", value = true})
	self.Menu:MenuElement({type = MENU, id = "Draw", name = "Korean Morgana - Draw Settings"})
	self.Menu.Draw:MenuElement({id = "DrawQ", name = "Q Range", value = true})
	self.Menu.Draw:MenuElement({id = "DrawW", name = "W Range", value = true})
	self.Menu.Draw:MenuElement({id = "DrawE", name = "E Range", value = true})
	self.Menu.Draw:MenuElement({id = "DrawR", name = "R Range", value = true})
	
end

function KoreanMorgana:LoadSpells()
	self.Q = {range = 850, delay = 0.25, radius = 235, speed = myHero:GetSpellData(_Q).speed, width = myHero:GetSpellData(_Q).width}
	self.W = {range = 900, delay = 0, radius = 275, speed = math.huge}
	self.E = {range = 800, delay = 0, radius = 0, speed = math.huge}
	self.R = {range = 625, delay = 0, radius = myHero:GetSpellData(_R).radius, speed = math.huge}
end

function KoreanMorgana:xPath(unit)
	local hero = unit
	local path = hero.pathing
	local path_vec
	

		if path.hasMovePath then
			for i = path.pathIndex, path.pathCount do
				path_vec = hero:GetPath(i)
				
			end
		end
		
		return path_vec
end

function KoreanMorgana:CanUseSpell(spell)
	return myHero:GetSpellData(spell).currentCd == 0 and myHero:GetSpellData(spell).level > 0 and myHero:GetSpellData(spell).mana <= myHero.mana
end

function KoreanMorgana:Buffs(unit, buffname)

	local textPos2 = unit.pos:To2D()
	textOffset = 50

	local activeBuffs = {}

	for i = 0, unit.buffCount do
		local Buff = unit:GetBuff(i)
		if Buff.count > 0 then
			table.insert(activeBuffs, Buff)
		end
	end
	for i, Buff in pairs(activeBuffs) do
		if Buff.name:lower() == buffname:lower() then
			return true
		end
	end
	return false
end

local timer = {start = 0, tick = GetTickCount()} 
function KoreanMorgana:Timer(mindelay, maxdelay)
	local ticker = GetTickCount()
	if timer.start == 0 then
		timer.start = 1
		timer.tick = ticker
	end

	if timer.start == 1 then
		if ticker - timer.tick > mindelay and ticker - timer.tick < maxdelay then
			timer.start = 0
			return true
		end
	end

	return false

end

function  KoreanMorgana:Check(target)
	if self:Buffs(target, "darkbindingmissle") == false then 
		if self.predictionModified.dodger == false then
			self.predictionModified.dodger = true 
			self.misscount = self.misscount + 1
		elseif self.predictionModified.dodger == true then
			self.predictionModified.dodger = false

		end
	end
end

function KoreanMorgana:Prediction(unit)

	local target = unit

	local pathingVector = self:xPath(target)
	local distanceToTarget = myHero.pos:DistanceTo(target.pos)
	local predictionVector
	if self.predictionModified.dodger == false then
		predictionVector = target.pos:Extended(pathingVector, (distanceToTarget / 3) + target.ms - (self.Menu.Prediction.Am:Value() + 200) )
		
		Draw.Circle(predictionVector)
		return predictionVector
	elseif self.predictionModified.dodger == true then
		predictionVector = target.pos:Shortened(pathingVector, (distanceToTarget / 3) + target.ms - (self.Menu.Prediction.Am:Value() + 450))
		Draw.Circle(predictionVector)
		
		return predictionVector
	end

end

function KoreanMorgana:GetTarget(range)

	if _G.EOWLoaded then
		return EOW:GetTarget(range, EOW.ap_dec, myHero.pos)
	elseif _G.SDK and _G.SDK.TargetSelector then
		return _G.SDK.TargetSelector:GetTarget(range, _G.SDK.DAMAGE_TYPE_MAGICAL)
	elseif _G.GOS then
		return GOS:GetTarget(range, "AP")
	end
end

function KoreanMorgana:AutoW()
	local target = self:GetTarget(1000)
	if target:IsValidTarget(self.W.Range, nil, myHero) and self:IsReady(_W) then
		if self:IsSnared(target) then
			Control.CastSpell(HK_W, target.pos)
			self.tickAction = true
		end
	end
end

function KoreanMorgana:IsSnared(unit)
	for i = 0, unit.buffCount do
		local buff = unit:GetBuff(i)
		if buff and (buff.type == 5 or buff.type == 11 or buff.type == 29 or buff.type == 24 or buff.name == "recall") and buff.count > 0 then
			return true
		end
	end
	return false	
end

function KoreanMorgana:IsReady (spell)
	return Game.CanUseSpell(spell) == 0 
end

function KoreanMorgana:GetAlliedHeroesInRange(pos, range)
	local _AllyHeroes = {}

  	for i = 1, Game.HeroCount() do
    	local unit = Game.Hero(i)
    	if unit and unit.isAlly then
	  		if self:GetDistance(unit.pos, pos) <= range then
	  			table.insert(_AllyHeroes, unit)
    		end
  		end
  	end
  	return _AllyHeroes
end

function KoreanMorgana:GetDistanceSqr(p1, p2)
    local dx = p1.x - p2.x
    local dz = p1.z - p2.z
    return (dx * dx + dz * dz)
end

function KoreanMorgana:GetDistance(p1, p2)
    return math.sqrt(self:GetDistanceSqr(p1, p2))
end

function KoreanMorgana:GetDistance2D(p1,p2)
    return math.sqrt((p2.x - p1.x)*(p2.x - p1.x) + (p2.y - p1.y)*(p2.y - p1.y))
end

function KoreanMorgana:AutoE()
	if self:IsReady(_E) then
		local threat
		for i = 1, Game.HeroCount() do
			local hero = Game.Hero(i)
			if hero:IsValidTarget(self.E.Range, nil, myHero) and hero.isChanneling and hero.isEnemy then
				local currSpell = hero.activeSpell
				local spellPos = currSpell.placementPos

				for i, ally in pairs(self:GetAlliedHeroesInRange(myHero.pos, self.Q.range)) do

					if ally and ally.networkID ~= myHero.networkID then
						if self:GetDistance(spellPos, ally.pos) < 100 or currSpell.target == ally.handle then
							Control.CastSpell(HK_E, ally.pos)
							self.tickAction = true
						end
					end
				end

				if self:GetDistance(spellPos, myHero.pos) < 100 or currSpell.target == myHero.handle then
					Control.CastSpell(HK_E, myHero.pos)
					self.tickAction = true
				end
			end
		end
	end
end

function KoreanMorgana:SearchForDash(unit)
	for i, k in ipairs (self.dashAboutToHappend) do
		if unit.activeSpell.name:lower() == k.name then
			self.ShootDelay[unit.charName] = k.duration
			return
		end
	end
end

local timeDash = 0
function KoreanMorgana:StartQ()

	local target = self:GetTarget(1000)

	if target == nil or not target:IsValidTarget(1000, nil, myHero) then return end

	if self:IsReady(_Q) and self.Menu.Combo.ComboQ:Value() and target:GetCollision(self.Q.width, self.Q.speed, self.Q.delay) == 0 then
		if target.activeSpell.windup > 0.1 and self.Menu.Combo.HotKeyChanger:Value()  then
			self:SearchForDash(target)
			if self.ShootDelay[target.charName] ~= nil then
				DelayAction(function()
				local posAfterAutoAttack = target.pos:Extended(self.lastPath, 50)
				Draw.Circle(posAfterAutoAttack)
				self:fast(HK_Q, target, posAfterAutoAttack, 100) end,
				self.ShootDelay[target.charName])
				self.ShootDelay[target.charName] = nil	
			else
				local posAfterAutoAttack = target.pos:Extended(self.lastPath, 75)
				Draw.Circle(posAfterAutoAttack)
				self:fast(HK_Q, target, posAfterAutoAttack, 100)
			end
		elseif self.Menu.Combo.HotKeyChanger:Value() ~= true then
			self:fast(HK_Q, target, self:Prediction(target), 200)
		end
	end
end

local timer = {state = 0, tick = GetTickCount(), casting = GetTickCount() - 1000, mouse = mousePos}
function KoreanMorgana:fast(spell, unit, prediction, delay)
	if unit == nil then 
		return 
	end
	local target = prediction:To2D()
	local unit2 = unit
	local myHeroPos = myHero.pos
	local targetPos = unit2.pos
	local shootsbackwards
	local ticker = GetTickCount()
	
	
	if timer.state == 0 and ticker - timer.tick > delay then
		timer.state = 1
		timer.mouse = mousePos
		timer.tick = ticker
		self.predi = prediction
	end

	if timer.state == 1 then
		
		if ticker - timer.tick >= 100 and ticker - timer.tick <= 1000 then
			
			if ticker - timer.tick > 100 and ticker - timer.tick < 500 and self:IsReady(_Q) and targetPos:ToScreen().onScreen then
				if self:GetDistance(self.predi, unit.pos) > 600 then
					return
				end
				Control.SetCursorPos(target.x, target.y)
				if self:GetDistance(mousePos, targetPos) > self:GetDistance(myHeroPos, targetPos) and self:GetDistance(mousePos, prediction) > 100 then
					return
				else
					Control.CastSpell(spell)
					self.tickAction = true
				end
				

			end
			if ticker - timer.tick > 501 and self:IsReady(_Q) == false then
				Control.SetCursorPos(timer.mouse)
				timer.state = 0
				
			end

			
		end
	end
end

function KoreanMorgana:Draw()
	
	local text2d = myHero.pos:To2D()
	if self.Menu.Combo.HotKeyChanger:Value() then
		Draw.Text("Q After Auto Attack or Missle", text2d.x - 50, text2d.y + 30)
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

function KoreanMorgana:OnLoad()
	self:init()
end

function KoreanMorgana:OnTick()
	
	if myHero.dead then return end

	self.tickAction = false

	if self.tickAction then self.tickAction = false return end

	local target = self:GetTarget(1000)

	if target then 
		if not target:IsValidTarget(1000, nil, myHero) then return end

		if self:xPath(target) ~= nil then
			self.lastPath = self:xPath(target)
		end
		
		self:GetOrbMode()

		if self:IsReady(_E) then
			self:AutoE()
		end

		if self.combo then
			if GetTickCount() - timer.tick > 4000 then
				timer.state = 0
			end
			if self:IsReady(_Q) then
				self:StartQ()
			end	
			if self:IsReady(_W) then
				self:AutoW()
			end
		end
	end
end

function KoreanMorgana:GetOrbMode()

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
