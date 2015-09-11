include( "shared.lua" )

--local fuelicon = Material("gui/silkicons/bomb")

function ENT:Draw()
		self:DrawModel()

		--render.SetMaterial(fuelicon)
		--render.DrawSprite( self:GetPos(), 16, 16, Color(255, 255, 255, 255))
end
