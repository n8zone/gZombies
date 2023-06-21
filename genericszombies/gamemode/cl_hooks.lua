local GM = GM or GAMEMODE
include("shared.lua")


surface.CreateFont( "ScoreFont", {
	font = "Arial", 
	size = 48,
	weight = 500,
	antialias = true,
	shadow = true,
} )

-- Disable default HUD
hook.Add( "HUDShouldDraw", "hide hud", function( name )
    if ( name == "CHudHealth" or name == "CHudBattery" ) then
        return false
    end
end )


hook.Add("HUDPaint", "HealthHUD", function()
    
    local ply = LocalPlayer()
    local hp = ply:Health()
    local maxhp = ply:GetMaxHealth()
    local scrw, scrh = ScrW(), ScrH()
    local boxW = scrw * 0.2
    local boxH = scrh * 0.05
    draw.SimpleText(tostring(GM:GetMyMoney()), "ScoreFont", scrw / 2, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    draw.SimpleText("WAVE : " .. tostring(GM:GetMyWave()), "ScoreFont", scrw / 100 + 5, scrh - 75, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
    surface.SetDrawColor(0, 0, 0, 145)
    surface.DrawRect(scrw / 2 - boxW / 2, scrh  - boxH * 1.1, boxW, boxH)
    local boxH = scrh * 0.04
    local boxW = scrw * 0.194
    surface.SetDrawColor(212, 25, 72, 145)
    surface.DrawRect(scrw / 2 - boxW / 2, scrh - boxH * 1.25, boxW, boxH - 1)

    surface.SetDrawColor(25, 212, 72, 145)
    surface.DrawRect(scrw / 2 - boxW / 2, scrh - boxH * 1.25, boxW * (hp / maxhp), boxH - 1)
end) 