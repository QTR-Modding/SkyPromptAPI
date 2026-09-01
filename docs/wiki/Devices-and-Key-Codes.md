# Devices and Key Codes

SkyPrompt has default keys that will be assigned to your prompts **if you do not provide custom keys**. <br>
You have the option to provide custom keys for each device.

# Devices

### 0 = `Keyboard`

### 1 = `Mouse`

### 2 = `Gamepad`


# Keycodes

The list of keycodes can be found [here](https://github.com/QTR-Modding/SkyPromptAPI/blob/main/Keycodes). <br>
These keycodes map directly to the ones in CommonLib (e.g., in the REX::WIN32, etc. namespaces), making them especially convenient for SKSE DLL mod authors.

As of [v2.3.8 of SkyPrompt](https://github.com/QTR-Modding/SkyPrompt/releases/tag/v2.3.8), [DXScanCodes](https://ck.uesp.net/wiki/Input_Script#DXScanCodes) can also be used.


There are also some custom keys defined in SkyPrompt:
### 283 = `kMouseMove`
In case you want to tie your prompt to mouse moves.

### 284 = `kThumbstickMoveL`
### 285 = `kThumbstickMoveR`
In case you want to tie your prompt to thumbstick moves.

### 286 = `kSkyrim`
This is a pseudo-button (Seal of Akatosh), i.e., it will be displayed on the screen, but it will not block any user inputs.<br>
You can use this e.g., to display hints on the screen.