AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()

	phys:Wake()
end

function ENT:OnTakeDamage(dmg)
	self:Remove()
end

function ENT:Use(activator,caller)
	if self:GetModel() ~= "models/warz/consumables/painkillers.mdl" and self:GetModel() ~= "models/warz/consumables/medicine.mdl" and self:GetModel() ~= "models/warz/items/bandage.mdl" and self:GetModel() ~= "models/warz/items/medkit.mdl" then
		activator:SetSelfDarkRPVar("Energy", math.Clamp((activator:getDarkRPVar("Energy") or 100) + (self:GetTable().FoodEnergy or 1), 0, 100))
		if not activator:isArrested() then
			activator:SetRunSpeed( 240 )
		end	
		umsg.Start("AteFoodIcon", activator)
		umsg.End()
		local foodpos = self:GetPos()
		self:Remove()
		local trashbag = ents.Create( "prop_physics" )
		if ( !IsValid( trashbag ) ) then return end
		trashbag:SetModel( "models/props_junk/garbage_bag001a.mdl" )
		trashbag:SetPos( foodpos )
		trashbag:Spawn()
		--GAMEMODE:NotifyAll(2, 6, self:GetModel())
		if self:GetModel() ~= "models/props_junk/watermelon01.mdl" and self:GetModel() ~= "models/warz/consumables/bag_mre.mdl" and self:GetModel() ~= "models/props/cs_italy/bananna.mdl" and self:GetModel() ~= "models/props/cs_italy/bananna_bunch.mdl" and self:GetModel() ~= "models/props/cs_italy/orange.mdl" then
			activator:EmitSound("Drink.mp3", 100, 100)
		else
			activator:EmitSound("Eat.mp3", 100, 100)
		end	
	
	else
		local health = activator:Health()
		if self:GetModel() == "models/warz/consumables/painkillers.mdl" then
			activator:SetHealth( health + 25 ) 
			activator:EmitSound("usepills.wav", 100, 100)
			if activator:Health() > 100 then
				activator:SetHealth(100)
			end	
		end
		if self:GetModel() == "models/warz/consumables/medicine.mdl" then
			activator:SetHealth( health + 50 )
			activator:EmitSound("usepills.wav", 100, 100)
			if activator:Health() > 100 then
				activator:SetHealth(100)
			end	
		end	
		
		if self:GetModel() == "models/warz/items/bandage.mdl" then
			activator:SetHealth( health + 15 )
			activator:EmitSound("usemed.wav", 100, 100)
			if activator:Health() > 100 then
				activator:SetHealth(100)
			end	
		end	

		if self:GetModel() == "models/warz/items/medkit.mdl" then
			activator:SetHealth( health + 100 )
			activator:EmitSound("usemed.wav", 100, 100)
			if activator:Health() > 100 then
				activator:SetHealth(100)
			end	
		end
		
		umsg.Start("AteFoodIcon", activator)
		umsg.End()
		self:Remove()
		
	end	
end
