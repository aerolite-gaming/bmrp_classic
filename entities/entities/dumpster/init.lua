AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_junk/TrashDumpster01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:CPPISetOwner(self:Getowning_ent())
	local phys = self:GetPhysicsObject()

	phys:Wake()

	self.damage = 1500
end

function ENT:Touch( hitEnt )
 	local dumpstersounds = {"doors/vent_open1.wav", "doors/vent_open2.wav", "doors/vent_open3.wav"}
	if ( hitEnt:IsValid() and hitEnt:GetModel() == "models/props_junk/garbage_bag001a.mdl" ) then
 		hitEnt:Remove()
		self:EmitSound(table.Random(dumpstersounds), 60, 100)
	end
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

function ENT:OnRemove()
	timer.Destroy(self:EntIndex())
	local ply = self:Getowning_ent()
	if not IsValid(ply) then return end
end