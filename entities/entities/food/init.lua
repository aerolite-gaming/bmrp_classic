AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_junk/garbage_takeoutcarton001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()

	phys:Wake()

	self.damage = 10
end

function ENT:OnTakeDamage(dmg)
	self.damage = self.damage - dmg:GetDamage()

	if (self.damage <= 0) then
		local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetMagnitude(2)
		effectdata:SetScale(2)
		effectdata:SetRadius(3)
		util.Effect("Sparks", effectdata)
		self:Remove()
	end
end

function ENT:Use(activator,caller)
	caller:SetSelfDarkRPVar("Energy", math.Clamp((caller:getDarkRPVar("Energy") or 0) + 100, 0, 100))
	umsg.Start("AteFoodIcon", caller)
	umsg.End()
	
	activator:EmitSound("Eat.mp3", 100, 100)
	
	if not activator:isArrested() then
		activator:SetRunSpeed( 240 )
	end	
	
	local foodpos = self:GetPos()
	self:Remove()
	local trashbag = ents.Create( "prop_physics" )
	if ( !IsValid( trashbag ) ) then return end
	trashbag:SetModel( "models/props_junk/garbage_bag001a.mdl" )
	trashbag:SetPos( foodpos )
	trashbag:Spawn()
end

function ENT:OnRemove()
	local ply = self:Getowning_ent()
	ply.maxFoods = ply.maxFoods and ply.maxFoods - 1 or 0
end