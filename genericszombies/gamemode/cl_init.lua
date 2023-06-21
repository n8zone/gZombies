local GM = GM or GAMEMODE
include("shared.lua")
include("cl_hooks.lua")

local myMoney = 0
local myWave = 1

function GM:CanAfford(price)
    return myMoney >= price
end

function GM:GetMyMoney()
    return myMoney
end

function GM:GetMyWave()
    return myWave
end


net.Receive("moneyUpdatedServer", function()
    newMoney = net.ReadUInt(32)
    myMoney = newMoney
end)


net.Receive("waveUpdatedServer", function()
    newWave = net.ReadUInt(32)
    myWave = newWave
end)