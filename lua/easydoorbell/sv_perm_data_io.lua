--------------------------------------------------------------------------------
-- Easy Doorbell Perm Data IO
-- Functions for reading and writing permanent entity data to the disk
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Write PermSpeaker and PermButton tables to the disk
--------------------------------------------------------------------------------
function EasyDoorbell.WritePermDoorbellData()
  if not file.Exists( "easydoorbell/permdata", "DATA" ) then
    file.CreateDir( "easydoorbell/permdata" )
  end
  print( "[EasyDoorbell] Writing data to disk" )
  file.Write( "easydoorbell/permdata/speakers.txt", util.TableToJSON( EasyDoorbell.PermSpeakers, true ) )
  file.Write( "easydoorbell/permdata/buttons.txt", util.TableToJSON( EasyDoorbell.PermButtons, true ) )
end

--------------------------------------------------------------------------------
-- Read perm data from disk and create buttons and speakers
--------------------------------------------------------------------------------
local function CreateDoorbellEntsFromDisk()
  if EasyDoorbell.Config.EnablePermLoading == false then return end;
  if not file.Exists( "easydoorbell/permdata", "DATA" ) then return end;

  if file.Exists( "easydoorbell/permdata/speakers.txt", "DATA" ) then
    print( "[EasyDoorbell] Loading permanent speaker data from disk" )
    EasyDoorbell.PermSpeakers = util.JSONToTable(
      file.Read( "easydoorbell/permdata/speakers.txt", "DATA" ) )
  end
  if file.Exists( "easydoorbell/permdata/buttons.txt", "DATA" ) then
    print( "[EasyDoorbell] Loading permanent button data from disk" )
    EasyDoorbell.PermButtons = util.JSONToTable(
      file.Read( "easydoorbell/permdata/buttons.txt", "DATA" ) )
  end

  local createdSpeakers = {}
  local map = game.GetMap()

  --Load permanent speakers
  if EasyDoorbell.PermSpeakers ~= nil then
    for id, v in pairs( EasyDoorbell.PermSpeakers ) do
      if map == v.map then
        local speaker = EasyDoorbell.PlaceWorldSpeaker( id, v.pos, v.ang, v.model,
          v.sound, v.volume, v.noCollide )
        createdSpeakers[id] = speaker
      end
      if id >= EasyDoorbell.nextSpeakerID then
        EasyDoorbell.nextSpeakerID = id + 1
      end
    end
  end

  --Load permanent buttons
  if EasyDoorbell.PermButtons ~= nil then
    for id, v in pairs( EasyDoorbell.PermButtons ) do
      if map == v.map then
        local button = EasyDoorbell.PlaceWorldButton( id, v.pos, v.ang, v.model,
          v.cooldown, v.noCollide )

        --Link button to speaker
        if v.speakerID ~= nil and createdSpeakers[v.speakerID] ~= nil then
          EasyDoorbell.CreateLink( button, createdSpeakers[v.speakerID] )
        end
      end
      if id >= EasyDoorbell.nextButtonID then
        EasyDoorbell.nextButtonID = id + 1
      end
    end
  end
end

--Load permanent buttons and speakers after map entities have initialised
hook.Add( "InitPostEntity", "EasyDoorbellPlacePerm", CreateDoorbellEntsFromDisk )
