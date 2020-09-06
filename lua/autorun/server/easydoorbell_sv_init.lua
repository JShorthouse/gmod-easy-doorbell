--------------------------------------------------------------------------------
--  Easy Doorbell Serverside Init
--------------------------------------------------------------------------------

CreateConVar( 'sbox_maxeasydoorbell_buttons', 3 )
CreateConVar( 'sbox_maxeasydoorbell_speakers', 3 )

include( "easydoorbell/sh_init.lua" )
include( "easydoorbell/sv_util.lua" )
include( "easydoorbell/sv_config_loader.lua" )
include( "easydoorbell/sv_entity_creation.lua" )
include( "easydoorbell/sv_commands.lua" )
include( "easydoorbell/sv_linking.lua" )
include( "easydoorbell/sh_tool_functions.lua" )
include( "easydoorbell/sv_perm_entities.lua" )
include( "easydoorbell/sv_perm_data_io.lua" )

AddCSLuaFile( "easydoorbell/sh_init.lua" )
AddCSLuaFile( "easydoorbell/cl_permmenu.lua" )
AddCSLuaFile( "easydoorbell/sh_tool_functions.lua" )

--Add workshop clientside content (models/sounds)
resource.AddWorkshop( "974112622" )

util.AddNetworkString( "EasyDoorbellCreatePermButton" )
util.AddNetworkString( "EasyDoorbellUpdatePermButton" )
util.AddNetworkString( "EasyDoorbellCreatePermSpeaker" )
util.AddNetworkString( "EasyDoorbellUpdatePermSpeaker" )
util.AddNetworkString( "EasyDoorbellDeletePermEntity" )
util.AddNetworkString( "EasyDoorbellSavePermSettings" )
util.AddNetworkString( "EasyDoorbellFormattedMessage" )
util.AddNetworkString( "EasyDoorbellOpenPermMenu" )

--Stop people pocketing doorbells
hook.Add( "canPocket", "disableEasyDoorbellPocketing", function( ply, ent )
  local class = ent:GetClass()
  if ent:IsValid() and class == "easydoorbell_button" or
    class == "easydoorbell_speaker"
  then
    return false, DarkRP.getPhrase( "cannot_pocket_x" )
  end
end)
