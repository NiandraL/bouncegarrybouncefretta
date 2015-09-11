// Shared files
include( "shared.lua" )

ZoomIn = 0

function hidehud(name)
	if table.HasValue({"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"}, name) then return false end
end
hook.Add("HUDShouldDraw", "hidehud", hidehud)

function MyCalcView(ply, pos, angles, fov)
	if !LocalPlayer().Jumper then return end
	if !IsValid(LocalPlayer().Jumper) then return end

	if LocalPlayer():KeyDown(IN_FORWARD) then
		ZoomIn = ZoomIn - 4
	end
	
	if LocalPlayer():KeyDown(IN_BACK) then
		ZoomIn = ZoomIn + 4
	end
	
	local view = {}
	view.origin = LocalPlayer().Jumper:GetPos()+Vector(0, 500+ZoomIn, 100)
	view.angles = Angle(0, -90, 0)
	view.fov = fov
	 
	return view
end 
hook.Add("CalcView", "MyCalcView", MyCalcView)

local matGradiantDown = surface.GetTextureID("gui/gradient_down")
local matGradiantUp = surface.GetTextureID("gui/gradient_up")

function DoParticleExplode(pl)
	ply = player.GetByID(pl)
	local NumParticles = 256
	
	if !ply.Jumper then return end
	
	local emitter = ParticleEmitter( ply.Jumper:GetPos() )
	
		for i=0, NumParticles do
		
			local particle = emitter:Add( "effects/spark", ply.Jumper:GetPos() )
			if (particle) then
				
				particle:SetVelocity( VectorRand() * math.random(0, 1000) )
				
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.random(1, 4) )
				
				particle:SetStartAlpha( 255 )
				particle:SetEndAlpha( 0 )
				
				particle:SetStartSize( math.random(5, 15) )
				particle:SetEndSize( 0 )
				
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( math.Rand(-200, 200) )
				
				particle:SetAirResistance( 400 )
				
				particle:SetGravity( Vector( 0, 0, 100 ) )
			
			end
			
		end
		
	emitter:Finish()
end

function hidehud(name)
	for k, v in pairs{"CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo"} do
		if name == v then return false end
	end
end
hook.Add("HUDShouldDraw", "hidehud", hidehud)

function GM:HUDPaint()
	self.BaseClass:HUDPaint()

	if self.CurNotify then
		surface.SetFont("FHUDElement")
		local w = surface.GetTextSize(self.CurNotify) + 40
		draw.RoundedBox( 4, (ScrW()/2)-(w/2), 25, w, 50, Color( 0, 0, 0, 100 ) )	

		draw.SimpleText(self.CurNotify, "FHUDElement", (ScrW()/2), 50, Color( 255, 255, 255, 255 ), 1, 1 )	
	end

	draw.RoundedBox( 4, (ScrW()/2)-125, ScrH()-75, 250, 50, Color( 0, 0, 0, 100 ) )	

	draw.SimpleText("WINS", "HudSelectionText", (ScrW()/2)-105, ScrH()-50, Color( 255, 255, 0, 255 ), 0, 1 )
	draw.SimpleText(LocalPlayer():Frags(), "FHUDElement", (ScrW()/2)-65, ScrH()-50, Color( 255, 255, 255, 255 ), 0, 1 )

	local Time = string.ToMinutesSeconds( self:GetGameTimeLeft() )
	
	draw.SimpleText("TIME", "HudSelectionText", (ScrW()/2)+25, ScrH()-50, Color( 255, 255, 0, 255 ), 2, 1 )
	draw.SimpleText(Time, "FHUDElement", (ScrW()/2)+105, ScrH()-50, Color( 255, 255, 255, 255 ), 2, 1 )
	
	for k, v in pairs(player.GetAll()) do
		if v.Jumper and IsValid(v.Jumper) then
			local x = v.Jumper:GetPos():ToScreen().x
			local y = v.Jumper:GetPos():ToScreen().y
			local offside = false
			
			if x < 0 then offside = true end
			if x > ScrW() then offside = true end
			if y < 0 then offside = true end
			if y > ScrH() then offside = true end
			
			if !offside then
				draw.DrawText(v:Nick(), "ChatFont",x, y-60, color_white, 1)
				if v.Height then
					draw.DrawText("Height: "..v.Height.."%", "ChatFont",x, y-40, color_white, 1)
				end
			end
		end
	end
end

function my_message_hook( um )
	local pid = um:ReadLong()
	local eid = um:ReadLong()

	print(pid)
	print(eid)

	timer.Simple(0.1, function()
		player.GetByID(pid).Jumper = Entity(eid)
	end)
	
end
usermessage.Hook("myjumper", my_message_hook)

function GM:CreateScoreboard( ScoreBoard )

	// This makes it so that it's behind chat & hides when you're in the menu
	// Disable this if you want to be able to click on stuff on your scoreboard
	ScoreBoard:ParentToHUD()
	
	ScoreBoard:SetRowHeight( 32 )

	ScoreBoard:SetAsBullshitTeam( TEAM_SPECTATOR )
	ScoreBoard:SetAsBullshitTeam( TEAM_CONNECTING )
	ScoreBoard:SetShowScoreboardHeaders( GAMEMODE.TeamBased )

	ScoreBoard:SetSkin( GAMEMODE.HudSkin )

	self:AddScoreboardAvatar( ScoreBoard )		// 1
	self:AddScoreboardWantsChange( ScoreBoard )	// 2
	self:AddScoreboardName( ScoreBoard )		// 3
	local f = function( ply ) return ply:Frags() end
	ScoreBoard:AddColumn( "Wins", 50, f, 0.5, nil, 6, 6 )
	local f = function( ply ) return tostring(ply.Height or 0).."%" end
	ScoreBoard:AddColumn( "Height", 50, f, 0.5, nil, 6, 6 )
	self:AddScoreboardPing( ScoreBoard )		// 6
		
	// Here we sort by these columns (and descending), in this order. You can define up to 4
	ScoreBoard:SetSortColumns( { 4, true, 5, false, 3, false } )

end

hook.Add("Think", "HeightCheck", function()
	for k, v in pairs(player.GetAll()) do
		if v.Jumper && IsValid(v.Jumper) then
			local a = v.Jumper:GetPos().z/(150*61)*100
			a = math.Round(math.Clamp(a,0,100))
			v.Height = a
		end
	end
end)
