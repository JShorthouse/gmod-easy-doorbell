-- EasyDoorbell v2.0.1 --
Thank you for purchasing this addon!
If you have any issues, please leave a comment on the gmodstore page and I will get back to you as soon as possible.
If you enjoy this addon, please consider leaving a review! :D

-- INSTALLATION --
Place the "easydoorbell" root folder into your server's addons folder.
All client content (models, sounds, textures) will be automatically downloaded from the workshop.

-- CONFIG --
After loading the addon for the first time, a config file will be created in your data folder.

Config options:
MaxSpeakerVolume (0-1) - The maximum allowed volume of doorbell speakers
MinButtonCooldown (0 - infinity) - The minimum cooldown allowed for doorbell buttons
	(how long before the bell can be rung again)
MaxButtonCooldwon (0 - infinity) - The maximum cooldown allowed for doorbell buttons.
EnablePermLoading (true / false) - If permanent buttons / speakers should be loaded or not
EnablePermPlacement (true / false) - If placing permanent entities (/edb perm) should be allowed.
	Defaults to false if EnablePermLoading is false.


After you have tweaked these settings to your liking, reload the addon / restart the server to apply them.

Additionally, there are two convars that can be set to limit the amount of buttons and speakers:
sbox_maxeasydoorbell_buttons
sbox_maxeasydoorbell_speakers

Set these by adding +[convar name] [value] at the end of your server launch script

-- COMMANDS --
/edb perm - Opens the permanent placement menu
/edb about - Shows the current version

-- PLACING PERMANENT DOORBELLS --
This can only be done by admins

1) Look where you want the speaker to be placed and type /edb perm to bring up the menu
2) Go to the speaker tab and chose your settings then click the create button
3) Make note of the ID displayed in the chatbox
4) Move to where you would like to place the button and open the menu again
5) Configure the settings and enter the doorbell ID from earlier, then click create
6) If you are happy with the setup type /edb perm again and click the save button
7) If you want to see the ID of an entity, change its settings or remove it, type /edb perm
	while looking at it

-- TROUBLESHOOTING --
Players can't use doorbells placed by other players! - You probably have "Use protection" enabled.
	In your Q menu go to Utilities > Falco's Prop Protection > Admin Settings > Player use options.
	Here you can either deselect "Use protection enabled" or just add the button entity to the list
	and tick "The blocked list is a whitelist"

My permanent buttons / speakers disappear after I restart! - Ensure that you open the permanent
	placement menu again and click the save button before restarting

-- MODIFICATION --
Feel free to make your own modifications to this addon for use on your own server.
The code should be well documented, but if you are confused about anything, feel free to create
a support ticket and I will be happy to help you.

-- TRANSLATING --
You can translate this addon for your community by editing the language file at lua/easydoorbell/cl_language.lua
Note that once you have made changes to this file you will need to restart your game for them to take effect.

-- CREDITS --
Programming - Shorty
Models - Shorty
Textures - Shorty
Localisation Improvements - Blueberry

Translations
Russian - Blueberry

Sounds
Button - Shorty
Standard - kwhmah_02 https://freesound.org/people/kwahmah_02/sounds/319041/
Electronic - kwahmah_02 https://freesound.org/people/kwahmah_02/sounds/249303/
Bell - bone666138 https://freesound.org/people/bone666138/sounds/198841/
Buzzer - vtkproductions.com https://freesound.org/people/vtkproductions.com/sounds/131560/
