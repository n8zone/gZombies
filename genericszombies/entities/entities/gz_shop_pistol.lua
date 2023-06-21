local GM = GM or GAMEMODE

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "gz_shop_base"

ENT.PrintName = "Pistol Shop"
ENT.Category = "Generic's Zombies"

ENT.Spawnable = true

ENT.WeaponClass = "weapon_pistol"
ENT.WeaponModel = "models/weapons/w_pistol.mdl"
ENT.WeaponAmmo = "Pistol"
ENT.ammoAmount = 25
ENT.WeaponPrice = 20