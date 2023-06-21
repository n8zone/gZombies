local GM = GM or GAMEMODE
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_hooks.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
include("sv_hooks.lua")

util.AddNetworkString("moneyUpdatedServer")
util.AddNetworkString("waveUpdatedServer")

GM.PlayerInventoryData = GM.PlayerInventoryData or {}
GM.EnemyCount = 0
GM.AlivePlayerCount = 0
GM.Wave = 1

GM.Spectators = {}
 
function GM:NotifyPlayers(message)
    for k, v in pairs(player.GetAll()) do
        v:ChatPrint(message)
    end
end

function GM:InitializePlayerTable(ply)
    GAMEMODE.PlayerInventoryData[ply] = { ["money"] = 0 }
end

function GM:CleanPlayerTable(ply)
    GAMEMODE:UpdateMoney(ply, -GM:GetMoney(ply))
end

function GM:GetMoney(ply)
    return GAMEMODE.PlayerInventoryData[ply:GetName()]["money"]
end

function GM:PlayerSpawn( ply, transition )

    ply:SetModel("models/player/swat.mdl")
    ply:Give("weapon_crowbar")
    if(transition) then
        print("test")
        ply:SetPos(Vector(0,0,0))
        GAMEMODE:InitializePlayerTable(ply:GetName())
    end


end

function GM:DisplayWave()
    net.Start("waveUpdatedServer")
    net.WriteUInt(GAMEMODE.Wave, 32)
    net.Broadcast()
end

function GM:PlayerConnect(name, ip)
    key = name
    GAMEMODE:InitializePlayerTable(key)
    GAMEMODE:DisplayWave()
end
 
function GM:UpdateMoney(ply, amt)
    curMoney = GAMEMODE.PlayerInventoryData[ply:GetName()]["money"]
    GAMEMODE.PlayerInventoryData[ply:GetName()]["money"] = curMoney + amt
    net.Start("moneyUpdatedServer")
    net.WriteUInt(self:GetMoney(ply), 32)
    net.Send(ply)
end

function GM:PurchaseWeapon(ply, weaponData, price)
    PrintTable(weaponData)
    local weapon = weaponData[1]
    local ammo = weaponData[2]
    local ammoCount = weaponData[3]
    if(!ply:IsPlayer()) then return end
    print(ply:GetName())
    PrintTable(GAMEMODE.PlayerInventoryData)
    if(self:GetMoney(ply) >= price) then
        local wep = ply:Give(weapon, false)
        self:UpdateMoney(ply, -price)
        ply:GiveAmmo(ammoCount, ammo)
    end
end

function GM:RespawnSpectators()
    for _, ply in ipairs(GAMEMODE.Spectators) do
        print(ply)
        ply:UnSpectate()
        timer.Simple(0.5, function() ply:Spawn() end)
    end
    GAMEMODE.Spectators = {}
end

function GM:BeginGame()
    GAMEMODE:RespawnSpectators()
    timer.Simple(10, function() GAMEMODE:BeginWave() end)
end

function GM:BeginWave()
    GAMEMODE.Spectators = {}
    game.CleanUpMap()
    print("Wave Started")
    GAMEMODE.AlivePlayerCount = #player.GetAll()
    print(GAMEMODE.AlivePlayerCount)
    GAMEMODE.EnemyCount = (GAMEMODE.Wave * 10) - 5
    GAMEMODE:SpawnEnemies(GAMEMODE.EnemyCount)
    GAMEMODE:NotifyPlayers("Wave " .. GAMEMODE.Wave .. " has begun!")
    GAMEMODE:DisplayWave()
    
end

function GM:EndWave(silent)
    timer.Remove("spawnTimer")
    if(!silent) then GAMEMODE:NotifyPlayers("Wave " .. GAMEMODE.Wave .. " has ended!") end
    GAMEMODE.Wave = GAMEMODE.Wave + 1
    GAMEMODE:DisplayWave()
    
end

function GM:EndGame()
    print("Game Over!")
    GAMEMODE:EndWave()
    GAMEMODE.Wave = 1
    GAMEMODE:DisplayWave(true)

    for k,v in ipairs(ents.FindByClass("npc_*")) do
        v:Remove()
    end

    for k,v in ipairs(player.GetAll()) do
        GAMEMODE:CleanPlayerTable(v)
    end
    timer.Simple(6, function() game.CleanUpMap() end)
    --timer.Simple(12, function() GAMEMODE.BeginGame() end)
end

function GM:SpawnEnemies(count)
    print(count)
    if(count <= 0) then return end
    timer.Create("spawnTimer", 6 + math.floor(GAMEMODE.Wave / 4), 1, function() -- creates a spawn timer, every 6 seconds it will run the following code
        for k, v in pairs(ents.FindByClass("gz_spawnnode")) do   
            local rand = math.random()
            --if the random number is less than 0.6, spawn a zombie
            if(rand < 0.6 and count > 0) then
                local enemy = v:SpawnZombie()
                count = count - 1
            end
        end
        GAMEMODE:SpawnEnemies(count) -- recursively call the function
    end)

end
 
function GM:OnKillEnemy()
    GAMEMODE.EnemyCount = GAMEMODE.EnemyCount - 1
    if(GAMEMODE.EnemyCount <= 0) then
        GAMEMODE:EndWave()
        GAMEMODE:RespawnSpectators()
    end
end

function GM:HealPlayer(ply)
    ply:SetHealth(ply:Health() + 1)
    if(ply:Health() > 100) then ply:SetHealth(100) end
end

function GM:HandlePlayerDeath(ply)
    ply:Spawn()
    ply:Spectate(5)
    ply:SpectateEntity(player.GetAll()[1])
    table.insert(GAMEMODE.Spectators, ply)
    GAMEMODE.AlivePlayerCount = GAMEMODE.AlivePlayerCount - 1
    if(GAMEMODE.AlivePlayerCount <= 0) then 
        print("All players died!") 
        GAMEMODE:EndGame()
    end
end

