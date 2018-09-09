--------------------------------------------------------------------------------
-- Easy Doorbell Speaker Entity Server Init
--------------------------------------------------------------------------------

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

ENT.volume = 1
ENT.sound = "easydoorbell/standard.wav"

function ENT:Initialize()
  self:SetModel( "models/easydoorbell/speakerbell.mdl" ) -- Fallback
  self:PhysicsInit( SOLID_VPHYSICS )
  self:SetMoveType( MOVETYPE_VPHYSICS )
  self:SetSolid( SOLID_VPHYSICS )

  local phys = self:GetPhysicsObject()

  if phys:IsValid() then
    phys:Wake()
  end
end

--------------------------------------------------------------------------------
-- Change the speaker volume to a valid value
--------------------------------------------------------------------------------
function ENT:SetVolume( newVolume )
  vol = tonumber( newVolume )
  if vol == nil then
    vol = EasyDoorbell.Config.MaxSpeakerVolume
  elseif vol < 0 then
    vol = 0
  end

  self.volume = vol
end

function ENT:SetSound( sound )
  self.sound = sound
end

--------------------------------------------------------------------------------
-- Emit the speaker's sound at the speaker's volume
--------------------------------------------------------------------------------
function ENT:Ring()
  sound.Play( self.sound, self:GetPos(), 65, 100, math.pow( self.volume, 2 ) )
end

--------------------------------------------------------------------------------
-- Set the permanent ID. Only used for permanent speakers
-------------------------------------------------------------------------------
function ENT:SetPermID( id )
  self.permID = id
end

function ENT:OnRemove()
    EasyDoorbell.RemoveLink( self )
end
