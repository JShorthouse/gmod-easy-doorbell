--------------------------------------------------------------------------------
-- Easy Doorbell Entity Creation
-- Purpose: Provide functions for creating generic doorbell entties that can
--  be used for permanent or non-permanent tools
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Create a generic ent. Used as a base for all other types
-- Returns: createdEnt, createdWeld
--------------------------------------------------------------------------------
local function CreateGenericEnt( entName, pos, ang, model, noCollide, weldEnt,
  weldBone )

  local ent = ents.Create( entName )
  if not ent:IsValid() then return end;

  ent:SetPos( pos )
  ent:SetAngles( ang )
  ent:SetModel( model )
  ent:Spawn()

  if noCollide then
    ent:SetCollisionGroup( COLLISION_GROUP_WORLD )
  else
    ent:SetCollisionGroup( COLLISION_GROUP_NONE )
  end

  ent:GetPhysicsObject():EnableCollisions( false )

  --If no bone specified, set to 0
  if not weldBone then weldBone = 0 end

  local weld

  if weldEnt and ( weldEnt:IsValid() or weldEnt:IsWorld() ) then
    weld = constraint.Weld( ent, weldEnt, 0, weldBone, 0, false, true )
  end

  return ent, weld
end


--------------------------------------------------------------------------------
-- Create a button.
-- Returns: createdButton, createdWeld
--------------------------------------------------------------------------------
function EasyDoorbell.CreateButtonEnt( pos, ang, model, cooldown, noCollide,
    weldEnt, weldBone)

  local button, weld = CreateGenericEnt( "easydoorbell_button", pos, ang, model,
    noCollide, weldEnt, weldBone )

  button:SetCooldown( cooldown )

  return button, weld
end

--------------------------------------------------------------------------------
-- Create a speaker.
-- Returns: createdSpeaker, createdWeld
--------------------------------------------------------------------------------
function EasyDoorbell.CreateSpeakerEnt( pos, ang, model, sound, volume, noCollide,
  weldEnt, weldBone )

  local speaker, weld = CreateGenericEnt( "easydoorbell_speaker", pos, ang, model,
    noCollide, weldEnt, weldBone )

  speaker:SetSound( sound )
  speaker:SetVolume( volume )

  return speaker, weld
end
