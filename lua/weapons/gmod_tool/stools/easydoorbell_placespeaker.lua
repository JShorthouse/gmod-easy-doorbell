
TOOL.Category = "Construction"
TOOL.Name = "#tool.easydoorbell_placespeaker.name"

TOOL.ClientConVar[ "model" ] = "models/easydoorbell/speakerbell.mdl"
TOOL.ClientConVar[ "sound" ] = "easydoorbell/standard.wav"
TOOL.ClientConVar[ "volume" ] = "1.0"

TOOL.Information = {
	{ name = "left", stage = 0},
	{ name = "left_1", stage = 1},
}

cleanup.Register( "easydoorbell_speakers" )

list.Set( "easydoorbell_speakermodels", "models/easydoorbell/speakerbell.mdl", {} )

list.Set( "easydoorbell_speakersounds", "#easydoorbell.sounds.standard",
	{ easydoorbell_placespeaker_sound = "easydoorbell/standard.wav" } )
list.Set( "easydoorbell_speakersounds", "#easydoorbell.sounds.electronic",
	{ easydoorbell_placespeaker_sound = "easydoorbell/electronic.wav" } )
list.Set( "easydoorbell_speakersounds", "#easydoorbell.sounds.bell",
	{ easydoorbell_placespeaker_sound = "easydoorbell/bell.wav" } )
list.Set( "easydoorbell_speakersounds", "#easydoorbell.sounds.buzzer",
	{ easydoorbell_placespeaker_sound = "easydoorbell/buzzer.wav" } )

local STAGE_SELECTION = 0
local STAGE_PLACEMENT = 1

--------------------------------------------------------------------------------
-- Returns true if a given model path is in the list of valid models
--------------------------------------------------------------------------------
local function IsValidSpeakerModel( model )
	return EasyDoorbell.Tools.IsInList( model, list.Get( "easydoorbell_speakermodels" ) )
end

--------------------------------------------------------------------------------
-- Returns true if a given sound path is in the list of valid sounds
--------------------------------------------------------------------------------
local function IsValidEasyDoorbellSpeakerSound( sound )
	return EasyDoorbell.Tools.IsInList( sound,
		list.Get( "easydoorbell_speakersounds" ), "easydoorbell_placespeaker_sound" )
end

--------------------------------------------------------------------------------
-- Choose a button to link to, create a new speaker, or update an existing one
--------------------------------------------------------------------------------
function TOOL:LeftClick( trace )

	if not EasyDoorbell.Tools.IsPlacementTraceValid( trace ) then return false end

	local ply = self:GetOwner()
	local pos = trace.HitPos
	local ang = trace.HitNormal:Angle()
	local model = self:GetClientInfo( "model" )
	local sound = self:GetClientInfo( "sound" )
	local volume = self:GetClientInfo( "volume" )
	local button = self:GetEnt( 0 )
	local ent = trace.Entity

	-- Determine whether to display clientside effect
	-- Always true in the placement stage or only true in the selection stage
	-- 	if a doorbell entity is selected
	if CLIENT then
		if self:GetStage() == 1 or
			ent:GetClass() == "easydoorbell_speaker" or
			ent:GetClass() == "easydoorbell_button"
		then
			return true
		else
			return false
		end
	end

	-- STAGE_SELECTION - Select button to link / Update speaker
	-- STAGE_PLACEMENT - Chose location of new speaker / Update speaker
	if self:GetStage() == STAGE_SELECTION then
		if EasyDoorbell.Tools.IsEntTypeAndPlayerOwned( ent, "easydoorbell_speaker", ply )  then
			--User has selected speaker to update
				ent:SetSound( sound )
				ent:SetVolume( volume )
				return true
		elseif EasyDoorbell.Tools.IsEntTypeAndPlayerOwned( ent, "easydoorbell_button", ply ) then
			--User has selected button to link
			--We only need the ent but all the other data has to be also stored for this to work
			self:SetObject( 0, ent, pos, ent:GetPhysicsObject(), trace.PhysicsBone, trace.HitNormal )
			self:SetStage( STAGE_PLACEMENT )
			return true
		end

	elseif self:GetStage() == STAGE_PLACEMENT then

		if EasyDoorbell.Tools.IsEntTypeAndPlayerOwned( ent, "easydoorbell_speaker", ply ) then
			-- If we shot a speaker change its settings
			ent:SetSound( sound )
			ent:SetVolume( volume )
			EasyDoorbell.CreateLink( button, ent )
			self:SetStage( STAGE_SELECTION )
			return true
		elseif EasyDoorbell.Tools.IsEntTypeAndPlayerOwned( ent, "easydoorbell_button", ply ) then
			-- If we shot a button update the stored button and return
			self:SetObject( 0, ent, pos, ent:GetPhysicsObject(), trace.PhysicsBone, trace.HitNormal )
			return true
		end

		-- Check model and sound validity
		if not util.IsValidModel( model ) or not util.IsValidProp( model ) or
			not IsValidSpeakerModel( model ) or not IsValidEasyDoorbellSpeakerSound( sound )
		then return false end


		if not self:GetSWEP():CheckLimit( "easydoorbell_speakers" ) then
			self:SetStage( STAGE_SELECTION )
			return false
		end

		--Ensure volume is valid and within limits
		volume = tonumber( volume )
		if volume == nil then
			volume = 1
		end

		if volume > EasyDoorbell.Config.MaxSpeakerVolume then
			volume = EasyDoorbell.Config.MaxSpeakerVolume
		end

		local speaker = EasyDoorbell.CreatePlayerSpeaker( ply, pos, ang, model, sound, volume, true,
			ent, trace.PhysicsBone )

		EasyDoorbell.CreateLink( button, speaker )

		self:SetStage( STAGE_PLACEMENT )
		return true
	end
end

function TOOL:Think()

	if self:GetStage() == 0 then
		self:ReleaseGhostEntity()
		return
	end;

	local mdl = self:GetClientInfo( "model" )
	if ( not IsValidSpeakerModel( mdl ) ) then self:ReleaseGhostEntity() return end

	if ( not IsValid( self.GhostEntity ) or self.GhostEntity:GetModel() ~= mdl ) then
		self:MakeGhostEntity( mdl, Vector( 0, 0, 0 ), Angle( 0, 0, 0 ) )
	end

	--self:UpdateGhostSpeaker( self.GhostEntity, self:GetOwner() )
	if CLIENT then
		EasyDoorbell.Tools.UpdateGhost( self:GetOwner(), self.GhostEntity, "easydoorbell_button", "easydoorbell_speaker" )
	end
end

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header",
		{ Description = "#tool.easydoorbell_placespeaker.info" } )
  CPanel:AddControl( "ListBox",
		{ Label = "#tool.easydoorbell_placespeaker.sound",
		Options = list.Get( "easydoorbell_speakersounds" ) } )
	CPanel:AddControl( "Slider",
		{ Label = "#tool.easydoorbell_placespeaker.volume",
		ConVar = "easydoorbell_placespeaker_volume", Type = "Float", Min = "0",
		Max = EasyDoorbell.Config.MaxSpeakerVolume,
		Command = "easydoorbell_placespeaker_volume", Help = true } )
end


if CLIENT then return end

--------------------------------------------------------------------------------
-- Create a speaker linked to a player, and add it to their undo list
-- Returns: createdSpeaker, createdWeld
--------------------------------------------------------------------------------
function EasyDoorbell.CreatePlayerSpeaker( ply, pos, ang, model, sound, volume, noCollide,
		weldEnt, weldBone )

	if not ply:IsValid() then return false end
	if not ply:CheckLimit( "easydoorbell_speakers" ) then return false end
	if not IsValidSpeakerModel( model ) then return end

	local speaker, weld = EasyDoorbell.CreateSpeakerEnt( pos, ang, model, sound,
		volume, noCollide, weldEnt, weldBone )

	if not IsValid( speaker ) then return end

	speaker:SetPlayer( ply )

	ply:AddCount( "easydoorbell_speakers", speaker )
	ply:AddCleanup( "easydoorbell_speakers", speaker )
	ply:AddCleanup( "easydoorbell_speakers", weld )

	undo.Create( "Doorbell Speaker" )
		undo.AddEntity( speaker )
		if weld then undo.AddEntity( weld ) end
		undo.SetPlayer( ply )
	undo.Finish()

	DoPropSpawnedEffect( speaker )

	return speaker, weld
end

--------------------------------------------------------------------------------
-- Ensure convars are valid, and set them to valid values if they are not
--------------------------------------------------------------------------------
function TOOL:Deploy()

	--Ensure model and sound are valid
	if not IsValidSpeakerModel( self:GetClientInfo( "model" ) ) then
		self:GetOwner():ConCommand(
			"easydoorbell_placespeaker_model models/easydoorbell/speakerbell.mdl" )
	end
	if not IsValidEasyDoorbellSpeakerSound( self:GetClientInfo( "sound" ) ) then
		self:GetOwner():ConCommand(
			"easydoorbell_placespeaker_sound easydoorbell/standard.wav" )
	end

	--Ensure volume is valid
	local volume = tonumber( self:GetClientInfo( "volume" ) )

	if volume == nil or volume < 0 then
		self:GetOwner():ConCommand( "easydoorbell_placespeaker_volume 0" )
	elseif volume > EasyDoorbell.Config.MaxSpeakerVolume then
		self:GetOwner():ConCommand( "easydoorbell_placespeaker_volume " ..
			EasyDoorbell.Config.MaxSpeakerVolume )
	end
end


duplicator.RegisterEntityClass( "easydoorbell_speaker", EasyDoorbell.CreatePlayerSpeaker,
 	"Pos", "Ang", "Model", "sound", "volume", false )
