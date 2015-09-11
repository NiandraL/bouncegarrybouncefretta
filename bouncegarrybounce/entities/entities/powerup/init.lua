AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )


function ENT:Initialize()

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
end

local Boom = Sound("")

function ENT:StartTouch(ent)
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart( vPoint )
	effectdata:SetOrigin( vPoint )
	effectdata:SetScale( 1 )
	util.Effect( "HelicopterMegaBomb", effectdata )	
	
	ent.Owner:SendLua([[surface.PlaySound("/weapons/explode3.wav")]])

	ent.Owner:SendLua([[GAMEMODE.CurNotify = "*boom*"]])
	timer.Simple(1, function() ent.Owner:SendLua([[GAMEMODE.CurNotify = false]]) end)

	--self:Remove()
end