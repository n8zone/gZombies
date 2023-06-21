local GM = GM or GAMEMODE
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_entity"

ENT.PrintName = "Weapon Hologram"
ENT.Category = "Generic's Zombies"

ENT.Spawnable = true

ENT.Price = 0

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "DisplayPrice")
end

if (SERVER) then
    function ENT:Initialize()

        self:SetModel("models/weapons/w_smg1.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
    
        local phys = self:GetPhysicsObject()
    
        if (phys:IsValid()) then
            phys:Wake()
        end
    
    end

    function ENT:UpdatePrice(p)
        self.Price = p
        self:SetDisplayPrice(self.Price)
    end

    function ENT:Use(activator, caller)
        -- get the parent entity
        local parent = self:GetParent()
        parent:Use(activator, caller)
    end

else
    function ENT:Draw()
        local color_green = Color(70,255,25,255)
        local color_red = Color(255,70,80,255)
        local color_display
        local priceToCheck = self:GetDisplayPrice()
        if(LocalPlayer():HasWeapon(self:GetParent().WeaponClass)) then priceToCheck = math.floor(priceToCheck / 2) end
        if(GM:CanAfford(priceToCheck)) then color_display = color_green else color_display = color_red end
        --create a dlight and set its color to green

        local dlight = DynamicLight(self:EntIndex())
        if (dlight) then
            dlight.pos = self:GetPos()
            dlight.r = color_display.r
            dlight.g = color_display.g
            dlight.b = color_display.b
            dlight.brightness = 1
            dlight.Decay = 1000
            dlight.Size = 100
            dlight.DieTime = CurTime() + 1
        end
        self:SetColor(color_display)
        self:SetMaterial("models/wireframe")
        self:DrawModel()
    end
end    