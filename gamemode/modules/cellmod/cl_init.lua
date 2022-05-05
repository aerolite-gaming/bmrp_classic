/*                                      | * FILE: cl_init.lua
                  ______                |
                  |    |                | * AUTHOR: Blt950
                  |    |                | * AUTHOR WEBSIDE: http://blt950.com
                  |    |                |
        ________________                | * PRODUCT LICENSED: http://creativecommons.org/licenses/by-nd/3.0/
        |  __________  |                | By using this product, you agree to follow the license limitations.
        | |  CellMod | |                | Got any questions, contact author.
        | |   v1.2   | |                |
        | |          | |                | * FACEPUNCH THREAD: http://www.facepunch.com/threads/1131388
        | |__________| |                |
        |              |                |
        |  1   2   3   |                |
        |  4   5   6   |                |
        |  7   8   9   |                |
        |  *   0   #   |                |
        ________________                |
                                    	|
										|
________________________________________|____________________________________________________________________________________
*/

local CM = { }

include("shared.lua")

util.PrecacheSound("cellmod/text_message.wav")
util.PrecacheSound("cellmod/cell_ringtone.wav")
util.PrecacheSound("cellmod/dialring.wav")

local MyOperator

/* -------------------------------------------- */
/* -------------------------------------------------- */
/* ------------ FUNCTIONS/USERMESSAGES -------------- */
/* -------------------------------------------------- */
/* -------------------------------------------- */

local function SendColoredText(um)
	local r = um:ReadShort()
    local g = um:ReadShort()
    local b = um:ReadShort()
    local color = Color( r, g, b )
    local text = um:ReadString()
     
    chat.AddText( color, text )
end
usermessage.Hook( "CM.SendColoredText", SendColoredText)

function SetOperator(um)
    MyOperator = um:ReadString()
	if MyOperator == "nil" then
		MyOperator = nil
	end
end
usermessage.Hook( "CM.SetOperator", SetOperator)

/* -------------------------------------------- */
/* -------------------------------------------------- */
/* ----------------- DIAL SOUND --------------------- */
/* -------------------------------------------------- */
/* -------------------------------------------- */

function DialSound()
	if LocalPlayer():IsPlayer() then
		if LocalPlayer():GetNWInt("cm_called") == 3 then
			surface.PlaySound('cellmod/dialring.wav')
		end
	end
end
timer.Create( "DialSound", 3.5, 0, DialSound)

/* -------------------------------------------- */
/* -------------------------------------------------- */
/* ------------------- HUD PAINT -------------------- */
/* -------------------------------------------------- */
/* -------------------------------------------- */

local callwarn_alpha = 0
local callwarn_b = false
surface.CreateFont("OperatorFont", { size = ScreenScale( 6 ), weight = 400, font = "UiBold" } )
surface.CreateFont("CallFont", { size = ScreenScale( 5 ), weight = 400, font = "UiBold" } )

local icons = {}
icons["gui/cellmod/transmit_blue"] = Material("icon16/transmit_blue.png")
icons["gui/cellmod/transmit_error"] = Material("icon16/cross.png")
icons["gui/cellmod/transmit"] = Material("icon16/transmit.png")
icons["gui/cellmod/check_off"] = Material("icon16/cross.png")

function CM.HUDPaint()

	if FAdmin.ScoreBoard.Visible ~= true and LocalPlayer():Alive() ~= false and MyOperator ~= nil then
	
	draw.RoundedBox(4, ScrW()-130, ScrH()-120, 110,90, Color(0, 0, 0, 220) )

	local bars
	local icon = ""
	local operator = MyOperator
	local operator_color
	
	if MyOperator == nil then
		icon = "gui/cellmod/check_off"
		surface.SetTextColor( 255,0,0,255 )
		operator = "Insert SIM"
		bars = 0
	else
		local Signal = LocalPlayer().DarkRPVars.CMsignal
		if Signal == 4 then
			icon = "gui/cellmod/transmit_blue"
			surface.SetTextColor( 255,255,255,255 )
			bars = 4
		elseif Signal == 3 then
			icon = "gui/cellmod/transmit_blue"
			surface.SetTextColor( 255,255,255,255 )
			bars = 3
		elseif Signal == 2 then
			icon = "gui/cellmod/transmit_blue"
			surface.SetTextColor( 255,255,255,255 )
			bars = 2
		elseif Signal == 1 then
			icon = "gui/cellmod/transmit"
			surface.SetTextColor( 255,255,255,255 )
			bars = 1
		elseif Signal == 0 then
			icon = "gui/cellmod/check_off"
			surface.SetTextColor( 255,0,0,255 )
			operator = "No Signal"
			bars = 0
		elseif MyOperator == nil then
			icon = "gui/cellmod/transmit_error"
			surface.SetTextColor( 255,0,0,255 )
			operator = "Insert Simcard"
			bars = 0
		end
	end
	
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( icons[icon] )
	surface.DrawTexturedRect( ScrW()-120, ScrH()-112.5, 16, 16 )
	
	surface.SetTextPos( ScrW()-99, ScrH()-115 )
	surface.SetFont("OperatorFont")
	surface.DrawText( operator )

	
	if bars == 0 then
		draw.RoundedBox(4, ScrW()-100, ScrH()-70, 10, 20, Color(10, 10, 10, 255) )
		draw.RoundedBox(4, ScrW()-86, ScrH()-70-5, 10, 25, Color(10, 10, 10, 255) )
		draw.RoundedBox(4, ScrW()-72, ScrH()-70-10, 10, 30, Color(10, 10, 10, 255) )
		draw.RoundedBox(4, ScrW()-58, ScrH()-70-15, 10, 35, Color(10, 10, 10, 255) )
	elseif bars == 1 then
		draw.RoundedBox(4, ScrW()-100, ScrH()-70, 10, 20, Color(255, 255, 255, 255) )
		draw.RoundedBox(4, ScrW()-86, ScrH()-70-5, 10, 25, Color(10, 10, 10, 255) )
		draw.RoundedBox(4, ScrW()-72, ScrH()-70-10, 10, 30, Color(10, 10, 10, 255) )
		draw.RoundedBox(4, ScrW()-58, ScrH()-70-15, 10, 35, Color(10, 10, 10, 255) )
	elseif bars == 2 then
		draw.RoundedBox(4, ScrW()-100, ScrH()-70, 10, 20, Color(255, 255, 255, 255) )
		draw.RoundedBox(4, ScrW()-86, ScrH()-70-5, 10, 25, Color(255, 255, 255, 255) )
		draw.RoundedBox(4, ScrW()-72, ScrH()-70-10, 10, 30, Color(10, 10, 10, 255) )
		draw.RoundedBox(4, ScrW()-58, ScrH()-70-15, 10, 35, Color(10, 10, 10, 255) )
	elseif bars == 3 then
		draw.RoundedBox(4, ScrW()-100, ScrH()-70, 10, 20, Color(255, 255, 255, 255) )
		draw.RoundedBox(4, ScrW()-86, ScrH()-70-5, 10, 25, Color(255, 255, 255, 255) )
		draw.RoundedBox(4, ScrW()-72, ScrH()-70-10, 10, 30, Color(255, 255, 255, 255) )
		draw.RoundedBox(4, ScrW()-58, ScrH()-70-15, 10, 35, Color(10, 10, 10, 255) )
	elseif bars == 4 then
		draw.RoundedBox(4, ScrW()-100, ScrH()-70, 10, 20, Color(255, 255, 255, 255) )
		draw.RoundedBox(4, ScrW()-86, ScrH()-70-5, 10, 25, Color(255, 255, 255, 255) )
		draw.RoundedBox(4, ScrW()-72, ScrH()-70-10, 10, 30, Color(255, 255, 255, 255) )
		draw.RoundedBox(4, ScrW()-58, ScrH()-70-15, 10, 35, Color(255, 255, 255, 255) )
	end
	
	// Call warning
	local CallText
	local X, Y
	local cR, cG, cB
	local Called = LocalPlayer():GetNWInt("cm_called")
	
	if Called == 1 then CallText = "Incomming Call" cR = 0 cG = 255 cB = 0 X = ScrW()-100 Y = ScrH()-15 end
	if Called == 2 then CallText = "Active Conversation" cR = 0 cG = 200 cB = 242 X = ScrW()-100 Y = ScrH()-15 end
	if Called == 3 then CallText = "Dialing....." cR = 255 cG = 255 cB = 0 X = ScrW()-95 Y = ScrH()-15 end
	
	if Called > 0 and Called < 4 then
		if callwarn_alpha <= 255 and callwarn_b == false then
			callwarn_alpha = math.Approach(callwarn_alpha, 255, 2.5)
			if callwarn_alpha == 255 then callwarn_b = true end
		elseif callwarn_alpha >= 0 and callwarn_b == true then
			callwarn_alpha = math.Approach(callwarn_alpha, 0, 2.5)
			if callwarn_alpha == 0 then callwarn_b = false end
		end
		surface.SetTextColor( cR, cG, cB,callwarn_alpha )
		surface.SetTextPos( X, Y )
		surface.SetFont("CallFont")
		surface.DrawText( CallText )
	end
else return end
	
end
hook.Add("HUDPaint", "CM.HUDPaint", CM.HUDPaint)

/* -------------------------------------------- */
/* -------------------------------------------------- */
/* -------------------COMPANY MENU ------------------ */
/* -------------------------------------------------- */
/* -------------------------------------------- */

function CharacterMenu()

	local Window = vgui.Create("DFrame")
	Window:SetSize(270, 290)
	Window:Center()
	Window:SetTitle("Setup your Cell Company")
	Window:SetSizable(true)
	Window:SetDeleteOnClose(false)
	Window:MakePopup()
	Window:SetBackgroundBlur( false )
	Window:SetDraggable( false )
	Window:ShowCloseButton( false )
	
	local Panel = vgui.Create("DPanel", Window)
	Panel:SetSize(240, 270)
	Panel:SetPos(5, 25)
	Panel.Paint = function() 
		surface.SetDrawColor( 25, 25, 25, 0 ) 
		surface.DrawRect( 0, 0, Panel:GetWide(), Panel:GetTall() )
	end
	
	local WelcomeLabel = vgui.Create("DLabel", Window)
	WelcomeLabel:SetPos(65, 50)
	WelcomeLabel:SetText("Hello new Mobile Operator!")
	WelcomeLabel:SizeToContents()
	
	local WelcomeLabel2 = vgui.Create("DLabel", Window)
	WelcomeLabel2:SetPos(25, 70)
	WelcomeLabel2:SetText("Please set the prices below for your company.")
	WelcomeLabel2:SizeToContents()
	
	local CName, CCPrice, CTPrice
	
	local CompanyName = vgui.Create("DTextEntry", Window)
	CompanyName:SetSize(180, 20)
	CompanyName:SetPos(40, 105)
	CompanyName:SetText("Enter Company Name")
	CompanyName.OnMousePressed = function()
		CompanyName:SetText("")
	end
	CompanyName.Think = function()
		CName = CompanyName:GetValue()
	end
	
	local MaxCharLabel = vgui.Create("DLabel", Window)
	MaxCharLabel:SetPos(70, 135)
	MaxCharLabel:SetText("Maximum 9 characters")
	MaxCharLabel:SizeToContents()
	
	local CompanyCallPrice = vgui.Create( "DNumSlider", Window )
    CompanyCallPrice:SetSize( 175, 40 )
    CompanyCallPrice:SetText( "Call Price p/min" )
    CompanyCallPrice:SetPos(45, 155)
    CompanyCallPrice:SetMin( 1 )
    CompanyCallPrice:SetMax( 100 )
    CompanyCallPrice:SetDecimals( 0 )
	
	local CompanyTextPrice = vgui.Create( "DNumSlider", Window )
    CompanyTextPrice:SetSize( 175, 40 )
    CompanyTextPrice:SetText( "Text/SMS Price" )
    CompanyTextPrice:SetPos(45, 195)
    CompanyTextPrice:SetMin( 1 )
    CompanyTextPrice:SetMax( 50 )
    CompanyTextPrice:SetDecimals( 0 )
	
	local CreateButton = vgui.Create("DButton", Window)
	CreateButton:SetSize(100,35)
	CreateButton:SetText("Create")
	CreateButton:SetPos(Window:GetWide()/2-(100/2), Window:GetTall()/1.20)
	CreateButton.DoClick = function()
		if string.len(CName) < 10 and string.len(CName) > 0 and 
		CompanyCallPrice:GetValue() > 0 and CompanyCallPrice:GetValue() <= 100 and 
		CompanyTextPrice:GetValue() > 0 and CompanyTextPrice:GetValue() <= 50 then
			Window:SetVisible(false)
			LocalPlayer():ConCommand("cm_companyconfig "..CName.." "..LocalPlayer():UserID().." "..CompanyCallPrice:GetValue().." "..CompanyTextPrice:GetValue())
		end
	end
	
	Window:SetSkin("DarkRP")
end
concommand.Add( "cm_companyconfigwindow", CharacterMenu ) 

/* -------------------------------------------- */
/* -------------------------------------------------- */
/* --------------- HELP VGUI ADD -------------------- */
/* -------------------------------------------------- */
/* -------------------------------------------- */

local HELP_CATEGORY_CELLMOD = 7
/*GM:AddHelpCategory(HELP_CATEGORY_CELLMOD, "CellMod")

GM:AddHelpLabel( HELP_CATEGORY_CELLMOD, "/call <name> - Call a person")
GM:AddHelpLabel( HELP_CATEGORY_CELLMOD, "/pikcup - Pickup an incomming call")
GM:AddHelpLabel( HELP_CATEGORY_CELLMOD, "/hangup - Hangup an incomming/outgoing or active conversation.")
GM:AddHelpLabel( HELP_CATEGORY_CELLMOD, "/t <text> - Talk in the phones, to the active conversation.")
GM:AddHelpLabel( HELP_CATEGORY_CELLMOD, "/sms or /text <name> <text> - Send a text message to the specified player.")
GM:AddHelpLabel( HELP_CATEGORY_CELLMOD, "/givesim - Give your company SIMcard to the player.")
GM:AddHelpLabel( HELP_CATEGORY_CELLMOD, "/acceptsim - Accept your last SIMcard offer.")*/