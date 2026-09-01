# SkyPrompt API Tutorial (C++)

Welcome to the SkyPrompt API tutorial! This guide will help you integrate SkyPrompt's prompt system into your C++ Skyrim plugins.

**Prerequisites**
* You must have access to the [SkyPrompt API header](https://github.com/QTR-Modding/SkyPromptAPI/blob/main/include/SkyPrompt/API.hpp) and ensure [SkyPrompt](https://www.nexusmods.com/skyrimspecialedition/mods/148703) is installed for users.

## Include the API
In order to use SkyPrompt in your mod, you will need to include the API header in your project.
```c++
#include "SkyPrompt/API.hpp"
```
You can obtain this by either copy-pasting or via vcpkg port. Follow the instructions in the [README](https://github.com/QTR-Modding/SkyPromptAPI/blob/main/README.md) for the latter.

## Implement a PromptSink
```c++
class MyPromptSink : public SkyPromptAPI::PromptSink {
public:
    std::span<const SkyPromptAPI::Prompt> GetPrompts() const override;
    void ProcessEvent(SkyPromptAPI::PromptEvent event) const override;
};
```

> I recommend implementing your `PromptSink` as a [singleton](https://github.com/qudix/skse-qui/blob/main/src/c%2B%2B/General/Singleton.hpp)!

### `GetPrompts`
SkyPrompt needs to be able to retrieve your prompts. <br>
Store them somewhere in your program inside containers (array, vector) and make sure that they stay alive throughout the program, e.g.
```c++
std::array<const SkyPromptAPI::Prompt,2> your_prompts = {prompt1,prompt2};
```
Then you can e.g.
```
std::span<const SkyPromptAPI::Prompt> GetPrompts() const override {return your_prompts;}
```

#### `SkyPromptAPI::Prompt`
* **text**:
(*Required*) The message or label shown to the player in the prompt UI.
> ⚠️ Text values can use `$LocalizationKeys` to hook into the game's built-in translation system for multi-language support.
* **eventID**:
(*Required*) An identifier for the prompt. Used to set its row position.
* **actionID**:
(*Required*) An identifier for the prompt. Used to set its position in the same row when multiple prompts are stacked in a single row.
* **type**:
(*Required*) The type of prompt.
> See [here](https://github.com/QTR-Modding/SkyPromptAPI/wiki/Prompt-Types) for the full list and explanation of the prompt types.
* **refid**:
(*Optional*) The FormID of an object reference this prompt is attached to.
* **button_key**:
(*Optional*) A list of input device/button pairs that can trigger this prompt (e.g., keyboard key, gamepad button). <br>
This allows custom keys for prompts. The default keys will be used if not provided. The user can change the default keys in the in-game menu.
> See [here](https://github.com/QTR-Modding/SkyPromptAPI/wiki/Devices-and-Key-Codes) for the full list of key codes.
* **text_color**:
(*Optional*) The color of the prompt text, in ABGR format (default is white: 0xFFFFFFFF).
* **progress**:
(*Optional*) The fraction of the progress circle. See Advanced Features documentation for more info.

```c++
using EventID = uint16_t;
using ActionID = uint16_t;
using ButtonID = uint32_t;

struct Prompt {
    std::string_view text;
    EventID eventID;
    ActionID actionID;
    PromptType type;
    RE::FormID refid;
    std::span<const std::pair<RE::INPUT_DEVICE, ButtonID>> button_key;
    uint32_t text_color;
    float progress;
    explicit Prompt(const std::string_view a_text="", const EventID a_eventID=0, const ActionID a_actionID=0,
        const PromptType a_type=PromptType::kSinglePress, const RE::FormID a_refid=0, 
        const std::span<const std::pair<RE::INPUT_DEVICE, ButtonID>> a_button_key={}, const uint32_t a_text_color=0xFFFFFFFF, 
        const float a_progress=0.f):
	text(a_text), eventID(a_eventID), actionID(a_actionID), type(a_type), refid(a_refid), button_key(a_button_key), 
        text_color(a_text_color), progress(a_progress) {}
    };

};
```

### `ProcessEvent`
Once you have sent some prompts, SkyPrompt will inform you how the user has interacted with those by sending events to your `PromptSink`, whose `GetPrompts` method yields the corresponding prompts.

#### `SkyPromptAPI::PromptEvent`
* **prompt**: This is a Prompt object that contains all the information about the prompt that triggered the event.
* **type**: This is a PromptEventType value that indicates what kind of event occurred for the prompt
> See [here](https://github.com/QTR-Modding/SkyPromptAPI/wiki/Prompt-Event-Types) for the full list of Prompt Event Types and explanation.
* **delta**: This is a std::pair<float, float> that provides additional data for the event, typically used for movement or analog input events (such as mouse or stick movement). For most prompt events, this will be (0, 0), but for kMove it will contain the movement delta values.

```c++
struct PromptEvent {
    Prompt prompt;
    PromptEventType type;
    std::pair<float,float> delta;
};
```


## Request a Client ID
In order to use the API functions, you will need a client ID.
> ⚠️ **Important:**<br>
> Your client ID must be non-zero!<br>
> ⚠️ **Important:**<br>
 Please make sure that you do not obtain more client IDs than you actually need! <br>
Most authors will need only one client ID throughout their program!<br>
Do not call `RequestClientID` many times unnecessarily; there is a limited amount of client IDs that can be provided!
```c++
using ClientID = uint16_t;
SkyPromptAPI::ClientID clientID = SkyPromptAPI::RequestClientID();
```

## Compatibility Handshakes
`RequestHandshake` allows two SkyPrompt clients to declare that their prompts are compatible and may be displayed together.
Normally, prompts from different clients get their own pages, which the user can cycle through, or if this option is disabled by the user, the later prompts win and delete the previous prompts from other mods. 
The Handshake feature is created to address this.

Each mod author chooses a unique 64-bit handshake key and exchanges it with the other author. After requesting their client IDs, both clients submit reciprocal requests:

```c++
// Example values only -- choose your own unique keys.
constexpr SkyPromptAPI::HandshakeKey modAKey = 1;
constexpr SkyPromptAPI::HandshakeKey modBKey = 2;

// Mod A
SkyPromptAPI::RequestHandshake(clientA, modAKey, modBKey);

// Mod B
SkyPromptAPI::RequestHandshake(clientB, modBKey, modAKey);
```

The handshake is completed once both reciprocal requests have been received.

Compatibility is pairwise and not transitive. If A is compatible with B and B is compatible with C, A is not automatically compatible with C. For all three clients to display together, every pair must handshake.

Clients retain their own client IDs. Prompt events are still delivered to the originating `PromptSink` with that client's original event and action IDs.

Call `RequestHandshake` after obtaining a non-zero client ID and preferably before sending the first prompt.

A return value of `true` means the request was accepted; it may still be waiting for the reciprocal request. `false` means the request was invalid.

`RequestHandshake` was added in SkyPromptAPI 2.0.3.

## Sending Prompts
You can send prompts by using the following function.<br>
It will take your prompt sink and your client ID.<br>
SkyPrompt will then acquire your prompts with the `GetPrompts` method of your `PromptSink` and display them on the screen.
```c++
SkyPromptAPI::SendPrompt(your_PromptSinkPtr, your_clientID);
```

## Removing Prompts
```c++
SkyPromptAPI::RemovePrompt(your_PromptSinkPtr, your_clientID);
```
> ⚠️⚠️⚠️**Important**⚠️⚠️⚠️<br>
If you are deleting your sink, you MUST call RemovePrompt BEFORE deleting your sink! <br>
Failing to do so will result in CTD!

## Handling Prompt Events
Once you send your prompts, the user can interact with these by pressing the corresponding button.
There are different types of interactions possible depending on the `PromptType` of your prompts.
You will get informed on these in the `ProcessEvent` method of your `PromptSink` associated with the corresponding prompts.
```c++
void ProcessEvent(SkyPromptAPI::PromptEvent event) const override {
    switch (event.type) {
        case SkyPromptAPI::PromptEventType::kAccepted:
            // User accepted the prompt
            break;
        case SkyPromptAPI::PromptEventType::kDeclined:
            // User declined the prompt
            break;
        // Handle other event types as needed
    }
}
```
## (Optional) Requesting a Theme

You can assign a custom visual theme to your ClientID so your prompts use a different layout, fonts, animation speeds, alignment (vertical, horizontal, radial, or diamond), and special effects.<br>
Themes are implemented via JSON files. See [here](https://github.com/QTR-Modding/SkyPromptAPI/wiki/How-to-create-Themes%3F) for how to create these.

```c++
bool ok = SkyPromptAPI::RequestTheme(clientID, "MyThemeFileName");
if (!ok) {
    // Theme not found or invalid clientID; default theme will be used.
}
```

Key points:
- Call this only AFTER you successfully obtained a non‑zero `clientID`.
- Theme JSON files live in:  
  `Data\SKSE\Plugins\SkyPrompt\themes\`
- The JSON filename (without `.json`) MUST be used in `RequestTheme`.
- Calling `RequestTheme` again with the same name reloads the file.
- Returns `true` on success, `false` if:
  - `clientID == 0`
  - `themeName` empty
  - Theme not found in the loaded set

### Example

SkyPrompt switches between its Tutorial and Default themes. See source code.

### Tips

- You can remove any field you don’t use; defaults will be applied.
- If you switch between themes via `RequestTheme` using the same client ID, make sure to specify all JSON fields you intend to use in all your theme files.

## Example
An example usage of SkyPrompt can be found here: [(header)](https://github.com/QTR-Modding/SkyPrompt/blob/main/include/Tutorial.h) and [(cpp)](https://github.com/QTR-Modding/SkyPrompt/blob/main/src/Tutorial.cpp). <br>
You could also check out other mods on [Nexus](https://www.nexusmods.com/skyrimspecialedition/mods/148703) that use SkyPrompt and their sources.

## Troubleshooting/Help/Feedback
Do not hesitate to contact us on our [Discord server](https://discord.gg/9cbZ5KPqQb)!