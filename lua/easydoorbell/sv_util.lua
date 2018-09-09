--------------------------------------------------------------------------------
-- Easy Doorbell Utilities
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Send a formatted message to the client. The message can use "l[index]" to
--  reference language strings in the vararg which will be automatically
--  replaced with the client's language when displayed.
--------------------------------------------------------------------------------
function EasyDoorbell.SendFormattedMessage( ply, type, message, ... )
  local prefixMessage = "[Easy Doorbell] " .. message
  local color
  if type == "error" then
    color = Color( 250, 0, 0 )
  elseif type == "success" then
    color = Color( 0, 200, 0 )
  else
    color = Color( 200, 200, 200 )
  end

  net.Start( "EasyDoorbellFormattedMessage" )
    net.WriteColor( color )
    net.WriteString( prefixMessage )
    net.WriteTable( { ... } )
  net.Send( ply )
end

--------------------------------------------------------------------------------
-- Returns true if the user is an admin or superadmin
-- If false, sends an error message to the client
--------------------------------------------------------------------------------
function EasyDoorbell.CheckPermission( ply )
  if EasyDoorbell.Config.EnablePermPlacement == false then
    EasyDoorbell.SendFormattedMessage( ply, "error", "l1", "#easydoorbell.message.permplacedisabled" )
    return false
  elseif ply:IsAdmin() or ply:IsSuperAdmin() then return true
  else
    EasyDoorbell.SendFormattedMessage( ply, "error", "l1", "#easydoorbell.message.nopermission" )
    return false
  end
end
