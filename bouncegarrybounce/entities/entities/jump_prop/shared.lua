ENT.Base 			= "base_anim"
ENT.Type 			= "anim"
ENT.Spawnable 		= false
ENT.AdminSpawnable 	= false

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:Think()
	if self:GetNWInt("Type") == 2 then
		local newpos = self:GetPos()
		newpos.x = math.sin((CurTime()+self:GetNWInt("RandomTime"))/(self:GetNWInt("RSpeed")/100))*250
		
		self.Entity:SetPos(newpos)
	end
	
	if self:GetNWInt("Type") == 3 then
		local newpos = self:GetPos()
		
		newpos.z = self:GetNWInt("ZPos")+(math.sin((CurTime()+self:GetNWInt("RandomTime"))/(self:GetNWInt("RSpeed")/100))*150)
		
		self.Entity:SetPos(newpos)
	end
end