--------------------------------------------------------------------------------
-- Easy Doorbell Commands
-- Processing of chat commands
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Given a player and a command, find the entity that they are looking at and
--  open the corresponding menu if they have permission
-- Also display the version number of a list of commands for "about" or an
--  invalid command respectively
--------------------------------------------------------------------------------
local function ProcessCommands( ply, text )
  if not ( string.sub( text, 1, 5 ) == "/edb " or string.sub( text, 1) == "/edb" )
  then
    return
  end

  local arg = string.sub( text, 6 ) --Substring from after "/edb " to end of string
  if arg == "perm" then
    if not EasyDoorbell.CheckPermission( ply ) then return "" end;

    local ent = ply:GetEyeTrace().Entity

    if ent:GetClass() ~= "easydoorbell_button" and ent:GetClass() ~= "easydoorbell_speaker" then
      --Open menu to create new entity
      net.Start( "EasyDoorbellOpenPermMenu" )
        net.WriteString( "" )
        net.WriteString( "" )
      net.Send( ply )

    elseif ent.permID == nil then
      EasyDoorbell.SendFormattedMessage( ply, "error", "l1", "#easydoorbell.message.nonpermanent" )

    elseif ent:GetClass() == "easydoorbell_button" then
      --Find speakerID of linked button
      local speakerID = EasyDoorbell.PermButtons[ent.permID].speakerID
      if speakerID == nil then speakerID = 0 end

      --Set convars to those of button
      ply:ConCommand( "easydoorbell_placebutton_model " .. ent:GetModel() )
      ply:ConCommand( "easydoorbell_placebutton_cooldown " .. ent.cooldown )
      ply:ConCommand( "easydoorbell_placebutton_speakerid " .. speakerID )


      --Pause needed or else convars don't update in time
      timer.Simple( 0.1, function()
        net.Start( "EasyDoorbellOpenPermMenu" )
          net.WriteString( "button" )
          net.WriteString( ent.permID )
        net.Send( ply )
      end )

    elseif ent:GetClass() == "easydoorbell_speaker" then
      ply:ConCommand( "easydoorbell_placespeaker_sound " .. ent.sound )
      ply:ConCommand( "easydoorbell_placespeaker_volume " .. ent.volume )

      --Pause needed or else convars don't update in time
      timer.Simple( 0.1, function()
        net.Start( "EasyDoorbellOpenPermMenu" )
          net.WriteString( "speaker" )
          net.WriteString( ent.permID )
        net.Send( ply )
      end )
    end

  elseif arg == "about" then
    EasyDoorbell.SendFormattedMessage( ply, nil, "l1 " .. EasyDoorbell.Version,
      "#easydoorbell.message.serverrunning" )
  else
    EasyDoorbell.SendFormattedMessage( ply, nil, "l1 'perm' l2 'about'",
      "#easydoorbell.message.invalidargument", "#easydoorbell.message.and" )
  end
  return ""
end

hook.Add( "PlayerSay", "EasyDoorbellCommands", ProcessCommands )
