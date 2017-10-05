class "LazyUtility"

Callback.Add("Load", function() LazyUtility:OnLoad() end)

function LazyUtility:OnLoad()

	self.Nudes = 	
	{ 	
		Sexy = "https://i.imgur.com/swMci7o.png",
		Rainbows = "https://i.imgur.com/oeDGue7.png",
		Buttplug = "https://i.imgur.com/mziKdq5.png" 
	}

	self:LoadMenu()
	self:CreateHeroTable()

	self.RecallData = {}

	Callback.Add("Draw", function() self:OnDraw() end)
	Callback.Add("ProcessRecall", function(unit, proc) self:OnRecall(unit, proc) end)
end

function LazyUtility:LoadMenu()

	self.Menu = MenuElement({id = "MainMenu", name = "Lazy Utility", type = MENU, leftIcon = self.Nudes.Sexy })
		self.Menu:MenuElement({ id = "wPtracker", name = "WayPoint Tracker", type = MENU, leftIcon = self.Nudes.Buttplug })
			self.Menu.wPtracker:MenuElement({ id = "toggle", name = "On / Off Toggle", key = string.byte("T"), toggle = true })
			self.Menu.wPtracker:MenuElement({ id = "eta", name = "Show ETA", value = true })

			self.Menu.wPtracker:MenuElement({ id = "showAllies", name = "Show Ally Paths", value = true })
				self.Menu.wPtracker:MenuElement({ id = "allyColors", name = "Ally Color", tooltip = "color and opacity for your teams paths", type = MENU, leftIcon = self.Nudes.Rainbows })
					self.Menu.wPtracker.allyColors:MenuElement({ id = "opacity", name = "Opacity", value = 255, min = 0, max = 255, step = 1 })
					self.Menu.wPtracker.allyColors:MenuElement({ id = "red", name = "Red", value = 0, min = 0, max = 255, step = 1 })
					self.Menu.wPtracker.allyColors:MenuElement({ id = "green", name = "Green", value = 255, min = 0, max = 255, step = 1 })
					self.Menu.wPtracker.allyColors:MenuElement({ id = "blue", name = "Blue", value = 0, min = 0, max = 255, step = 1 })

			self.Menu.wPtracker:MenuElement({ id = "showEnemies", name = "Show Enemy Paths", value = true })
				self.Menu.wPtracker:MenuElement({ id = "enemyColors", name = "Enemy Color", tooltip = "color and opacity for enemy teams paths", type = MENU, leftIcon = self.Nudes.Rainbows })
					self.Menu.wPtracker.enemyColors:MenuElement({ id = "opacity", name = "Opacity", value = 255, min = 0, max = 255, step = 1 })
					self.Menu.wPtracker.enemyColors:MenuElement({ id = "red", name = "Red", value = 255, min = 0, max = 255, step = 1 })
					self.Menu.wPtracker.enemyColors:MenuElement({ id = "green", name = "Green", value = 0, min = 0, max = 255, step = 1 })
					self.Menu.wPtracker.enemyColors:MenuElement({ id = "blue", name = "Blue", value = 0, min = 0, max = 255, step = 1 })

		self.Menu:MenuElement({ id = "mMtracker", name = "Minimap Tracker", type = MENU })
			self.Menu.mMtracker:MenuElement({ id = "show", name = "MiniMap tracker", value = true, tooltip = "tracks last seen position on MiniMap" })
end

function LazyUtility:GetDistanceSqr(p1, p2)
	return (p1.x - p2.x) ^ 2 + ((p1.z or p1.y) - (p2.z or p2.y)) ^ 2
end

function LazyUtility:GetDistance(p1, p2)
	return math.sqrt(self:GetDistanceSqr(p1, p2))
end

function LazyUtility:GetPathLength(pArray)

	local length = 0
	for i = 1, #pArray -1 do
		length = length + self:GetDistance(pArray[i], pArray[i + 1]) -- table, not array *cough
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

	local points = {} -- vectors not points *cough

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