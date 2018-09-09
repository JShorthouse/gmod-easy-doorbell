--------------------------------------------------------------------------------
-- Easy Doorbell Serverside Linking
-- Purpose: Handle linking and unlinking of doorbell buttons and speakers as
--  well as functions involving these links
--------------------------------------------------------------------------------

-- Table of linked buttons and bells, stored as connectionTable[bell] = button
local connectionTable = connectionTable or {}

--------------------------------------------------------------------------------
-- Remove all links with an entity from the connectionTable
--------------------------------------------------------------------------------
function EasyDoorbell.RemoveLink( entity )
  if not entity:IsValid() then return end
  if entity:GetClass() == "easydoorbell_button" then
    connectionTable[entity] = nil
  elseif entity:GetClass() == "easydoorbell_speaker" then
    for k in pairs( connectionTable ) do
      if connectionTable[k] == entity then
        connectionTable[k] = nil
      end
    end
  end
end

--------------------------------------------------------------------------------
-- Link a button and speaker in the connectionTable
--------------------------------------------------------------------------------
function EasyDoorbell.CreateLink( button, speaker )
  if IsValid( button ) and button:GetClass() == "easydoorbell_button" and
    IsValid( speaker ) and speaker:GetClass() == "easydoorbell_speaker" then
      connectionTable[button] = speaker;
  end
end

--------------------------------------------------------------------------------
-- Link a button entity to a speaker with a certain ID
--------------------------------------------------------------------------------
function EasyDoorbell.LinkButtonBySpeakerID( button, speakerID )
  local speakers = ents.FindByClass( "easydoorbell_speaker" )

  EasyDoorbell.RemoveLink( button ) -- Remove old link

  for _, speaker in pairs( speakers ) do
    if speaker.permID and speaker.permID == speakerID then
      EasyDoorbell.CreateLink( button, speaker )
      break
    end
  end
end

--------------------------------------------------------------------------------
-- Tell the speaker linked to a given button to play its ring sound
--------------------------------------------------------------------------------
function EasyDoorbell.RingLinkedSpeaker( button )
  if IsValid( button ) and button:GetClass() == "easydoorbell_button" then
    if connectionTable[button] and connectionTable[button]:IsValid() then
      connectionTable[button]:Ring()
    end
  end
end

hook.Add( "EasyDoorbellRemoveLink", "EasyDoorbellRemoveLink", EasyDoorbell.RemoveLink )
hook.Add( "EasyDoorbellCreateLink", "EasyDoorbellCreateLink", EasyDoorbell.CreateLink )
hook.Add( "EasyDoorbellRingSpeaker", "EasyDoorbellRingSpeaker", EasyDoorbell.RingLinkedSpeaker )
