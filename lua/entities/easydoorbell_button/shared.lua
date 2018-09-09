--------------------------------------------------------------------------------
-- Easy Doorbell Button Entity Shared Init
--------------------------------------------------------------------------------

ENT.Type = "anim"
ENT.PrintName = "EasyDoorbell Button"
ENT.Spawnable = false
ENT.Category = "Easy Doorbell"
ENT.AutomaticFrameAdvance = true

-- base_gmodentity is needed for sandbox gamemodes to store the owner of
--   entities placed with the toolgun. On non-sandbox gamemodes there is
--   no toolgun so we can just use base_anim instead.
if GAMEMODE.IsSandboxDerived then
  ENT.Base = "base_gmodentity"
else
  ENT.Base = "base_anim"
end
