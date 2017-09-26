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
	Callback.Add("Draw", function() self:OnDraw() end)
end

function LazyUtility:LoadMenu()

	self.trackerMenu = MenuElement({id = "wPtrackerMenu", name = "Lazy Utility", type = MENU, leftIcon = self.Nudes.Sexy })
		self.trackerMenu:MenuElement({ id = "wPtracker", name = "WayPoint Tracker", type = MENU, leftIcon = self.Nudes.Buttplug })
			self.trackerMenu.wPtracker:MenuElement({ id = "toggle", name = "On / Off Toggle", key = string.byte("T"), toggle = true })
			self.trackerMenu.wPtracker:MenuElement({ id = "eta", name = "Show ETA", value = true })

			self.trackerMenu.wPtracker:MenuElement({ id = "showAllies", name = "Show Ally Paths", value = true })
				self.trackerMenu.wPtracker:MenuElement({ id = "allyColors", name = "Ally Color", tooltip = "color and opacity for your teams paths", type = MENU, leftIcon = self.Nudes.Rainbows })
					self.trackerMenu.wPtracker.allyColors:MenuElement({ id = "opacity", name = "Opacity", value = 255, min = 0, max = 255, step = 1 })
					self.trackerMenu.wPtracker.allyColors:MenuElement({ id = "red", name = "Red", value = 0, min = 0, max = 255, step = 1 })
					self.trackerMenu.wPtracker.allyColors:MenuElement({ id = "green", name = "Green", value = 255, min = 0, max = 255, step = 1 })
					self.trackerMenu.wPtracker.allyColors:MenuElement({ id = "blue", name = "Blue", value = 0, min = 0, max = 255, step = 1 })

			self.trackerMenu.wPtracker:MenuElement({ id = "showEnemies", name = "Show Enemy Paths", value = true })
				self.trackerMenu.wPtracker:MenuElement({ id = "enemyColors", name = "Enemy Color", tooltip = "color and opacity for enemy teams paths", type = MENU, leftIcon = self.Nudes.Rainbows })
					self.trackerMenu.wPtracker.enemyColors:MenuElement({ id = "opacity", name = "Opacity", value = 255, min = 0, max = 255, step = 1 })
					self.trackerMenu.wPtracker.enemyColors:MenuElement({ id = "red", name = "Red", value = 255, min = 0, max = 255, step = 1 })
					self.trackerMenu.wPtracker.enemyColors:MenuElement({ id = "green", name = "Green", value = 0, min = 0, max = 255, step = 1 })
					self.trackerMenu.wPtracker.enemyColors:MenuElement({ id = "blue", name = "Blue", value = 0, min = 0, max = 255, step = 1 })
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
				if currentHero.isAlly and self.trackerMenu.wPtracker.showAllies:Value() then
					if self.trackerMenu.wPtracker.eta:Value() then
						Draw.Text(ETA, 10, wayPoints[#wayPoints]:To2D().x + 10, wayPoints[#wayPoints]:To2D().y + 10,
							Draw.Color(self.trackerMenu.wPtracker.allyColors.opacity:Value(), self.trackerMenu.wPtracker.allyColors.red:Value(), self.trackerMenu.wPtracker.allyColors.green:Value(), self.trackerMenu.wPtracker.allyColors.blue:Value())) -- Maybe fix those 200 lines long names by using a local? *cough
					end
					if i <= #wayPoints - 1 then
						Draw.Line(wayPoints[i]:To2D().x, wayPoints[i]:To2D().y, wayPoints[i + 1]:To2D().x, wayPoints[i + 1]:To2D().y, 1, 
							Draw.Color(self.trackerMenu.wPtracker.allyColors.opacity:Value(), self.trackerMenu.wPtracker.allyColors.red:Value(), self.trackerMenu.wPtracker.allyColors.green:Value(), self.trackerMenu.wPtracker.allyColors.blue:Value()))
					end
				elseif currentHero.isEnemy and self.trackerMenu.wPtracker.showEnemies:Value() then
				if self.trackerMenu.wPtracker.eta:Value() then
						Draw.Text(ETA, 10, wayPoints[#wayPoints]:To2D().x + 10, wayPoints[#wayPoints]:To2D().y + 10,
							Draw.Color(self.trackerMenu.wPtracker.enemyColors.opacity:Value(), self.trackerMenu.wPtracker.enemyColors.red:Value(), self.trackerMenu.wPtracker.enemyColors.green:Value(), self.trackerMenu.wPtracker.enemyColors.blue:Value()))
					end
					if i <= #wayPoints - 1 then
						Draw.Line(wayPoints[i]:To2D().x, wayPoints[i]:To2D().y, wayPoints[i + 1]:To2D().x, wayPoints[i + 1]:To2D().y, 1, 
							Draw.Color(self.trackerMenu.wPtracker.enemyColors.opacity:Value(), self.trackerMenu.wPtracker.enemyColors.red:Value(), self.trackerMenu.wPtracker.enemyColors.green:Value(), self.trackerMenu.wPtracker.enemyColors.blue:Value()))
					end 
				end	
			end
		end
	end
end

function LazyUtility:OnDraw()

	if not self.trackerMenu.wPtracker.toggle:Value() then return end
	self:DrawWayPoints()
end