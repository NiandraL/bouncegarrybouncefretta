include( "shared.lua" )

local matOutline = CreateMaterial( "BlackOutline", "UnlitGeneric", { [ "$basetexture" ] = "vgui/black" } )

function ENT:DrawTranslucent()

	self:DrawEntityOutline( 1.0 )
	self:Draw()

end

local ScaleNormal		= Vector()
local ScaleOutline2		= Vector() * 1.1
local matOutlineBlack 	= Material( "black_outline" )

function ENT:DrawEntityOutline( size )
	
	-- Don't know if I like it or not :|
	
	--[[
	size = size or 1.0
	render.SuppressEngineLighting( true )
	render.SetAmbientLight( 1, 1, 1 )
	render.SetColorModulation( 1, 1, 1 )
	
		// First Outline	
		self:SetModelScale( ScaleOutline2 * size )
		SetMaterialOverride( matOutlineBlack )
		self:DrawModel()
		
		// Revert everything back to how it should be
		SetMaterialOverride( nil )
		self:SetModelScale( ScaleNormal )
		
	render.SuppressEngineLighting( false )
	
	local r, g, b = self:GetColor()
	render.SetColorModulation( r/255, g/255, b/255 )
	]]--
	
end
