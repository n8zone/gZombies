local GM = GM or GAMEMODE


hook.Add("OnNPCKilled", "CashRewardOnZombieDeath", function(npc, attacker, inflictor)
    if(npc:Classify() == 19) then 
        GM:UpdateMoney(attacker, 10)
        GM:OnKillEnemy()
    end
end)


hook.Add("WeaponPurchased", "PlayerPurchasedWeapon", function(ply, weapon, price)
    GM:PurchaseWeapon(ply, weapon, price)
end)

hook.Add("EntityTakeDamage", "PlayerDamaged", function(ply, dmg)
    if(ply:IsPlayer()) then
        dmg:SetDamage(dmg:GetDamage() * 2)
        ply:SetNWInt("nextHealTime", CurTime() + 8)
    end
end)

hook.Add("PlayerDeath", "PlayerWasKilled", function(ply, inflictor, attacker)
    print(ply)
    print(inflictor)
    GM:HandlePlayerDeath(ply)
end)

hook.Add("PlayerDeathThink", "shouldRespawn", function(ply)
    return false
end)
 
hook.Add("Think", "SetZombieEnemy", function()
    local zombies = ents.FindByClass("npc_zombie")
    local fast_zombies = ents.FindByClass("npc_fastzombie")
    for k, v in pairs(fast_zombies) do
        table.insert(zombies, v)
    end

    for k, v in pairs(zombies) do
        if(!IsValid(v:GetEnemy())) then
            v:SetEnemy(player.GetAll()[1])
            v:UpdateEnemyMemory(player.GetAll()[1], player.GetAll()[1]:GetPos())
        end
    end -- just set it to first player for now :D
end)
   
hook.Add("Think", "HealPlayer", function()
    for k,v in pairs(player.GetAll()) do
        if(v:GetNWInt("nextHealTime", 0) <= CurTime() and v:Health() < v:GetMaxHealth()) then
            GM:HealPlayer(v)
        end
    end
end)

print("HOOKS LOADED SUCCESSFULLY")