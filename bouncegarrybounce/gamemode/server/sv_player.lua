GM.TheProps = {}
GM.ThePowerups = {}

local meta = FindMetaTable("Player")

function meta:Win()
	if self.NextWin > CurTime() then return end

	self.NextWin = CurTime()+10
	
	for k, v in pairs(player.GetAll()) do
		v.Jumper:SetMoveType(MOVETYPE_NONE)
	end
	
	self.Jumper:SetPos(self.Jumper:GetPos()+Vector(0, 0, 32))
	self:AddFrags(1)
	BroadcastLua("DoParticleExplode("..self:EntIndex()..")")
	BroadcastLua([[GAMEMODE.CurNotify = "]]..self:Nick()..[[ reached the top!"]])
	timer.Simple(2, function() BroadcastLua([[GAMEMODE.CurNotify = "Mixing the props around!"]]) end)
	timer.Simple(2, function() 
		GAMEMODE:InitPostEntity()
	end)
	timer.Simple(4, function() BroadcastLua([[GAMEMODE.CurNotify = "Play!"]]) end)
	timer.Simple(6, function() BroadcastLua([[GAMEMODE.CurNotify = false]]) end)
	
	for k, v in pairs(player.GetAll()) do
		timer.Simple(4, function() v:Spawn() end)
	end
	
end

function GM:PlayerInitialSpawn(ply)
	self.BaseClass:PlayerInitialSpawn(ply)
	ply.NextWin = 0
	ply.NextHeightCheck = 0
	timer.Simple(0.4, function() ply:Spawn() end)
end

function GM:PlayerSpawn(ply)
	self.BaseClass:PlayerSpawn(ply)
	
	ply:SendLua([[GAMEMODE.CurNotify = "Play!"]])
	timer.Simple(2, function() if ply:IsValid() then ply:SendLua([[GAMEMODE.CurNotify = false]]) end end)
	
	ply.NextWin = 0
	
	ply.NextHeightCheck = 0
	
	ply:SetTeam(24)
end

function GM:PlayerDisconnect( ply )
	ply.Jumper:Remove()
	ply.Jumper = nil
end

local function ShouldCollideTestHook( ent1, ent2 )
	if ( ent1:GetClass() == "sent_jumper" and ent2:GetClass() == "sent_jumper" ) then
		return false
	end

end
hook.Add( "ShouldCollide", "ShouldCollideTestHook", ShouldCollideTestHook )

function GM:PlayerSwitchFlashlight( ply, b )
	return false or not b
end
 
function GM:InitPostEntity()
	for k, v in pairs(self.TheProps) do
		if self.TheProps[i] != "no" then
			if v then
				v:Remove()
			end
		end
		v = nil
	end
	
	for k, v in pairs(self.ThePowerups) do
		if IsValid(v) then v:Remove() end
		v = nil
	end
	
	-- Place the basic jump entitys first.
	
	for i = 1, 60 do
		if !self.TheProps[i] or self.TheProps[i] == "no" then
			local a = ents.Create("jump_prop")
			--a:SetModel("models/props_wasteland/wood_fence01a.mdl")
			a:SetModel("models/bgb/platform.mdl")
			a:SetPos(Vector(math.random(-250, 250), -1300, 150*i))
			a:SetAngles(Angle(0, 90, 0))
			a:Spawn()
			local entphys = a:GetPhysicsObject();
			if entphys:IsValid() then
				entphys:EnableMotion(false)
			end
		
			if math.random(1, 10) == 1 then
				a:SetNWInt("Type", 2)
				a:SetColor(Color(100, 100, 100, 255))
				a:SetNWInt("RandomTime", math.random(0, 360))
				a:SetNWInt("RSpeed", math.random(50, 175))
			elseif math.random(1, 10) == 1 then
				a:SetNWInt("Type", 3)
				a:SetColor(Color(100, 100, 100, 255))
				
				self.TheProps[i+2] = "no"
				if self.TheProps[i-1] then
					self.TheProps[i-1]:Remove()
					self.TheProps[i-1] = "no"
				end
				a:SetNWInt("RandomTime", math.random(0, 360))
				a:SetNWInt("RSpeed", math.random(70, 200))
				a:SetNWInt("ZPos", (150*i)-150)
			else
				a:SetNWInt("Type", 1)
				a:SetColor(Color(200, 200, 200, 255))
			end
		
			self.TheProps[i] = a
		
		end
	
	end
	
	-- Move some props around so we're not crowded!
	
	for i = 1, 60 do
		if type(self.TheProps[i]) != "string" then
			local pos = self.TheProps[i]:GetPos()
			local pos2 = pos + Vector(0, 0, 160) -- Check the prop above!
			local tracedata = {}
			tracedata.start = pos
			tracedata.endpos = pos2
			tracedata.filter = self.TheProps[i]
			local trace = util.TraceLine(tracedata)
			if !IsValid(trace.Entity) then
				print("Prop: "..i.." - did not hit any entity 1 prop upwards!")
			else
				print("Prop: "..i.." - hit entity: "..tostring(trace.Entity))
				print("So that entity has been moved!")
				
				local newpos = trace.Entity:GetPos()
				newpos.x = newpos.x * -1
				
				trace.Entity:SetPos(newpos)
			end
		end
	end
	
	-- Place powerups by checking trace:
	
	timer.Simple(0.5, function()
	
		for i = 1, 60 do
			if type(self.TheProps[i]) != "string" then
				local pos = self.TheProps[i]:GetPos()
				local pos2 = pos + Vector(0, 0, 600)
				local tracedata = {}
				tracedata.start = pos
				tracedata.endpos = pos2
				tracedata.filter = self.TheProps[i]
				local trace = util.TraceLine(tracedata)
				if !IsValid(trace.Entity) then
					if math.random(1, 4) == 1 then
						if self.TheProps[i]:GetNWInt("Type") == 1 then
						
							local b = ents.Create("powerup")
							b:SetModel("models/Combine_Helicopter/helicopter_bomb01.mdl")
							b:SetPos(pos+Vector(0, 0, 16))
							b:Spawn()
							local entphys = b:GetPhysicsObject();
							if entphys:IsValid() then
								entphys:EnableMotion(false)
							end
								
							self.ThePowerups[i] = b
						end
					end
				end
			end
		end
	
	end)
	
	-- Finish Entity Dadada!
	
	local a = ents.Create("finish_prop")
	a:SetModel("models/bgb/platform.mdl")
	a:SetPos(Vector(0, -1300, 150*61))
	a:SetAngles(Angle(0, 90, 0))
	a:SetColor(Color(0, 255, 0, 255))
	a:Spawn()
	local entphys = a:GetPhysicsObject();
	if entphys:IsValid() then
		entphys:EnableMotion(false)
	end
	
	self.TheProps[61] = a
end
 

function GM:CanPlayerSuicide( ply )
	-- Suiciding will mess up the game...
	ply:PrintMessage(HUD_PRINTTALK, "Arr!")
	return false
end
 
hook.Add("Think", "KeyPressing", function()
	for k, v in pairs(player.GetAll()) do
		if v.Jumper then
			if v:KeyDown(IN_MOVELEFT) then
				v.Jumper:GetPhysicsObject():AddVelocity(Vector(16, 0, 0))
			end
		
			if v:KeyDown(IN_MOVERIGHT) then
				v.Jumper:GetPhysicsObject():AddVelocity(Vector(-16, 0, 0))
			end
		end
	end
end)