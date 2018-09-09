--------------------------------------------------------------------------------
-- Easy Doorbell Perm Entities
-- Code related to the creation, manipulation and deletion of permanent entites
--------------------------------------------------------------------------------

EasyDoorbell.PermSpeakers = EasyDoorbell.PermSpeakers or {}
EasyDoorbell.PermButtons = EasyDoorbell.PermButtons or {}
EasyDoorbell.nextButtonID = EasyDoorbell.nextButtonID or 0
EasyDoorbell.nextSpeakerID = EasyDoorbell.nextButtonID or 0

--------------------------------------------------------------------------------
-- Return the current value of nextButtonID and then increment it by 1
--------------------------------------------------------------------------------
local function GetNextButtonID()
  local returnID = EasyDoorbell.nextButtonID
  EasyDoorbell.nextButtonID = EasyDoorbell.nextButtonID + 1
  return returnID
end

--------------------------------------------------------------------------------
-- Creates a small shower of sparks at a given position
--------------------------------------------------------------------------------
local function DoPermSpawnEffect( pos )
  local effectdata = EffectData()
  effectdata:SetOrigin( pos )
  util.Effect( "cball_bounce", effectdata )
end

--------------------------------------------------------------------------------
-- Return the current value of nextSpeakerID and then increment it by 1
--------------------------------------------------------------------------------
local function GetNextSpeakerID()
  local returnID = EasyDoorbell.nextSpeakerID
  EasyDoorbell.nextSpeakerID = EasyDoorbell.nextSpeakerID + 1
  return returnID
end

--------------------------------------------------------------------------------
-- Create a new world speaker with a permID
-- Returns: createdSpeaker
--------------------------------------------------------------------------------
function EasyDoorbell.PlaceWorldSpeaker( id, pos, ang, model, sound, volume, noCollide )
  id = tonumber( id )
  if id == nil then
    id = GetNextSpeakerID()
  end

  local speaker = EasyDoorbell.CreateSpeakerEnt( pos, ang, model, sound, volume,
    noCollide, game.GetWorld(), nil )

  speaker:SetPermID( id )
  DoPermSpawnEffect( pos )

  return speaker
end

--------------------------------------------------------------------------------
-- Create a new world button with a permID
-- Returns: createdButton
--------------------------------------------------------------------------------
function EasyDoorbell.PlaceWorldButton( id, pos, ang, model, cooldown, noCollide )
  id = tonumber( id )
  if id == nil then
    id = GetNextButtonID()
  end

  local button = EasyDoorbell.CreateButtonEnt( pos, ang, model, cooldown, noCollide,
    game.GetWorld(), nil )

  button:SetPermID( id )
  DoPermSpawnEffect( pos )

  return button
end

--------------------------------------------------------------------------------
-- Create a new world speaker and add it to the perm table
-- Returns: createdSpeaker
--------------------------------------------------------------------------------
local function RegisterPermSpeaker( pos, ang, model, sound, volume, noCollide )
  local speaker = EasyDoorbell.PlaceWorldSpeaker( nil, pos, ang, model, sound, volume, noCollide )

  --Add speaker to permanent table
  EasyDoorbell.PermSpeakers[speaker.permID] = {
    pos = pos, ang = ang, model = model, sound = sound, volume = volume,
    noCollide = noCollide, map = game.GetMap() }
  return speaker
end

--------------------------------------------------------------------------------
-- Create a new world button and add it to the perm table
-- Returns: createdButton
--------------------------------------------------------------------------------
local function RegisterPermButton( pos, ang, model, cooldown, noCollide, speakerID )
  local button = EasyDoorbell.PlaceWorldButton( nil, pos, ang, model, cooldown, noCollide )

  --Add button to permanent table
  EasyDoorbell.PermButtons[button.permID] = {
    pos = pos, ang = ang, model = model, cooldown = cooldown,
    noCollide = noCollide, speakerID = speakerID, map = game.GetMap() }

  EasyDoorbell.LinkButtonBySpeakerID( button, speakerID )

  return button
end

--------------------------------------------------------------------------------
-- Update the settings of an existing speaker, both in the world and in the perm
--  table
-- Any nil paramaters will not be changed
--------------------------------------------------------------------------------
local function UpdatePermSpeaker( speaker, sound, volume, noCollide )
  if ( not speaker:IsValid() ) or speaker.permID == nil then return end

  local id = speaker.permID

  if sound ~= nil then
    speaker:SetSound( sound )
    EasyDoorbell.PermSpeakers[id].sound = sound
  end
  if volume ~= nil then
    speaker:SetVolume( volume )
    EasyDoorbell.PermSpeakers[id].volume = speaker.volume
  end

  if noCollide ~= nil then
    if noCollide then
      speaker:SetCollisionGroup( COLLISION_GROUP_WORLD )
    else
      speaker:SetCollisionGroup( COLLISION_GROUP_NONE )
    end
    EasyDoorbell.PermSpeakers[id].noCollide = noCollide
  end
end

--------------------------------------------------------------------------------
-- Update the settings of an existing button, both in the world and in the perm
--  table
-- Any nil parameters will not be changed
--------------------------------------------------------------------------------
local function UpdatePermButton( button, cooldown, noCollide, speakerID )
  if ( not button:IsValid() ) or button.permID == nil then return end

  cooldown = tonumber( cooldown )
  speakerID = tonumber( speakerID )

  --Update in world
  local id = button.permID

  if cooldown ~= nil then
    button:SetCooldown(cooldown)
    EasyDoorbell.PermButtons[id].cooldown = button.cooldown
  end

  if noCollide ~= nil then
    if noCollide then
      button:SetCollisionGroup( COLLISION_GROUP_WORLD )
    else
      button:SetCollisionGroup( COLLISION_GROUP_NONE )
    end
    EasyDoorbell.PermButtons[id].noCollide = noCollide
  end

  if speakerID ~= nil then
    EasyDoorbell.LinkButtonBySpeakerID( button, speakerID )
    EasyDoorbell.PermButtons[id].speakerID = speakerID
  end
end

--------------------------------------------------------------------------------
-- Remove a permanent entity both from the world and from its perm table
--------------------------------------------------------------------------------
local function RemovePerm( ent )
  if not ent:IsValid() then return end;
  if ( ent:GetClass() ~= "easydoorbell_button" and
    ent:GetClass() ~= "easydoorbell_speaker" ) or
    ent.permID == nil then return end; -- Not a permanent entity!

  if ent:GetClass() == "easydoorbell_button" then
    EasyDoorbell.PermButtons[ent.permID] = nil
  else
    EasyDoorbell.PermSpeakers[ent.permID] = nil
  end

  DoPermSpawnEffect( ent:GetPos() )
  ent:Remove()
end

--------------------------------------------------------------------------------
-- Returns common values needed for placement given a player
--------------------------------------------------------------------------------
local function GetPlacementVariables( ply )
  local trace = ply:GetEyeTrace()
  local ang = trace.HitNormal:Angle()
  local pos = trace.HitPos

  return trace, ang, pos
end

--------------------------------------------------------------------------------
-- Process netmessage for placing a new permanent button
--------------------------------------------------------------------------------
net.Receive( "EasyDoorbellCreatePermButton", function( len, ply )
  if not EasyDoorbell.CheckPermission( ply ) then return end
  local model = net.ReadString()
  local cooldown = net.ReadDouble()
  local noCollide = net.ReadBool()
  local speakerID = net.ReadInt(32)

  --Get ang and pos to place button at
  local trace, ang, pos = GetPlacementVariables( ply )
  local button = RegisterPermButton( pos, ang, model, cooldown, noCollide, speakerID )

  if button:IsValid() then
    EasyDoorbell.SendFormattedMessage( ply, "success", "l1 " .. button.permID,
      "#easydoorbell.message.newbutton" )
  end
end )

--------------------------------------------------------------------------------
-- Process netmessage for updating an existing permanent button
--------------------------------------------------------------------------------
net.Receive( "EasyDoorbellUpdatePermButton", function( len, ply )
  if not EasyDoorbell.CheckPermission( ply ) then return end
  local cooldown = net.ReadDouble()
  local noCollide = net.ReadBool()
  local speakerID = net.ReadInt( 32 )
  local button = ply:GetEyeTrace().Entity

  UpdatePermButton( button, cooldown, noCollide, speakerID )
  EasyDoorbell.SendFormattedMessage( ply, "success", "l1", "#easydoorbell.message.buttonupdated" )
end )

--------------------------------------------------------------------------------
-- Process netmessage for creating a new permanent speaker
--------------------------------------------------------------------------------
net.Receive( "EasyDoorbellCreatePermSpeaker", function( len, ply )
  if not EasyDoorbell.CheckPermission( ply ) then return end
  local model = net.ReadString()
  local sound = net.ReadString()
  local volume = net.ReadDouble()
  local noCollide = net.ReadBool()

  local trace, ang, pos = GetPlacementVariables( ply )
  local speaker =  RegisterPermSpeaker( pos, ang, model, sound, volume, noCollide )

  if speaker:IsValid() then
    --Set speakerid convar to created speaker for ease of button placement
    ply:ConCommand( "easydoorbell_placebutton_speakerid " .. speaker.permID )

    EasyDoorbell.SendFormattedMessage( ply, "success", "l1 " .. speaker.permID,
    "#easydoorbell.message.newspeaker" )
  end
end )

--------------------------------------------------------------------------------
-- Process netmessage for updating an exising permanent speaker
--------------------------------------------------------------------------------
net.Receive( "EasyDoorbellUpdatePermSpeaker", function( len, ply )
  if not EasyDoorbell.CheckPermission( ply ) then return end
  local sound = net.ReadString()
  local volume = net.ReadDouble()
  local noCollide = net.ReadBool()
  local speaker = ply:GetEyeTrace().Entity

  UpdatePermSpeaker( speaker, sound, volume, noCollide)
  EasyDoorbell.SendFormattedMessage( ply, "success", "l1",
    "#easydoorbell.message.speakerupdated" )
end )

--------------------------------------------------------------------------------
-- Process netmessage to delete a permanent entity
--------------------------------------------------------------------------------
net.Receive( "EasyDoorbellDeletePermEntity", function( len, ply )
  if not EasyDoorbell.CheckPermission( ply ) then return end
  local ent = ply:GetEyeTrace().Entity

  RemovePerm( ent )

  if not ent:IsValid() then
    EasyDoorbell.SendFormattedMessage( ply, "success", "l1",
      "#easydoorbell.message.entityremoved" )
  end
end )

--------------------------------------------------------------------------------
-- Process netmessage to save permanent doorbell data
--------------------------------------------------------------------------------
net.Receive( "EasyDoorbellSavePermSettings", function( len, ply )
  if not EasyDoorbell.CheckPermission( ply ) then return end
  EasyDoorbell.WritePermDoorbellData()
  EasyDoorbell.SendFormattedMessage( ply, "success", "l1",
    "#easydoorbell.message.datawritten" )
end )
