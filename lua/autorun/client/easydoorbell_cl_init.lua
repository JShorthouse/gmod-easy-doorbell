--------------------------------------------------------------------------------
-- Easy Doorbell Clientside Init
--------------------------------------------------------------------------------

include( "easydoorbell/sh_init.lua" )
include( "easydoorbell/cl_permmenu.lua" )
include( "easydoorbell/sh_tool_functions.lua" )

CreateClientConVar( "easydoorbell_placebutton_model", "models/easydoorbell/buttonbasic.mdl", false, true, "" )
CreateClientConVar( "easydoorbell_placebutton_cooldown", "0.0", false, true, "" )
CreateClientConVar( "easydoorbell_placebutton_speakerid", "0", false, true, "" )
CreateClientConVar( "easydoorbell_placespeaker_model", "models/easydoorbell/speakerbell.mdl", false, true, "" )
CreateClientConVar( "easydoorbell_placespeaker_sound", "easydoorbell/standard.wav", false, true, "" )
CreateClientConVar( "easydoorbell_placespeaker_volume", "1.0", false, true, "" )

--------------------------------------------------------------------------------
-- Recieve config values from server
--------------------------------------------------------------------------------
net.Receive( "EasyDoorbellTransferConfig", function()
  EasyDoorbell.Config = net.ReadTable()
end )

--------------------------------------------------------------------------------
-- Recieve a string with "l[index]" as placeholders for language strings.
--  Replace these strings with the client's translations and add the string
--  to the chatbox with the given color.
--------------------------------------------------------------------------------
net.Receive( "EasyDoorbellFormattedMessage", function()
  local color = net.ReadColor()
  local message = net.ReadString()
  local replacements = net.ReadTable()

  for k, v in ipairs( replacements ) do
    local translated = language.GetPhrase( v )
    message = string.gsub( message, "l" .. k, translated )
  end
  chat.AddText( color, message )
end )
