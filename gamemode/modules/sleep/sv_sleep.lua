KnockoutTime = 5

local function ResetKnockouts(player)
	player.SleepRagdoll = nil
	player.KnockoutTimer = 0
end
hook.Add("PlayerSpawn", "Knockout", ResetKnockouts)



--AddChatCommand("/sleep", KnockoutToggle)
--AddChatCommand("/wake", KnockoutToggle)
--AddChatCommand("/wakeup", KnockoutToggle)

hook.Add("OnPlayerChangedTeam", "SleepMod", function(ply)
	if ply.Sleeping then
		KnockoutToggle(ply, "force")
	end
end)

local function DamageSleepers(ent, dmginfo)
	local inflictor = dmginfo:GetInflictor()
	local attacker = dmginfo:GetAttacker()
	local amount = dmginfo:GetDamage()

	local ownerint = ent.OwnerINT
	if ownerint and ownerint ~= 0 then
		for k,v in pairs(player.GetAll()) do
			if v:EntIndex() == ownerint then
				if attacker == game.GetWorld() then
					amount = 10
					dmginfo:ScaleDamage(0.1)
				end
				v:SetHealth(v:Health() - amount)
				if v:Health() <= 0 and v:Alive() then
					v:Spawn()
					v:UnSpectate()
					v:SetPos(ent:GetPos())
					v:SetHealth(1)
					v:TakeDamage(1, inflictor, attacker)
					if v.SleepSound then
						v.SleepSound:Stop()
					end
					ent:Remove()
				end
			end
		end
	end
end
--hook.Add("EntityTakeDamage", "Sleepdamage", DamageSleepers)
