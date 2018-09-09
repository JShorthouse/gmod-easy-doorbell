--------------------------------------------------------------------------------
-- Easy Doorbell Config Loader
-- Purpose: Load config from disk on startup, then store valid config data in
--  the config table
--------------------------------------------------------------------------------

util.AddNetworkString( "EasyDoorbellTransferConfig" )

-- Default config values, used for fallback and inital creation of config file
local defaultConfig = {
  MaxSpeakerVolume = 0.75,
  MinButtonCooldown = 0.25,
  MaxButtonCooldown = 15.0,
  EnablePermLoading = true,
  EnablePermPlacement = true
}

-- Create config if does not exist
if not file.Exists( "easydoorbell", "DATA" ) then
  file.CreateDir( "easydoorbell" )
end
if not file.Exists( "easydoorbell/config.txt", "DATA" ) then
  file.Write( "easydoorbell/config.txt", util.TableToJSON( defaultConfig, true ) )
  print("[EasyDoorbell] Config file not found, creating")
end

local configTable = util.JSONToTable( file.Read( "easydoorbell/config.txt", "DATA" ) )

-- Only apply config file if it parsed correctly
if configTable ~= nil then
  EasyDoorbell.Config = table.Merge( defaultConfig, configTable )
else
  print("[EasyDoorbell] Config file is invalid, reverting to defaults. " ..
    "Correct the config file or delete it for it to automatically recreated on next restart")
  EasyDoorbell.Config = defaultConfig
end

-- Ensure values are valid
if tonumber(EasyDoorbell.Config.MinButtonCooldown) == nil or EasyDoorbell.Config.MinButtonCooldown < 0 then
  EasyDoorbell.Config.MinButtonCooldown = 0
end
if tonumber(EasyDoorbell.Config.MaxButtonCooldown) == nil or
    EasyDoorbell.Config.MaxButtonCooldown < EasyDoorbell.Config.MinButtonCooldown then
        EasyDoorbell.Config.MaxButtonCooldown = EasyDoorbell.Config.MinButtonCooldown
end
if tonumber(EasyDoorbell.Config.MaxSpeakerVolume) == nil or EasyDoorbell.Config.MaxSpeakerVolume > 1 then
  EasyDoorbell.Config.MaxSpeakerVolume = 1
end
if EasyDoorbell.Config.EnablePermLoading ~= true and EasyDoorbell.Config.EnablePermLoading ~= false then
  EasyDoorbell.Config.EnablePermLoading = true
end
if EasyDoorbell.Config.EnablePermPlacement ~= true and EasyDoorbell.Config.EnablePermPlacement ~= false then
  EasyDoorbell.Config.EnablePermPlacement = true
end
if EasyDoorbell.Config.EnablePermLoading == false then
  EasyDoorbell.Config.EnablePermPlacement = false
end

--------------------------------------------------------------------------------
-- Send config to a player
--------------------------------------------------------------------------------
local function transferConfig( ply )
  net.Start( "EasyDoorbellTransferConfig" )
    net.WriteTable( EasyDoorbell.Config )
  net.Send( ply )
end

-- Send config to players when they first join
hook.Add( "PlayerInitialSpawn", "SendEasyDoorbellConfig", transferConfig )
