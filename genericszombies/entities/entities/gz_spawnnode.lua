local GM = GM or GAMEMODE
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_entity"

ENT.PrintName = "Spawn Node"
ENT.Category = "Generic's Zombies"

ENT.Spawnable = false


if (SERVER) then
    function ENT:Initialize()
        print("Loaded Spawnpoint")
    end

    function ENT:SpawnZombie()
        local zombie = ents.Create("npc_zombie")
        --spawn a zombie npc
        zombie:SetPos(self:GetPos() + Vector(0,0,10))
        zombie:SetAngles(self:GetAngles())
        zombie:Spawn()
        zombie:SetNPCState(NPC_STATE_COMBAT)
        zombie:SetTarget(player.GetAll()[1])
        zombie:SetHealth(30)
        zombie:SetMaxHealth(30)
        zombie:SetModelScale(1, 0)
        zombie:SetEnemy(player.GetAll()[1])
        zombie:SetMaxLookDistance(7000)
        print(zombie:GetEnemy())

    end

end    