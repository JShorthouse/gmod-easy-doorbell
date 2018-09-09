--------------------------------------------------------------------------------
-- Easy Doorbell Button Entity Server Init
--------------------------------------------------------------------------------

AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

ENT.cooldownActive = false;
ENT.cooldown = 1.0;

function ENT:Initialize()
  self:SetModel( "models/easydoorbell/buttonstandard.mdl" ) -- Fallback
  self:PhysicsInit( SOLID_VPHYSICS )
  self:SetMoveType( MOVETYPE_VPHYSICS )
  self:SetSolid( SOLID_VPHYSICS )
  self:SetUseType( SIMPLE_USE )

  local phys = self:GetPhysicsObject()

  if phys:IsValid() then
    phys:Wake()
  end
end

--Play animation smoothly
--NOTE Check if this is actually needed
function ENT:Think() self:NextThink( CurTime() ); return true; end


--------------------------------------------------------------------------------
-- Play animation and run fuction to play sound from linked speaker
--------------------------------------------------------------------d------------
function ENT:Use( activator, caller, type )
  self:ResetSequence( 1 ) -- Button pressed animation
  sound.Play( "easydoorbell/button.wav",self:GetPos(), 40, 130, 1 )

  if not self.cooldownActive and type == USE_ON then
    -- NOTE check if USE_ON is needed

    timer.Simple( 0.125, function() EasyDoorbell.RingLinkedSpeaker( self ) end )
      -- Ring after delay (to simulate button being pushed in)
    self.cooldownActive = true
    timer.Simple( self.cooldown, function() self.cooldownActive = false end )
  end
end

--------------------------------------------------------------------------------
-- Change the button cooldown to a valid value
--------------------------------------------------------------------------------
function ENT:SetCooldown( newCooldown )
  cooldown = tonumber( newCooldown )
  if cooldown == nil then
    cooldown = EasyDoorbell.Config.MinButtonCooldown
  elseif cooldown < 0 then
    cooldown = 0
  end

  self.cooldown = cooldown
end

--------------------------------------------------------------------------------
-- Set the permanent ID. Only used for permanent buttons.
--------------------------------------------------------------------------------
function ENT:SetPermID( id )
  self.permID = id
end

function ENT:OnRemove()
    EasyDoorbell.RemoveLink( self )
end
