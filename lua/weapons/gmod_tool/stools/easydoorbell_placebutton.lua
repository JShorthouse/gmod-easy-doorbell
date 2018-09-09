
TOOL.Category = "Construction"
TOOL.Name = "Doorbell Button"

TOOL.ClientConVar[ "model" ] = "models/easydoorbell/buttonbasic.mdl"
TOOL.ClientConVar[ "cooldown" ] = "1.0"

TOOL.Information = {
	{ name = "left" },
}

cleanup.Register( "easydoorbell_buttons" )

list.Set( "easydoorbell_buttonmodels", "models/easydoorbell/buttonbasic.mdl", {} )
list.Set( "easydoorbell_buttonmodels", "models/easydoorbell/buttonfancy.mdl", {} )
list.Set( "easydoorbell_buttonmodels", "models/easydoorbell/buttonmodern.mdl", {} )

--------------------------------------------------------------------------------
-- Returns true if a given model path is in the list of valid models
--------------------------------------------------------------------------------
local function IsValidButtonModel( model )
	return EasyDoorbell.Tools.IsInList( model, list.Get( "easydoorbell_buttonmodels" ) )
end

--------------------------------------------------------------------------------
-- Place a new button in the world
--------------------------------------------------------------------------------
function TOOL:LeftClick( trace )

	if not EasyDoorbell.Tools.IsPlacementTraceValid( trace ) then return false end
	if CLIENT then return true end


	local ply = self:GetOwner()
	local pos = trace.HitPos
	local ang = trace.HitNormal:Angle()
	local model = self:GetClientInfo( "model" )
	local cooldown = tonumber( self:GetClientInfo( "cooldown" ) )
	local ent = trace.Entity

	-- If we shot a button change its settings
	if EasyDoorbell.Tools.IsEntTypeAndPlayerOwned( ent, "easydoorbell_button", ply ) then
		ent:SetCooldown( cooldown )
		return true
	end

	-- Check the model's validity
	if not util.IsValidModel( model ) or not util.IsValidProp( model ) or
		not IsValidButtonModel( model ) then
			return false
	end

	if not self:GetSWEP():CheckLimit( "easydoorbell_buttons" ) then return false end

	--Ensure cooldown is valid and within limits
	if cooldown == nil then cooldown = 0 end

	if cooldown > EasyDoorbell.Config.MaxButtonCooldown then
		cooldown = EasyDoorbell.Config.MaxButtonCooldown
	elseif cooldown < EasyDoorbell.Config.MinButtonCooldown then
		cooldown = EasyDoorbell.Config.MinButtonCooldown
	end

	EasyDoorbell.CreatePlayerButton( ply, pos, ang, model, cooldown, true, ent,
		trace.PhysicsBone )

	return true
end

function TOOL:Think()

	local model = self:GetClientInfo( "model" )
	if not IsValidButtonModel( model ) then self:ReleaseGhostEntity() return end

	if not IsValid( self.GhostEntity ) or self.GhostEntity:GetModel() ~= model then
		self:MakeGhostEntity( model, Vector( 0, 0, 0 ), Angle( 0, 0, 0 ) )
	end

	--self:UpdateGhostButton( self.GhostEntity, self:GetOwner() )
	if CLIENT then
		EasyDoorbell.Tools.UpdateGhost( self:GetOwner(), self.GhostEntity, "easydoorbell_button" )
	end

end


function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header",
		{ Description = "#tool.easydoorbell_placebutton.desc" } )
	CPanel:AddControl( "PropSelect",
		{ Label = "#tool.easydoorbell_placebutton.model",
		ConVar = "easydoorbell_placebutton_model", Height = 0,
		Models = list.Get( "easydoorbell_buttonmodels" ) } )
	CPanel:AddControl( "Slider",
		{ Label = "#tool.easydoorbell_placebutton.cooldown",
		ConVar = "easydoorbell_placebutton_cooldown", Type = "Float",
		Min = EasyDoorbell.Config.MinButtonCooldown,
		Max = EasyDoorbell.Config.MaxButtonCooldown,
		Command = "easydoorbell_placebutton_cooldown", Help = true } )
end

if CLIENT then return end

--------------------------------------------------------------------------------
-- Create a button linked to a player, and add it to their undo list
-- Returns: createdButton, createdWeld
--------------------------------------------------------------------------------
function EasyDoorbell.CreatePlayerButton( ply, pos, ang, model, cooldown, noCollide,
	weldEnt, weldBone )

	if not ply:IsValid() then return false end
	if not ply:CheckLimit( "easydoorbell_buttons" ) then return false end
	if not IsValidButtonModel( model ) then return false end

	local button, weld = EasyDoorbell.CreateButtonEnt( pos, ang, model, cooldown,
		noCollide, weldEnt, weldBone )

	if not IsValid( button ) then return end

	button:SetPlayer( ply )

	ply:AddCount( "easydoorbell_buttons", button )
	ply:AddCleanup( "easydoorbell_buttons", button )
	ply:AddCleanup( "easydoorbell_buttons", weld )

	undo.Create( "Doorbell Button" )
		undo.AddEntity( button )
		if weld then undo.AddEntity( weld ) end
		undo.SetPlayer( ply )
	undo.Finish()

	DoPropSpawnedEffect( button )

	return button, weld
end

--------------------------------------------------------------------------------
-- Ensure convars are valid, and set them to valid values if they are not
--------------------------------------------------------------------------------
function TOOL:Deploy()

	--Ensure model is valid
	if not IsValidButtonModel( self:GetClientInfo( "model" ) ) then
		self:GetOwner():ConCommand(
			"easydoorbell_placebutton_model models/easydoorbell/buttonbasic.mdl" )
	end

	--Ensure cooldown is valid
	local cooldown = tonumber( self:GetClientInfo( "cooldown" ) )

	if cooldown == nil or cooldown < EasyDoorbell.Config.MinButtonCooldown then
		self:GetOwner():ConCommand(
			"easydoorbell_placebutton_cooldown " .. EasyDoorbell.Config.MinButtonCooldown )
	elseif cooldown > EasyDoorbell.Config.MaxButtonCooldown then
		self:GetOwner():ConCommand(
			"easydoorbell_placebutton_cooldown " .. EasyDoorbell.Config.MaxButtonCooldown )
	end
end


duplicator.RegisterEntityClass( "easydoorbell_button", EasyDoorbell.CreatePlayerButton,
	"Pos", "Ang", "Model", "cooldown", false )
