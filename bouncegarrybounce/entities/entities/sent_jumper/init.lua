AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )


// This is the spawn function. It's called when a client calls the entity to be spawned.
// If you want to make your SENT spawnable you need one of these functions to properly create the entity
//
// ply is the name of the player that is spawning it
// tr is the trace from the player's eyes 
//
function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	
	local ent = ents.Create( "sent_jumper" )
		ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	
	return ent
	
end


/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	// Use the helibomb model just for the shadow (because it's about the same size)
	self.Entity:SetModel( "models/Combine_Helicopter/helicopter_bomb01.mdl" )
	
	// Don't use the model's physics - create a sphere instead
	self.Entity:PhysicsInitSphere( 16, "metal_bouncy" )
	
	// Wake the physics object up. It's time to have fun!
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	
	// Set collision bounds exactly
	self.Entity:SetCollisionBounds( Vector( -16, -16, -16 ), Vector( 16, 16, 16 ) )
	
end


/*---------------------------------------------------------
   Name: PhysicsCollide
---------------------------------------------------------*/
function ENT:PhysicsCollide( data, physobj )

	if not self.Owner:IsValid() then return end
	
	if math.random(1, 2) == 1 then
		self.Owner:SendLua([[surface.PlaySound("physics/rubber/rubber_tire_impact_bullet"..math.random(1, 3)..".wav")]])
	else
		self.Owner:SendLua([[surface.PlaySound("physics/rubber/rubber_tire_impact_hard"..math.random(1, 3)..".wav")]])
	end
	
	local NewVelocity = Vector(0, 0, 490)
	
	if data.HitEntity:GetClass() == "powerup" then
		NewVelocity = Vector(0, 0, 1200)
	end
	
	if physobj:GetVelocity().z < 0 then
		NewVelocity = Vector(0, 0, -50)
	end
	
	physobj:SetVelocity( NewVelocity )
	
end