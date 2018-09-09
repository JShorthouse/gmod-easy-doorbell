--------------------------------------------------------------------------------
-- Easy Doorbell Language File
-- Edit this file to add your custom translations
--------------------------------------------------------------------------------

if CLIENT then
  --Button tool
  language.Add( "tool.easydoorbell_placebutton.name", "Doorbell Button" )
  language.Add( "tool.easydoorbell_placebutton.desc", "Creates a button for a doorbell speaker" )
  language.Add( "tool.easydoorbell_placebutton.left", "Place / Update button" )
  language.Add( "tool.easydoorbell_placebutton.cooldown", "Cooldown:" )
  language.Add( "tool.easydoorbell_placebutton.cooldown.help",
    "How long between presses before the bell can be rang again." )
  language.Add( "Undone_Doorbell Button", "Undone Doorbell Button")
  language.Add( "Cleanup_easydoorbell_buttons", "EasyDoorbell Buttons")
  language.Add( "Cleaned_easydoorbell_buttons", "Cleaned up all EasyDoorbell Buttons")

  --Speaker tool
  language.Add( "tool.easydoorbell_placespeaker.name", "Doorbell Speaker" )
  language.Add( "tool.easydoorbell_placespeaker.desc", "Creates a doorbell speaker" )
  language.Add( "tool.easydoorbell_placespeaker.left", "Select button to link / update speaker" )
  language.Add( "tool.easydoorbell_placespeaker.left_1",
    "Place new speaker / update existing speaker" )
  language.Add( "tool.easydoorbell_placespeaker.info",
    "Creates a doorbell speaker. First select the button you wish to link the speaker " ..
    "to and then select a location." )
  language.Add( "tool.easydoorbell_placespeaker.sound", "Sound:" )
  language.Add( "tool.easydoorbell_placespeaker.volume", "Volume:" )
  language.Add( "tool.easydoorbell_placespeaker.volume.help",
    "How far away the bell can be heard from. Wouldn't want to annoy the neighbours " ..
    "now would we?" )
  language.Add( "easydoorbell.sounds.standard", "Standard" )
  language.Add( "easydoorbell.sounds.electronic", "Electronic" )
  language.Add( "easydoorbell.sounds.bell", "Bell" )
  language.Add( "easydoorbell.sounds.buzzer", "Buzzer" )
  language.Add( "easydoorbell.sounds.buzzer", "Buzzer" )
  language.Add( "Undone_Doorbell Speaker", "Undone Doorbell Speaker" )
  language.Add( "Cleanup_easydoorbell_speakers", "EasyDoorbell Speakers" )
  language.Add( "Cleaned_easydoorbell_speakers", "Cleaned up all EasyDoorbell Speakers" )

  --Perm menu
  language.Add( "easydoorbell.permplace.tabbutton", "Button" )
  language.Add( "easydoorbell.permplace.tabspeaker", "Speaker" )
  language.Add( "easydoorbell.permplace.tabinfodelete", "Info / Delete" )
  language.Add( "easydoorbell.permplace.createnewbutton", "Create a New Button" )
  language.Add( "easydoorbell.permplace.editbutton", "Edit Button" )
  language.Add( "easydoorbell.permplace.speakerid.help",
    "Can be found by opening this panel while looking at a speaker and selecting the " ..
    "'Info / Delete' tab" )
  language.Add( "easydoorbell.permplace.createbutton", "Create Button" )
  language.Add( "easydoorbell.permplace.updatebutton", "Update Button" )
  language.Add( "easydoorbell.permplace.createnewspeaker", "Create a New Speaker" )
  language.Add( "easydoorbell.permplace.editspeaker", "Edit Speaker" )
  language.Add( "easydoorbell.permplace.createspeaker", "Create Speaker" )
  language.Add( "easydoorbell.permplace.updatespeaker", "Update Speaker" )
  language.Add( "easydoorbell.permplace.buttonid", "Button ID: " )
  language.Add( "easydoorbell.permplace.speakerid", "Speaker ID: " )
  language.Add( "easydoorbell.permplace.deletebutton", "Delete Button" )
  language.Add( "easydoorbell.permplace.deletespeaker", "Delete Speaker" )
  language.Add( "easydoorbell.permplace.savechanges", "Save Changes" )

  --Chat messages
  language.Add( "easydoorbell.message.nonpermanent",
    "The entity you are looking at is not permanent!" )
  language.Add( "easydoorbell.message.permplacedisabled",
    "Permanent placement is not enabled." ..
    "Ask the server owner to set 'EnablePermLoading' and 'EnablePermPlacement' " ..
    "to true in the config" )
  language.Add( "easydoorbell.message.nopermission",
    "You do not have permission to perform this command" )
  language.Add( "easydoorbell.message.serverrunning",
    "This sever is running Easy Doorbell version" )
  language.Add( "easydoorbell.message.invalidargument",
    "Unrecognised argument. Valid options are" )
  language.Add( "easydoorbell.message.and", "and" )
  language.Add( "easydoorbell.message.newbutton", "Created a new doorbell button with ID" )
  language.Add( "easydoorbell.message.newspeaker", "Created a new doorbell speaker with ID" )
  language.Add( "easydoorbell.message.speakerupdated", "Speaker settings updated" )
  language.Add( "easydoorbell.message.buttonupdated", "Button settings updated" )
  language.Add( "easydoorbell.message.entityremoved", "Entity removed" )
  language.Add( "easydoorbell.message.datawritten", "Perm data written to disk" )
end
