--------------------------------------------------------------------------------
-- Easy Doorbell Tool Functions
-- Common functions used by toolsguns
--------------------------------------------------------------------------------

EasyDoorbell.Tools = {}

--------------------------------------------------------------------------------
-- Update position and angles of ghosted entitities drawn when player is using
--  a toolgun
-- The ghost will be hidden if the player is hovering over an entity with a
--  class specified in the vararg
--------------------------------------------------------------------------------
function EasyDoorbell.Tools.UpdateGhost( ply, ent, ... )
  if not IsValid( ent ) then return end;

  --Don't ghost over entities in the ignore list or entites of the same type
  local ignoreList = { ... }
  table.insert( ignoreList, ent:GetClass() )

  local trace = ply:GetEyeTrace()
  local ang = trace.HitNormal:Angle()

  --Disable ghosting
  if trace.HitSky or
    ( IsValid( trace.Entity ) and ( trace.Entity:IsPlayer() ) or
    table.HasValue( ignoreList, trace.Entity:GetClass() ) ) then
    ent:SetNoDraw( true )
    return
  end

  ent:SetPos( trace.HitPos )
  ent:SetAngles( ang )
  ent:SetNoDraw ( false )
end

--------------------------------------------------------------------------------
-- Returns true if a string is in a given list
--------------------------------------------------------------------------------
function EasyDoorbell.Tools.IsInList( string, list, tableIndex )
  string = string:lower()

  --Some lists store the values we want to check in their indexes, others in a
  --  table value with a certain index
  if tableIndex then
    for _, table in pairs( list ) do
      if tostring( table[tableIndex] ):lower() == string then return true end
    end
  else
    for name, _ in pairs( list ) do
      if name:lower() == string then return true end
    end
  end
  return false
end

--------------------------------------------------------------------------------
-- Returns true if a tool placement trace is valid
--------------------------------------------------------------------------------
function EasyDoorbell.Tools.IsPlacementTraceValid( trace )
  if ( IsValid( trace.Entity ) and  trace.Entity:IsPlayer() ) or trace.HitSky or
    ( SERVER and not util.IsValidPhysicsObject( trace.Entity, trace.PhysicsBone ) )
  then
    return false
  else
    return true
  end
end

function EasyDoorbell.Tools.IsEntTypeAndPlayerOwned( ent, class, ply )
  if IsValid( ent ) and ent:GetClass() == class and
    ent:GetPlayer() == ply then
    return true
  else
    return false
  end
end
