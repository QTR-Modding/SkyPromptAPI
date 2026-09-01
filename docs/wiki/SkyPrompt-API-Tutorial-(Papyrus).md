# SkyPrompt Papyrus API Documentation

The SkyPrompt Papyrus API allows you to create, display, and manage interactive prompts from Papyrus scripts. <br>
This enables mod authors to add custom UI prompts and handle user input directly from their scripts.<br>
Do not forget to install [SkyPrompt](https://www.nexusmods.com/skyrimspecialedition/mods/148703) to use the API.

> ⚠️ [Watch the full tutorial video on YouTube!](https://youtu.be/TTSWAxGN17o?si=Iocnwy4HXKhynKCc)

---
## API functions
The API functions made available by the SkyPrompt API can be found in [SkyPrompt's main file](https://www.nexusmods.com/skyrimspecialedition/mods/148703?tab=files) at Scripts/Source/SkyPrompt.psc.

## Registering for SkyPrompt Events

### Register
Before you can send or receive prompt events, you must register your script for SkyPrompt events. <br>
This way, your script will become a client and it will get a client ID.<br>
You will need this client ID to be able to use the API functions.<br>

```papyrus
int clientID = SkyPrompt.RegisterForSkyPromptEvent(self as Form)
```
- **Returns**: A unique client ID for your script.
> ⚠️Make sure the client ID returned here is non-zero!
- **Parameter**: `akForm` is the script/Form you want to receive events on.
>⚠️
Note that we are giving a Form above. <br>
Essentially, the Form becomes the client and SkyPrompt matches the Form with the client ID.<br>
SkyPrompt will yield only one unique client ID per unique Form.<br>
Recommended: Use a Quest Form to register, so the logic is centralized and global.

### Unregister

```papyrus
bool success = SkyPrompt.UnregisterFromSkyPromptEvent(self as Form)
```

---

## Compatibility Handshakes

`RequestHandshake` allows two SkyPrompt clients to declare that their prompts are compatible and may be displayed together.
Normally, prompts from different clients use separate pages, or the newer prompts replace the previous client's prompts when prompt cycling is disabled.

Each mod author chooses a positive integer handshake key and exchanges it with the other author. After registering and receiving non-zero client IDs, both clients submit reciprocal requests:

```papyrus
; Example values only -- choose your own keys.
Int modAKey = 1
Int modBKey = 2

; Mod A
Bool modARequestAccepted = SkyPrompt.RequestHandshake(clientA, modAKey, modBKey)

; Mod B
Bool modBRequestAccepted = SkyPrompt.RequestHandshake(clientB, modBKey, modAKey)
```

The handshake is completed once both reciprocal requests have been received.

Compatibility is pairwise and not transitive. If A is compatible with B and B is compatible with C, A is not automatically compatible with C. For all three clients to display together, every pair must handshake.

Clients retain their own client IDs. Prompt events are still delivered with the originating client's original event and action IDs.

Call `RequestHandshake` after obtaining a non-zero client ID and preferably before sending the first prompt.

A return value of `true` means the request was accepted; it may still be waiting for the reciprocal request. `false` means the client ID was invalid.

---

## Sending a Prompt

Prompts can be displayed with:

### 1. Specified keys for respective devices:

```papyrus
bool success = SkyPrompt.SendPrompt(
    Int clientID,
    string text,
    Int eventID,
    Int actionID,
    Int promptType,
    Form refForm,
    Int[] devices,
    Int[] keys,
    float progress=0.0
)
```

### 2. The game's control mapping:

```papyrus
bool success = SkyPrompt.SendPromptForControl(
    Int clientID,
    string text,
    Int eventID,
    Int actionID,
    Int promptType,
    Form refForm,
    String controlName,
    Int contextID=0,
    float progress=0.0
)
```

- **clientID**: The ID returned by `RegisterForSkyPromptEvent`.
- **text**: The prompt text to display.
- **eventID**: An integer to identify the prompt. Used to set the row position of the prompt.
- **actionID**: An integer to identify the prompt. Used to set the position of the prompt in the same row when multiple prompts are stacked in the same row.
- **promptType**: The type of prompt. The list of Prompt types can be found [here](https://github.com/QTR-Modding/SkyPromptAPI/wiki/Prompt-Types).
- **refForm**: The object reference the prompt is attached to. Can be `None`.
- **devices**: Array of input device enums. Can be empty.
- **keys**: Array of key codes, one for each device. Can be empty.
- **controlName**: Name of the control. See [here](https://ck.uesp.net/wiki/GetMappedKey_-_Input#Parameters) or [here](https://github.com/QTR-Modding/CommonLibSSE-NG/blob/7d97ad2a224e6b1dd27adaf10eb0bd68e3133207/include/RE/U/UserEvents.h#L66).
- **contextID**: (Optional, default: `0`) Context for the input. You will mostly need `Gameplay`, which is `0`. See [here](https://github.com/QTR-Modding/CommonLibSSE-NG/blob/7d97ad2a224e6b1dd27adaf10eb0bd68e3133207/include/RE/U/UserEvents.h#L13) for the full list. 
- **progress**: (Optional, default: `0.0`) It allows you to take control of the progress circle (see the Advanced Features documentation for more info).

> **Note**: `devices` and `keys` must be the same length. The list of devices and keys can be found [here](https://github.com/QTR-Modding/SkyPromptAPI/wiki/Devices-and-Key-Codes).<br>

> ⚠️ Text values can use `$LocalizationKeys` to hook into the game's built-in translation system for multi-language support.

---

## Removing a Prompt

```papyrus
SkyPrompt.RemovePrompt(int clientID, int eventID, int actionID)
```

---

## Handling Prompt Events

Your script will receive the `OnSkyPromptEvent` event when the player interacts with a prompt:

```papyrus
Event OnSkyPromptEvent(int clientID, int eventType, int eventID, int actionID, float deltaX, float deltaY, float progress)
    ; Handle the event here
EndEvent
```

- **clientID**: The client ID for your script.
> ⚠️ Make sure `clientID` belongs to your mod!
- **eventType**: The type of event. The full list of event types can be found [here](https://github.com/QTR-Modding/SkyPromptAPI/wiki/Prompt-Event-Types).
- **eventID**, **actionID**: Identifiers you specified.
- **deltaX**, **deltaY**: Analog input deltas from mouse or thumbstick movement (0 otherwise).
- **progress**: Filled fraction of the progress circle, if you are using this feature.

---

### Example

```papyrus
Scriptname MyPromptScript extends Quest

int myClientID

Event OnInit()
    myClientID = SkyPrompt.RegisterForSkyPromptEvent(self as Form, 2, 0)

    int[] devices = new int[1]
    int[] keys = new int[1]
    devices[0] = 0 ; Keyboard
    keys[0] = 59 ; Key code for '1'

    SkyPrompt.SendPrompt(myClientID, "Press 1 to continue", 0, 0, 1, None, devices, keys, 0.0)
EndEvent

Event OnSkyPromptEvent(int clientID, int eventType, int eventID, int actionID, float deltaX, float deltaY, float progress)
    if eventType == 0 ; Accepted
        Debug.Notification("Prompt accepted!")
        SkyPrompt.RemovePrompt(clientID, eventID, actionID)
    endif
EndEvent
```

## Using Themes

You can assign a custom visual theme to your ClientID so your prompts use a different layout, fonts, animation speeds, alignment (vertical, horizontal, radial, etc.), and special effects.<br>
Themes are implemented via JSON files. See [here](https://github.com/QTR-Modding/SkyPromptAPI/wiki/How-to-create-Themes%3F) for how to create these.

### Example

Minimal quest script snippet that uses the JSON file **SkyPromptTestScriptTheme.json**.<br>
Make sure to give the name of the theme file **without** the extension `.json`. <br>
Please also check the "Key Points" section [here](https://github.com/QTR-Modding/SkyPromptAPI/wiki/SkyPrompt-API-Tutorial-(cpp)#optional-requesting-a-theme).

```papyrus
scriptName SkyPromptTestScript extends Quest

Int clientID = 0

Event OnInit()
    clientID = SkyPrompt.RegisterForSkyPromptEvent(self as Form,2,0)
    if (clientID == 0)
        Debug.Notification("SkyPrompt test failed to register")
        return
    Else
        Debug.Notification("SkyPrompt test registered successfully" + clientID)
        if (SkyPrompt.RequestTheme(clientID, "SkyPromptTestScriptTheme"))
            Debug.Notification("SkyPrompt test theme requested successfully")
        else
            Debug.Notification("SkyPrompt test theme request failed")
        endif
    endif
EndEvent
```
