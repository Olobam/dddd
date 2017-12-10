class "LazyUtility"

Callback.Add("Load", function() LazyUtility:OnLoad() end)

function LazyUtility:OnLoad()

	self.Nudes = 	
	{ 	
		Sexy = "https://i.imgur.com/swMci7o.png",
		Rainbows = "https://i.imgur.com/oeDGue7.png",
		bilgewaterCutlass = "https://i.imgur.com/IREFNf6.png",
		Botrk = "https://i.imgur.com/tVOUUBN.png",
		ironSolari = "",
		edgeOfNight = "https://i.imgur.com/SgvqT35.png",
		faceOfTheMountain = "",
		frostQueensClaim = "https://i.imgur.com/TRFkMUw.png",
		hextechGLP = "https://i.imgur.com/U2jXNJB.png",
		hextechGunblade = "https://i.imgur.com/ekvQhjS.png",
		hextechProtobelt = "https://i.imgur.com/NreXohf.png",
		mercurialScimitar = "",
		mikaelsCrucible = "",
		ohmwrecker = "",
		ravenousHydra = "",
		redemption = "https://i.imgur.com/d5zD5FJ.png",
		tiamat = "",
		youmuusGhostblade = "",
		zhonyas = "https://i.imgur.com/QcqvC9F.png",
		titanicHydra = "",
		wayPoints = "https://i.imgur.com/IXT5RNn.png",
		minimap = "https://i.imgur.com/rLmHEPg.png",
		activator = "https://i.imgur.com/YVSSNsL.png"
	}

	self:LoadMenu()
	self:CreateHeroTable()

	self.RecallData = {}

	Callback.Add("Draw", function() self:OnDraw() end)
	Callback.Add("ProcessRecall", function(unit, proc) self:OnRecall(unit, proc) end)
	Callback.Add("Tick", function() self:OnTick() end)
end

function LazyUtility:LoadMenu()

	self.Menu = Menu({id = "MainMenu", name = "Lazy Utility", type = MENU, leftIcon = self.Nudes.Sexy })
		self.Menu:Menu({ id = "mMtracker", name = "Minimap Tracker", type = MENU, leftIcon = self.Nudes.minimap })
			self.Menu.mMtracker:MenuElement({ id = "show", name = "MiniMap tracker", value = true, tooltip = "tracks last seen position on MiniMap" })

--Activator
		self.Menu:MenuElement({ id = "Activator", name = "Activator", type = MENU, leftIcon = self.Nudes.activator })
--bilgewaterCutlass
			self.Menu.Activator:MenuElement({ id = "bilgewaterCutlass", name = "Bilgewater Cutlass", type = MENU, leftIcon = self.Nudes.bilgewaterCutlass})
				self.Menu.Activator.bilgewaterCutlass:MenuElement({ id = "useBilgewaterCutlass", name = "Use", value = true, tooltip = "general ON/OFF switch" })
				self.Menu.Activator.bilgewaterCutlass:MenuElement({ id = "bilgewaterCutlassTHP", name = "Enemy HP %", value = 40, min = 0, max = 101, step = 1, tooltip = "if Target HP% < x" })
				self.Menu.Activator.bilgewaterCutlass:MenuElement({ id = "bilgewaterCutlassHP", name = "my Hero HP %", value = 40, min = 0, max = 101, step = 1, tooltip = "My HP% < x" })
				self.Menu.Activator.bilgewaterCutlass:MenuElement({ id = "bilgewaterCutlassRange", name = "Range", value = 550, min = 0, max = 550 , step = 10, tooltip = "Target in x Range" })
--botrk
			self.Menu.Activator:MenuElement({ id = "botrk", name = "BotRK", type = MENU , leftIcon = self.Nudes.Botrk})
				self.Menu.Activator.botrk:MenuElement({ id = "useBotrk", name = "Use", value = true, tooltip = "general ON/OFF switch" })
				self.Menu.Activator.botrk:MenuElement({ id = "botrkTHP", name = "Enemy HP %", value = 40, min = 0, max = 101, step = 1, tooltip = "if Target HP% < x" })
				self.Menu.Activator.botrk:MenuElement({ id = "botrkHP", name = "my Hero HP %", value = 40, min = 0, max = 101, step = 1, tooltip = "My HP% < x" })
				self.Menu.Activator.botrk:MenuElement({ id = "botrkRange", name = "Range", value = 550, min = 0, max = 550, step = 10, tooltip = "Target in x Range" })
--edgeOfNight
			self.Menu.Activator:MenuElement({ id = "edgeOfNight", name = "Edge Of Night", type = MENU, leftIcon = self.Nudes.edgeOfNight })
				self.Menu.Activator.edgeOfNight:MenuElement({ id = "useEdgeOfNight", name = "Use", value = true, tooltip = "general ON/OFF switch" })
				self.Menu.Activator.edgeOfNight:MenuElement({ id = "edgeOfNightRange", name = "Range", value = 2000, min = 0, max = 2000, step = 100, tooltip = "Target in x Range" })
--frostQueensClaim
			self.Menu.Activator:MenuElement({ id = "frostQueensClaim", name = "Frost Queens Claim", type = MENU, leftIcon = self.Nudes.frostQueensClaim })
				self.Menu.Activator.frostQueensClaim:MenuElement({ id = "useFrostQueensClaim", name = "Use", value = true, tooltip = "general ON/OFF switch" })
				self.Menu.Activator.frostQueensClaim:MenuElement({ id = "frostQueensClaimTHP", name = "Enemy HP %", value = 75, min = 0, max = 101, step = 1, tooltip = "if Target HP% < x" })
				self.Menu.Activator.frostQueensClaim:MenuElement({ id = "frostQueensClaimHP", name = "my Hero HP %", value = 101, min = 0, max = 101, step = 1, tooltip = "My HP% < x" })
				self.Menu.Activator.frostQueensClaim:MenuElement({ id = "frostQueensClaimRange", name = "Range", value = 4000, min = 0, max = 4500, step = 100, tooltip = "Target in x Range" })
--hextechGLP
			self.Menu.Activator:MenuElement({ id = "hextechGLP", name = "Hextech GLP-800", type = MENU, leftIcon = self.Nudes.hextechGLP })
				self.Menu.Activator.hextechGLP:MenuElement({ id = "useHextechGLP", name = "Use", value = true, tooltip = "general ON/OFF switch" })
				self.Menu.Activator.hextechGLP:MenuElement({ id = "hextechGLPTHP", name = "Enemy HP %", value = 60, min = 0, max = 101, step = 1, tooltip = "if Target HP% < x" })
				self.Menu.Activator.hextechGLP:MenuElement({ id = "hextechGLPHP", name = "my Hero HP %", value = 30, min = 0, max = 101, step = 1, tooltip = "My HP% < x" })
				self.Menu.Activator.hextechGLP:MenuElement({ id = "hextechGLPRange", name = "Range", value = 400, min = 0, max = 400, step = 10, tooltip = "Target in x Range" })		
--hextechGunblade
			self.Menu.Activator:MenuElement({ id = "hextechGunblade", name = "Hextech Gunblade", type = MENU, leftIcon = self.Nudes.hextechGunblade })
				self.Menu.Activator.hextechGunblade:MenuElement({ id = "useHextechGunblade", name = "Use", value = true, tooltip = "general ON/OFF switch" })
				self.Menu.Activator.hextechGunblade:MenuElement({ id = "hextechGunbladeTHP", name = "Enemy HP %", value = 35, min = 0, max = 101, step = 1, tooltip = "if Target HP% < x" })
				self.Menu.Activator.hextechGunblade:MenuElement({ id = "hextechGunbladeHP", name = "my Hero HP %", value = 35, min = 0, max = 101, step = 1, tooltip = "My HP% < x" })
				self.Menu.Activator.hextechGunblade:MenuElement({ id = "hextechGunbladeRange", name = "Range", value = 700, min = 0, max = 700, step = 10, tooltip = "Target in x Range" })
--hextechProtobelt
			self.Menu.Activator:MenuElement({ id = "hextechProtobelt", name = "Hextech Protobelt", type = MENU, leftIcon = self.Nudes.hextechProtobelt })
				self.Menu.Activator.hextechProtobelt:MenuElement({ id = "useHextechProtobelt", name = "Use", value = true, tooltip = "general ON/OFF switch" })
				self.Menu.Activator.hextechProtobelt:MenuElement({ id = "hextechProtobeltTHP", name = "Enemy HP %", value = 25, min = 0, max = 101, step = 1, tooltip = "if Target HP% < x" })
				self.Menu.Activator.hextechProtobelt:MenuElement({ id = "hextechProtobeltRange", name = "Range", value = 500, min = 0, max = 600, step = 10, tooltip = "Target in x Range" })
--redemption
			self.Menu.Activator:MenuElement({ id = "redemption", name = "Redemption", type = MENU, leftIcon = self.Nudes.redemption })
				self.Menu.Activator.redemption:MenuElement({ id = "useRedemption", name = "Use", value = true, tooltip = "general ON/OFF switch" })
				self.Menu.Activator.redemption:MenuElement({ id = "redemptionTHP", name = "Enemy HP %", value = 11, min = 0, max = 101, step = 1, tooltip = "if Target HP% < x" })
				self.Menu.Activator.redemption:MenuElement({ id = "redemptionHP", name = "my Hero HP %", value = 11, min = 0, max = 101, step = 1, tooltip = "My HP% < x" })
				self.Menu.Activator.redemption:MenuElement({ id = "redemptionRange", name = "Range", value = 5500, min = 0, max = 5500, step = 10, tooltip = "Target in x Range" })
--zhonyas
			self.Menu.Activator:MenuElement({ id = "zhonyasHourglass", name = "Zhonyas Hourglass", type = MENU, leftIcon = self.Nudes.zhonyas })
				self.Menu.Activator.zhonyasHourglass:MenuElement({ id = "useZhonyasHourglass", name = "Use", value = true, tooltip = "general ON/OFF switch" })
				self.Menu.Activator.zhonyasHourglass:MenuElement({ id = "zhonyasHourglassTHP", name = "Enemy HP %", value = 101, min = 0, max = 101, step = 1, tooltip = "if Target HP% < x" })
				self.Menu.Activator.zhonyasHourglass:MenuElement({ id = "zhonyasHourglassHP", name = "my Hero HP %", value = 10, min = 0, max = 101, step = 1, tooltip = "My HP% < x" })
				self.Menu.Activator.zhonyasHourglass:MenuElement({ id = "zhonyasHourglassRange", name = "Range", value = 500, min = 0, max = 600, step = 10, tooltip = "Target in x Range" })
end

function LazyUtility:OnTick()
	self:GetOrbMode()
	self:UseItems()
end

function LazyUtility:GetDistanceSqr(p1, p2)
	return (p1.x - p2.x) ^ 2 + ((p1.z or p1.y) - (p2.z or p2.y)) ^ 2
end

function LazyUtility:GetDistance(p1, p2)
	return math.sqrt(self:GetDistanceSqr(p1, p2))
end

function LazyUtility:GetHpPercent(unit)
    return unit.health / unit.maxHealth * 100
end

function LazyUtility:GetManaPercent(unit)
	return unit.mana / unit.maxMana * 100
end

function LazyUtility:GetPathLength(pArray)

	local length = 0
	for i = 1, #pArray -1 do
		length = length + self:GetDistance(pArray[i], pArray[i + 1])
	end
	return length
end

function LazyUtility:CalcETA(unit)

	local wayPoints = self:GetWayPoints(unit)
	local pathLength = self:GetPathLength(wayPoints)
	local moveSpeed = unit.ms
	
	local timer =  pathLength / moveSpeed
	local rounded = tonumber(string.format("%.1f", timer))

	return rounded
end

function LazyUtility:GetWayPoints(unit)

	local points = {}

	if unit.pathing.hasMovePath then
		table.insert(points, Vector(unit.pos.x, unit.pos.y, unit.pos.z))

		for i = unit.pathing.pathIndex, unit.pathing.pathCount do
			path = unit:GetPath(i)
			table.insert(points, Vector(path.x, path.y, path.z))
		end
	end
	return points
end

function LazyUtility:DrawWayPoints()

	for h = 1, Game.HeroCount() do

		local currentHero = Game.Hero(h)
		local heroPos2D = currentHero.pos:To2D()
		local wayPoints = self:GetWayPoints(currentHero)
		local ETA = self:CalcETA(currentHero)

		for i = 1, #wayPoints do

			if currentHero.pathing.hasMovePath then
				if currentHero.isAlly and self.Menu.wPtracker.showAllies:Value() then
					if self.Menu.wPtracker.eta:Value() then
						Draw.Text(ETA, 10, wayPoints[#wayPoints]:To2D().x + 10, wayPoints[#wayPoints]:To2D().y + 10,
							Draw.Color(self.Menu.wPtracker.allyColors.opacity:Value(), self.Menu.wPtracker.allyColors.red:Value(), self.Menu.wPtracker.allyColors.green:Value(), self.Menu.wPtracker.allyColors.blue:Value())) -- Maybe fix those 200 lines long names by using a local? *cough
					end				
					if i <= #wayPoints - 1 then
						Draw.Line(wayPoints[i]:To2D().x, wayPoints[i]:To2D().y, wayPoints[i + 1]:To2D().x, wayPoints[i + 1]:To2D().y, 1, 
							Draw.Color(self.Menu.wPtracker.allyColors.opacity:Value(), self.Menu.wPtracker.allyColors.red:Value(), self.Menu.wPtracker.allyColors.green:Value(), self.Menu.wPtracker.allyColors.blue:Value()))
					end
				elseif currentHero.isEnemy and self.Menu.wPtracker.showEnemies:Value() then
					if self.Menu.wPtracker.eta:Value() then
						Draw.Text(ETA, 10, wayPoints[#wayPoints]:To2D().x + 10, wayPoints[#wayPoints]:To2D().y + 10,
							Draw.Color(self.Menu.wPtracker.enemyColors.opacity:Value(), self.Menu.wPtracker.enemyColors.red:Value(), self.Menu.wPtracker.enemyColors.green:Value(), self.Menu.wPtracker.enemyColors.blue:Value()))
					end
					if i <= #wayPoints - 1 then
						Draw.Line(wayPoints[i]:To2D().x, wayPoints[i]:To2D().y, wayPoints[i + 1]:To2D().x, wayPoints[i + 1]:To2D().y, 1, 
							Draw.Color(self.Menu.wPtracker.enemyColors.opacity:Value(), self.Menu.wPtracker.enemyColors.red:Value(), self.Menu.wPtracker.enemyColors.green:Value(), self.Menu.wPtracker.enemyColors.blue:Value()))
					end 
				end	
			end
		end
	end
end

local heroTable = {}

function LazyUtility:CreateHeroTable()

	for h = 1, Game.HeroCount() do

		local currentHero = Game.Hero(h)

		if currentHero.isEnemy then
			table.insert( heroTable, { hero = currentHero, lastSeen = GetTickCount() } )
		end
	end
end

function LazyUtility:TrackHeroes()

	for i, v in pairs(heroTable) do
		local shortTime = tonumber(string.format("%.1f", (GetTickCount()*0.001 - v.lastSeen*0.001)))
		local shortName = string.sub(v.hero.charName, 0, 4)
		if self:IsRecalling(v.hero) then
			local recall = 0 
			for i, rc in pairs(self.RecallData) do
				if rc.object.networkID == v.hero.networkID then
					recall = tonumber(string.format("%.1f",(rc.start + rc.duration - GetTickCount()) * 0.001))
				end				
			end
			Draw.CircleMinimap(v.hero.pos, 900, 2, Draw.Color(255, 100, 150, 255)) --  Blue for recalls #lazy
			Draw.Text(shortName.. "  RECALL", 6, v.hero.pos:ToMM().x - 20, v.hero.pos:ToMM().y, Draw.Color(255, 50, 150, 255)) -- on MM
			Draw.Text(v.hero.charName.. " Recalling ( "..recall.." )", 12, v.hero.pos:To2D(), Draw.Color(255, 50, 150, 255)) -- on ground
		return end
		if v.hero.visible then
			heroTable[i].lastSeen = GetTickCount()		
		elseif not v.hero.visible and not v.hero.dead then
			if not self:IsRecalling(v.hero) then
				Draw.CircleMinimap(v.hero.pos, 900, 2, Draw.Color(255, 255, 0, 0)) -- Circle on MM
			end		
				Draw.Text(shortName.. ": " ..shortTime, 9, v.hero.pos:ToMM().x - 20, v.hero.pos:ToMM().y, Draw.Color(255, 255, 255, 255)) -- Text on MM
				Draw.Text(v.hero.charName.. " MISSING: : " ..shortTime, 12, v.hero.pos:To2D(), Draw.Color(255, 50, 255, 255)) -- draw on ground aswell
		end
	end

end

function LazyUtility:OnDraw()

	if self.Menu.wPtracker.toggle:Value() then
		self:DrawWayPoints()
	end
	if self.Menu.mMtracker.show:Value() then
		self:TrackHeroes()
	end
end

function LazyUtility:OnRecall(unit, proc)
	if proc.isStart then
    		table.insert(self.RecallData, { object = unit, start = GetTickCount(), duration = proc.totalTime })
    else
      	for i, rc in pairs(self.RecallData) do
        	if rc.object.networkID == unit.networkID then
          		table.remove(self.RecallData, i)
       		end
  		end
    end
end

function LazyUtility:IsRecalling(unit)
	for i, recall in pairs(self.RecallData) do
		if unit ~= nil then
    		if recall.object.networkID == unit.networkID then
    			return true end
	    	else return false
	    end
	end
end

function LazyUtility:GetTarget(range)

	if _G.EOWLoaded then
		return EOW:GetTarget(range, EOW.ap_dec, myHero.pos)
	elseif _G.SDK and _G.SDK.TargetSelector then
		return _G.SDK.TargetSelector:GetTarget(range, _G.SDK.DAMAGE_TYPE_MAGICAL)
	elseif _G.GOS then
		return GOS:GetTarget(range, "AP")
	end
end

function LazyUtility:GetInventoryItem(itemID)
	for _, i in pairs({ ITEM_1, ITEM_2, ITEM_3, ITEM_4, ITEM_5, ITEM_6 }) do
		if myHero:GetItemData(i).itemID == itemID and myHero:GetSpellData(i).currentCd == 0 then return i end
	end
	return nil
end

local items = { [ITEM_1] = HK_ITEM_1, [ITEM_2] = HK_ITEM_2, [ITEM_3] = HK_ITEM_3, [ITEM_4] = HK_ITEM_4, [ITEM_5] = HK_ITEM_5, [ITEM_6] = HK_ITEM_6 }

function LazyUtility:UseItems()
	
	local target = self:GetTarget(5500)

	if target ~= nil and self.combo then 

	local bilgewaterCutlass = self:GetInventoryItem(3144)
	local botrk = self:GetInventoryItem(3153)
	local ironSolari = self:GetInventoryItem(3383)
	local edgeOfNight = self:GetInventoryItem(3814)
	local faceOfTheMountain = self:GetInventoryItem(3401)
	local frostQueensClaim = self:GetInventoryItem(3092)
	local hextechGLP = self:GetInventoryItem(3030)
	local hextechGunblade = self:GetInventoryItem(3146)
	local hextechProtobelt = self:GetInventoryItem(3152)
	local mercurialScimitar = self:GetInventoryItem(3139)
	local mikaelsCrucible = self:GetInventoryItem(3222)
	local ohmwrecker = self:GetInventoryItem(3056)
	local ravenousHydra = self:GetInventoryItem(3074)
	local redemption = self:GetInventoryItem(3107)
	local tiamat = self:GetInventoryItem(3077)
	local youmuusGhostblade = self:GetInventoryItem(3142)
	local zhonyasHourglass = self:GetInventoryItem(3157)
	local titanicHydra = self:GetInventoryItem(3748)

--bilgewaterCutlass
	if bilgewaterCutlass and self.Menu.Activator.bilgewaterCutlass.useBilgewaterCutlass:Value() and
		self:GetDistance(myHero.pos, target.pos) < self.Menu.Activator.bilgewaterCutlass.bilgewaterCutlassRange:Value() then
		if self:GetHpPercent(target) < self.Menu.Activator.bilgewaterCutlass.bilgewaterCutlassTHP:Value() or
			self:GetHpPercent(myHero) < self.Menu.Activator.bilgewaterCutlass.bilgewaterCutlassHP:Value() then
			Control.CastSpell(items[bilgewaterCutlass], target.pos)
		end
	return end
--botrk
	if botrk and self.Menu.Activator.botrk.useBotrk:Value() and
		self:GetDistance(myHero.pos, target.pos) < self.Menu.Activator.botrk.botrkRange:Value() then
		if self:GetHpPercent(target) < self.Menu.Activator.botrk.botrkTHP:Value() or
			self:GetHpPercent(myHero) < self.Menu.Activator.botrk.botrkHP:Value() then
			Control.CastSpell(items[botrk], target.pos)
		end
	end
--edgeOfNight
	if edgeOfNight and self.Menu.Activator.edgeOfNight.useEdgeOfNight:Value() and
		self:GetDistance(myHero.pos, target.pos) < self.Menu.Activator.edgeOfNight.edgeOfNightRange:Value() then
		Control.CastSpell(items[edgeOfNight], myHero.pos)
	end
--frostQueensClaim
	if frostQueensClaim and self.Menu.Activator.frostQueensClaim.useFrostQueensClaim:Value() and
		self:GetDistance(myHero.pos, target.pos) < self.Menu.Activator.frostQueensClaim.frostQueensClaimRange:Value() then
		if self:GetHpPercent(target) < self.Menu.Activator.frostQueensClaim.frostQueensClaimTHP:Value() or
			self:GetHpPercent(myHero) < self.Menu.Activator.frostQueensClaim.frostQueensClaimHP:Value() then
			Control.CastSpell(items[frostQueensClaim], myHero.pos)
		end
	end
--hextechGLP
	if hextechGLP and self.Menu.Activator.hextechGLP.useHextechGLP:Value() and 
		self:GetDistance(myHero.pos, target.pos) < self.Menu.Activator.hextechGLP.hextechGLPRange:Value() then
		if self:GetHpPercent(target) < self.Menu.Activator.hextechGLP.hextechGLPTHP:Value() or
			self:GetHpPercent(myHero) < self.Menu.Activator.hextechGLP.hextechGLPHP:Value() then
			Control.CastSpell(items[hextechGLP], target.pos)
		end
	end
--hextechGunblade
	if hextechGunblade and self.Menu.Activator.hextechGunblade.useHextechGunblade:Value() and
		self:GetDistance(myHero.pos, target.pos) < self.Menu.Activator.hextechGunblade.hextechGunbladeRange:Value() then
		if self:GetHpPercent(target) < self.Menu.Activator.hextechGunblade.hextechGunbladeTHP:Value() or
			self:GetHpPercent(myHero) < self.Menu.Activator.hextechGunblade.hextechGunbladeHP:Value() then
			Control.CastSpell(items[hextechGunblade], target.pos)
		end
	end
--hextechProtobelt
	if hextechProtobelt and self.Menu.Activator.hextechProtobelt.useHextechProtobelt:Value() and
		self:GetDistance(myHero.pos, target.pos) < self.Menu.Activator.hextechProtobelt.hextechProtobeltRange:Value() then
		if self:GetHpPercent(target) < self.Menu.Activator.hextechProtobelt.hextechProtobeltTHP:Value() then
			Control.CastSpell(items[hextechProtobelt], target.pos)
		end
	end
--redemption
	if redemption and self.Menu.Activator.redemption.useRedemption:Value() and
		self:GetDistance(myHero.pos, target.pos) < self.Menu.Activator.redemption.redemptionRange:Value() and target.pos.onScreen then			
			if self:GetHpPercent(myHero) < self.Menu.Activator.redemption.redemptionHP:Value() and not myHero.dead then
				Control.CastSpell(items[redemption], myHero.pos)
			elseif self:GetHpPercent(target) < self.Menu.Activator.redemption.redemptionTHP:Value() then
				Control.CastSpell(items[redemption], target:GetPrediction(target.ms, 100):ToMM())
			end
		end
	end
--zhonyas
	if zhonyas and self.Menu.Activator.zhonyas.useZhonyas:Value() and
		self:GetDistance(myHero.pos, target.pos) < self.Menu.Activator.zhonyas.zhonyasRange:Value() then
		if self:GetHpPercent(target) < self.Menu.Activator.zhonyas.zhonyasTHP:Value() or
			self:GetHpPercent(myHero) < self.Menu.Activator.zhonyas.zhonyasHP:Value() then
			Control.CastSpell(items[hextechProtobelt], myHero.pos)
		end
	end
end

function LazyUtility:GetOrbMode()
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
