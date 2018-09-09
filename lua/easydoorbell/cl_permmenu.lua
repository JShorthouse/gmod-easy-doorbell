--------------------------------------------------------------------------------
-- Easy Doorbell Perm Placement Menu
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Open the perm button menu with the corresponding tabs for entity type the
--  player is looking at. entID is displayed in the "Info / Delete" tab.
--------------------------------------------------------------------------------
local function OpenPermButtonMenu(editingEntType, entID)
  local height = 400
  local width = 300

  local models = { Basic = "models/easydoorbell/buttonbasic.mdl",
  Fancy = "models/easydoorbell/buttonfancy.mdl",
  Modern = "models/easydoorbell/buttonmodern.mdl" }

  local frame = vgui.Create( "DFrame" )
  frame:SetTitle( "Easy Doorbell Perm Placement Menu" )
  frame:SetSize( width, height )
  frame:SetPos( ScrW()/2 - width/2, ScrH()/2 - height/2 )

  local sheet = vgui.Create( "DPropertySheet", frame )
  sheet:SetSize( 300, 335 )
  sheet:SetPos( 0, 22 )

  --Main sheet

  --Button panel
  if editingEntType == nil or editingEntType == "button" then
    local buttonPanel = vgui.Create( "DPanel", sheet )
    sheet:AddSheet( "#easydoorbell.permplace.tabbutton", buttonPanel, "icon16/bullet_black.png" )

    --Create button heading
    local buttonModelComboLabel = vgui.Create( "DLabel", buttonPanel )
    buttonModelComboLabel:SetFont( "DermaLarge" )
    buttonModelComboLabel:SetPos( 15, 5 )
    buttonModelComboLabel:SetSize( 254, 32 )
    buttonModelComboLabel:SetTextColor( Color( 50, 50, 50 ) )

    if editingEntType ~= nil then
      buttonModelComboLabel:SetText( "#easydoorbell.permplace.editbutton" )
    else
      buttonModelComboLabel:SetText( "#easydoorbell.permplace.createnewbutton" )
    end

    --Model selector
    if editingEntType == nil then
      local buttonModelSelect = vgui.Create( "DPanelSelect", buttonPanel )
      buttonModelSelect:SetSize(200,68)
      buttonModelSelect:SetPos(42, 50)

      for name, path in pairs(models) do
        local icon = vgui.Create( "SpawnIcon" )
    		icon:SetModel( path )
    		icon:SetSize( 64, 64 )
        icon:SetTooltip( name )
        buttonModelSelect:AddPanel( icon, { easydoorbell_placebutton_model = path } )
      end
    end

    --Cooldown slider
    --Has its own label so seperate one is not needed
    local buttonCooldownSlider = vgui.Create( "DNumSlider", buttonPanel )
    buttonCooldownSlider:SetPos( 20, 138 )
    buttonCooldownSlider:SetSize( 244, 16 )
    buttonCooldownSlider:SetText( "#tool.easydoorbell_placebutton.cooldown" )
    buttonCooldownSlider.Label:SetColor( Color( 50, 50, 50 ) )
    buttonCooldownSlider:SetMin( EasyDoorbell.Config.MinButtonCooldown )
    buttonCooldownSlider:SetMax( EasyDoorbell.Config.MaxButtonCooldown )
    buttonCooldownSlider:SetDecimals( 2 )
    buttonCooldownSlider:SetConVar( "easydoorbell_placebutton_cooldown" )

    --SpeakerID selector label
    local buttonSpeakerSelectorLabel = vgui.Create( "DLabel", buttonPanel )
    buttonSpeakerSelectorLabel:SetText( "#easydoorbell.permplace.speakerid" )
    buttonSpeakerSelectorLabel:SetPos( 20, 178 )
    buttonSpeakerSelectorLabel:SetSize( 254, 12 )
    buttonSpeakerSelectorLabel:SetTextColor( Color( 50, 50, 50 ) )

    --SpeakerID selector
    local buttonSpeakerSelector = vgui.Create( "DNumberWang", buttonPanel )
    buttonSpeakerSelector:SetPos( 100, 174 )
    buttonSpeakerSelector:SetSize( 164, 20 )
    buttonSpeakerSelector:SetText( 0 )
    buttonSpeakerSelector:SetMin( 0 )
    buttonSpeakerSelector:SetValue( cvars.String("easydoorbell_placebutton_speakerid" ) )

    --SpeakerID help text
    local buttonSpeakerSelectHelpLabel = vgui.Create( "DLabel", buttonPanel )
    buttonSpeakerSelectHelpLabel:SetText( "#easydoorbell.permplace.speakerid.help" )
    buttonSpeakerSelectHelpLabel:SetPos( 40, 210 )
    buttonSpeakerSelectHelpLabel:SetSize (234, 40 )
    buttonSpeakerSelectHelpLabel:SetWrap( true )
    buttonSpeakerSelectHelpLabel:SetTextColor( Color( 47, 149, 241 ) ) --Toolgun help text blue

    --Create button
    local buttonCreateButton = vgui.Create("DButton", buttonPanel)
    buttonCreateButton:SetPos( 10, 267 )
    buttonCreateButton:SetSize( 264, 22 )
    buttonCreateButton:SetImage( "icon16/add.png" )

    if editingEntType == nil then
      buttonCreateButton:SetText( "#easydoorbell.permplace.createbutton" )
      buttonCreateButton.DoClick = function()
        net.Start( "EasyDoorbellCreatePermButton" )
          net.WriteString( cvars.String( "easydoorbell_placebutton_model" ) )
          net.WriteDouble( cvars.Number( "easydoorbell_placebutton_cooldown" ) )
          net.WriteBool( true )
          net.WriteInt( tonumber(buttonSpeakerSelector:GetValue()), 32 )
        net.SendToServer()
        frame:Remove()
      end
    else
      buttonCreateButton:SetText( "#easydoorbell.permplace.updatebutton" )
      buttonCreateButton.DoClick = function()
        net.Start( "EasyDoorbellUpdatePermButton" )
          net.WriteDouble( cvars.Number( "easydoorbell_placebutton_cooldown" ) )
          net.WriteBool( true )
          net.WriteInt( tonumber(buttonSpeakerSelector:GetValue()), 32 )
        net.SendToServer()
        frame:Remove()
      end
    end
  end

  --Speaker panel
  if editingEntType == nil or editingEntType == "speaker" then
    local speakerPanel = vgui.Create( "DPanel", sheet )
    sheet:AddSheet( "#easydoorbell.permplace.tabspeaker", speakerPanel, "icon16/bell.png" )

    --Create speaker heading
    local speakerHeadingLabel = vgui.Create( "DLabel", speakerPanel )
    speakerHeadingLabel:SetFont( "DermaLarge" )
    speakerHeadingLabel:SetPos( 15, 5 )
    speakerHeadingLabel:SetSize( 254, 32 )
    speakerHeadingLabel:SetTextColor( Color( 50, 50, 50 ) )

    if editingEntType ~= nil then
      speakerHeadingLabel:SetText( "#easydoorbell.permplace.editspeaker" )
    else
      speakerHeadingLabel:SetText( "#easydoorbell.permplace.createnewspeaker" )
    end

    --Sound dropdown label
    local speakerSoundComboLabel = vgui.Create( "DLabel", speakerPanel )
    speakerSoundComboLabel:SetText( "#tool.easydoorbell_placespeaker.sound")
    speakerSoundComboLabel:SetPos( 20, 54 )
    speakerSoundComboLabel:SetSize( 254, 12 )
    speakerSoundComboLabel:SetTextColor( Color( 50, 50, 50 ) )

    --Sound combobox
    local speakerSoundCombo = vgui.Create( "DComboBox", speakerPanel )
    speakerSoundCombo:SetPos( 100, 50 )
    speakerSoundCombo:SetSize( 164, 20 )
    speakerSoundCombo:SetValue( cvars.String( "easydoorbell_placespeaker_sound" ) )
    speakerSoundCombo:AddChoice( "#easydoorbell.sounds.standard", "easydoorbell/standard.wav" )
    speakerSoundCombo:AddChoice( "#easydoorbell.sounds.bell", "easydoorbell/bell.wav" )
    speakerSoundCombo:AddChoice( "#easydoorbell.sounds.buzzer", "easydoorbell/buzzer.wav" )
    speakerSoundCombo:AddChoice( "#easydoorbell.sounds.electronic", "easydoorbell/electronic.wav" )
    --speakerSoundCombo:ChooseOptionID( 1 )

    speakerSoundCombo.OnSelect = function( panel, index, value )
      local _, sound = speakerSoundCombo:GetSelected() --Get data value
      LocalPlayer():ConCommand("easydoorbell_placespeaker_sound " .. sound)
    end

    --Set selection option to value in convar
    local speakerSoundConvarVal = cvars.String("easydoorbell_placespeaker_sound")
    for k, v in pairs( speakerSoundCombo.Data ) do
      if speakerSoundCombo:GetOptionData( k ) == speakerSoundConvarVal then
        speakerSoundCombo:ChooseOptionID( k )
        break
      end
    end

    --Volume slider
    --Has its own label so seperate one is not needed
    local speakerVolumeSlider = vgui.Create( "DNumSlider", speakerPanel )
    speakerVolumeSlider:SetPos( 20, 90 )
    speakerVolumeSlider:SetSize( 244, 16 )
    speakerVolumeSlider:SetText( "#tool.easydoorbell_placespeaker.volume" )
    speakerVolumeSlider.Label:SetColor( Color( 0, 0, 0 ) )
    speakerVolumeSlider:SetMin( 0 )
    speakerVolumeSlider:SetMax( 1 )
    speakerVolumeSlider:SetDecimals( 2 )
    speakerVolumeSlider:SetConVar( "easydoorbell_placespeaker_volume" )

    --Create speaker
    local speakerCreateButton = vgui.Create( "DButton", speakerPanel )
    speakerCreateButton:SetPos( 10, 267 )
    speakerCreateButton:SetSize( 264, 22 )
    speakerCreateButton:SetImage( "icon16/add.png" )

    if editingEntType == nil then
      speakerCreateButton:SetText( "#easydoorbell.permplace.createspeaker" )
      speakerCreateButton.DoClick = function()
        net.Start( "EasyDoorbellCreatePermSpeaker" )
          net.WriteString( "models/easydoorbell/speakerbell.mdl" )
          net.WriteString( cvars.String("easydoorbell_placespeaker_sound" ) )
          net.WriteDouble( cvars.Number("easydoorbell_placespeaker_volume" ) )
          net.WriteBool( true )
        net.SendToServer()
        frame:Remove()
      end
    else
      speakerCreateButton:SetText( "#easydoorbell.permplace.updatespeaker" )
      speakerCreateButton.DoClick = function()
        net.Start( "EasyDoorbellUpdatePermSpeaker" )
          net.WriteString( cvars.String("easydoorbell_placespeaker_sound" ) )
          net.WriteDouble( cvars.Number("easydoorbell_placespeaker_volume" ) )
          net.WriteBool( true )
        net.SendToServer()
        frame:Remove()
      end
    end
  end

  if editingEntType ~= nil then
      local infoPanel = vgui.Create( "DPanel", sheet )
      sheet:AddSheet( "#easydoorbell.permplace.tabinfodelete", infoPanel, "icon16/information.png" )

      --Heading
      local infoHeadingLabel = vgui.Create( "DLabel", infoPanel )
      infoHeadingLabel:SetFont( "DermaLarge" )
      infoHeadingLabel:SetPos( 15, 5 )
      infoHeadingLabel:SetSize (254, 32 )
      infoHeadingLabel:SetTextColor( Color( 50, 50, 50 ) )
      infoHeadingLabel:SetText( "#easydoorbell.permplace.tabinfodelete" )

      --Information labels
      local infoInformationLabel = vgui.Create( "DLabel", infoPanel )
      infoInformationLabel:SetPos( 20, 54 )
      infoInformationLabel:SetSize (254, 12 )
      infoInformationLabel:SetTextColor( Color( 50, 50, 50 ) )

      if editingEntType == "button" then
        infoInformationLabel:SetText( language.GetPhrase("#easydoorbell.permplace.buttonid") .. tostring(entID) )
      elseif editingEntType == "speaker" then
        infoInformationLabel:SetText( language.GetPhrase("#easydoorbell.permplace.speakerid") .. tostring(entID) )
      end

      --Delete button
      local infoDeleteButton = vgui.Create( "DButton", infoPanel )
      infoDeleteButton:SetPos( 10, 267 )
      infoDeleteButton:SetSize( 264, 22 )
      infoDeleteButton:SetImage( "icon16/bin.png" )

      if editingEntType == "button" then
          infoDeleteButton:SetText( "#easydoorbell.permplace.deletebutton" )
      elseif editingEntType == "speaker" then
          infoDeleteButton:SetText( "#easydoorbell.permplace.deletespeaker" )
      end

      infoDeleteButton.DoClick = function()
        net.Start( "EasyDoorbellDeletePermEntity" )
        net.SendToServer()
        frame:Remove()
      end
  end


  --Save changes button
  local saveButton = vgui.Create( "DButton", frame )
  saveButton:SetText( "#easydoorbell.permplace.savechanges" )
  saveButton:SetPos( 10, 368 )
  saveButton:SetSize( 280, 22 )
  saveButton:SetImage( "icon16/disk.png" )
  saveButton.DoClick = function()
  net.Start( "EasyDoorbellSavePermSettings" )
  net.SendToServer()
  frame:Remove()
  end

  frame:SetVisible( true )
  frame:MakePopup()
end

--------------------------------------------------------------------------------
-- Process netmessage to open GUI
--------------------------------------------------------------------------------
net.Receive( "EasyDoorbellOpenPermMenu", function()
  local type = net.ReadString()
  local permID = net.ReadString()

  --Netstrings can't be nil so we have to do this
  if type == "" then type = nil end
  if permID == "" then type = nil end

  OpenPermButtonMenu( type, permID )
end)
