AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include ("shared.lua")

function ENT:Initialize()

    self:SetModel("models/props_combine/breenconsole.mdl")
    self:PhysicsInit(SOLID_NONE)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()

    if (phys:IsValid()) then
        phys:Wake()
    end

    -- create a gz hologram
    local weapon_hologram = ents.Create("gz_hologram")

    local offset = self:GetForward() * 0 + self:GetUp() * 47.5 + self:GetRight() * 5
    print(offset)
    weapon_hologram:SetPos(self:GetPos() + offset)
    weapon_hologram:SetAngles(self:GetAngles() + Angle(0, 0, -45))
    weapon_hologram:Spawn()
    weapon_hologram:SetParent(self)
    weapon_hologram:SetModel("models/weapons/w_smg1.mdl")


end

function ENT:Use(activator, caller)
    if activator:IsPlayer() then
        print("Heyo!")
        hook.Run("WeaponPurchased", activator, "weapon_smg1", 20)
    end
end

