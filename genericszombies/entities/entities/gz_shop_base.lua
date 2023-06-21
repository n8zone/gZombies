local GM = GM or GAMEMODE

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_entity"

ENT.PrintName = "SMG Shop"
ENT.Category = "Generic's Zombies"

ENT.Spawnable = true

ENT.WeaponClass = "weapon_weapon"
ENT.WeaponModel = "model.mdl"
ENT.WeaponAmmo = "ammo"
ENT.ammoAmount = 0
ENT.WeaponPrice = 0


if(SERVER) then 
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
        weapon_hologram:SetModel(self.WeaponModel)
        weapon_hologram:UpdatePrice(self.WeaponPrice)
        print(weapon_hologram.Price)
    
    
    end
    
    function ENT:Use(activator, caller)
        if activator:IsPlayer() then
            local dataTable = {self.WeaponClass, self.WeaponAmmo, self.ammoAmount}
            local charge = self.WeaponPrice
            -- check if player already has weapon
            if activator:HasWeapon(self.WeaponClass) then
                activator:ChatPrint("Purchased ammo!")
                charge = math.floor(charge / 2)
            end
            print(self.ammoAmount)
            hook.Run("WeaponPurchased", activator, dataTable, charge)
        end
    end
else
    function ENT:Draw()
        self:DrawModel()
    end
end    