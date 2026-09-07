### Theme JSON – Simple Guide

A “theme” is a .json file that tells SkyPrompt how the prompts should look (position, size, colors, effects, etc.).  
You can edit these with any text editor (Notepad, VS Code, etc.).

Put your theme files here:
`Data\SKSE\Plugins\SkyPrompt\themes\`

---

#### Basic Info

| Field | What it is |
|-------|------------|
| name | A name for your theme |
| description | A short explanation |
| author | Your name or nickname |
| version | Your version label |

#### Position on Screen

| Field | What it does | Typical Values |
|-------|--------------|----------------|
| xPercent | Horizontal placement (0 = far left, 1 = far right) | 0.85 (near right) |
| yPercent | Vertical placement (0 = top, 1 = bottom) | 0.85 (lower area) |
| marginX | Extra left/right offset (added after xPercent) | 0–40 |
| marginY | Extra up/down offset | 0–40 |

#### Size & Spacing

| Field | What it does |
|-------|--------------|
| n_max_buttons | Maximum number of (not-stacked) prompts to display |
| prompt_size | General size of the prompt buttons/text |
| icon2font_ratio | Makes icons bigger or smaller vs the text (1.0 = same size) |
| linespacing | Space between prompts |

> ⚠️**Important**⚠️<br>
Please use the `n_max_buttons` setting wisely!<br>
SkyPrompt by default limits this to 4.<br>
The reason for this is not to block an excessive number of buttons that will harm the user experience, especially for gamepad users!<br>
If you are blocking more than 4 buttons, please reconsider your design!<br>
This option is made available to mod authors who need to display more than 4 buttons <u>**whose inputs are not blocked**</u>, e.g. by using the Seal of Akatosh "button" or the prompt type `kHint`.

#### Look & Feel

| Field | What it does |
|-------|--------------|
| font_name | The font to use (must be installed by the mod). <br>Including the extension is recommended (e.g. Jost-Regular.ttf). |
| font_shadow | Strength of a soft shadow behind text (0 = none, higher = stronger) |
| prompt_alignment | How prompts are arranged: "vertical", "horizontal", "radial", or "diamond" |
| prompt_order | Whether the icon or text appears first: `"icon-first"` or `"text-first"` (default: `"icon-first"`) |
| prompt_pivot | Which point of the prompt content is anchored to its screen position: `"top-left"`, `"top-right"`, `"bottom-left"`, `"bottom-right"`, or `"center"` (default: `"bottom-right"`). Applies to vertical, horizontal, and diamond layouts. |
| fadeSpeed | How quickly prompts fade in/out (smaller = slower) |
| progress_speed | How fast a “hold” / progress circle fills |

#### Diamond Layout

`diamond` places Button1 at the bottom, Button2 on the right, Button3 on the left, and Button4 at the top. Further buttons repeat this order. The bottom and top rows grow left to right; the right and left columns grow top to bottom.

With `icon-first`, bottom/right buttons place the icon first, while left/top buttons place the text first. `text-first` reverses this.

#### Exporting a Theme In-Game

Open SkyPrompt's Theme page and select **Export Theme**. Enter a filename; SkyPrompt saves the current settings to `Data\SKSE\Plugins\SkyPrompt\themes\<name>.json`. Reusing a filename overwrites it.

Use **Reload Themes** after overwriting a loaded theme. A new filename appears after restarting the game.

<a name="special-visual-effects-advanced--addon-needed"></a>

#### Special Visual Effects

Special effects change how prompts look. You can set them up in-game without editing JSON.

##### Try it in-game

Activation Pop adds a growing, fading copy when you activate a prompt.

1. Open **SkyPrompt > Theme** in the Mod Control Panel and choose the theme marked **(active)**.
2. Open **Special Effects**, choose **Add Effect**, then **Activation Pop**.
3. Enable **Icon Only** if you want just the button icon to pop. Close the menu and activate a prompt to try it.

You can adjust the pop's duration, size, and opacity, or leave the defaults.
The X beside an effect removes it. Use **Save Theme** to keep changes to a named
theme; **Default** saves automatically. **Export Theme** saves a separate theme file.

##### Edit a theme file

Here is a complete, minimal theme with Activation Pop:

```json
{
    "name": "My Theme",
    "special_effects": [
        { "special_effect": 5 }
    ]
}
```

`special_effects` is the list of effects to use. Each entry's `special_effect`
number identifies an effect; `5` means Activation Pop. Settings you leave out use
their defaults.

When editing an existing theme, keep its other fields and change only its
`special_effects` section.
After editing the file your mod uses, press **Reload Themes**. Creating a file
with a new name does not automatically make a mod use it.

##### Combine effects

Add another entry to the list. This example combines a text background with an
icon-only activation pop:

```json
{
    "name": "My Theme",
    "special_effects": [
        { "special_effect": 2, "special_floats": [8.0, 4.0, 3.0] },
        { "special_effect": 5, "special_bools": [true] }
    ]
}
```

The background gets 8 pixels of horizontal padding, 4 pixels of vertical padding,
and a 3-pixel corner radius. The pop's `true` turns on **Icon Only**.

<details>
<summary>JSON settings reference</summary>

###### Effect numbers

| Number | Effect |
| --- | --- |
| 1 | Viny Arcs |
| 2 | Text Background |
| 3 | Progress Circle |
| 4 | List Indicators |
| 5 | Activation Pop |

For Viny Arcs and Text Background details, see the [SkyPrompt AddOn wiki](https://github.com/QTR-Modding/SkyPromptAddOn/wiki).
Normal progress feedback and List arrows do not need an effect entry. Add effect
3 or 4 to customize or hide them. Activation Pop appears only when you add effect 5.

###### Reading the settings

`special_floats` holds decimal numbers, `special_bools` holds `true`/`false`
switches, and `special_integers` holds whole numbers such as colors.
`special_strings` is available for effects that need text values; effects 3-5 do not use it.

Values go in square brackets, in the order shown below. Position 0 means the
first value. For example, Activation Pop's `[0.3, 1.25, 0.6]` means a duration of
0.3 seconds, an end scale of 1.25, and an opacity of 0.6. To change a later value,
include the earlier values too. You can leave out trailing values to keep their defaults.

Write decimal values with a decimal point, such as `1.0` rather than `1`.
For colors, use the in-game color picker and **Export Theme** to get the numbers
for your JSON. For manual conversion, the format is unsigned packed ABGR, written
as a decimal integer. Color `0` is fully transparent. In the color defaults below,
alpha ranges from 0 (transparent) to 255 (opaque).

###### Progress Circle (ID 3)

These settings change the circle's appearance, not how long an action must be held.

`special_floats`:

| Position | Setting | Default | Range |
| --- | --- | --- | --- |
| 0 | Radius multiplier | 1.0 | 0-4 |
| 1 | Thickness multiplier | 1.0 | 0-8 |
| 2 | Horizontal offset (screen pixels) | 0.0 | -500 to 500 |
| 3 | Vertical offset (screen pixels) | 0.0 | -500 to 500 |
| 4 | Clockwise rotation (degrees) | 0.0 | -360 to 360 |
| 5 | Hold marker size multiplier | 1.0 | 0-4 |

`special_integers`, in order: progress arc (white, alpha 180), completed
(RGBA 228,185,76,180), track (white, alpha 30), hold marker (white, alpha 180),
remove marker (RGBA 147,39,41,180), skip marker (RGBA 228,185,76,100).

`special_bools`, in order: show arc, show track, show hold marker, show
special-command marks, clockwise. All default to `true`. Turning clockwise off
also mirrors the arc's starting position to the other side of the hold marker.

###### List Indicators (ID 4)

These settings control the arrows that show when more List rows are hidden above or below.

`special_floats`:

| Position | Setting | Default | Range |
| --- | --- | --- | --- |
| 0 | Arrow size multiplier | 1.0 | 0-4 |
| 1 | Horizontal offset (screen pixels) | 0.0 | -500 to 500 |
| 2 | Vertical offset (screen pixels) | 0.0 | -500 to 500 |
| 3 | Extra space between arrow and nearest row (screen pixels) | 0.0 | 0-500 |

`special_integers`: up arrow color, then down arrow color; both default to opaque white.

`special_bools`: show arrows, default `true`. Hiding arrows or setting their size
to zero also removes their reserved space. This effect applies only to List.

###### Activation Pop (ID 5)

The pop is a temporary copy of the activated icon and text. It grows and fades
without moving the original. **Icon Only** leaves out the text and grows the icon
from its center.

`special_floats`:

| Position | Setting | Default | Range |
| --- | --- | --- | --- |
| 0 | Duration (seconds) | 0.3 | 0.01-3 |
| 1 | End scale (1 keeps the original size) | 1.25 | 1-3 |
| 2 | Starting opacity (0 is invisible, 1 is opaque) | 0.6 | 0-1 |

`special_bools`: icon only, default `false`.

The full copy includes the text shadow, but not the progress circle or text
background. It can finish after the original prompt disappears. There are no color settings.

###### Older theme files

The older single-effect format still works. If a file contains both that format
and `special_effects`, the list takes precedence. An empty list (`"special_effects": []`)
removes configured effects; normal progress circles and List arrows remain.
In the older format, `"special_effect": 0` means no extra effect.

</details>

<details>
<summary>For developers adding a new effect to SkyPrompt</summary>

The source paths below are in the [SkyPrompt repository](https://github.com/QTR-Modding/SkyPrompt).
1. Choose an unused effect number and keep existing numbers unchanged. IDs 1-2 belong to SkyPromptAddOn; IDs 3-5 belong to SkyPrompt.
2. Add the parameter names, defaults, ranges, and effect definition in `src/ImGui/PromptEffects.h/.cpp`. Add the effect to the Theme menu's supported effects in `src/MCP.cpp`.
3. Add drawing code to the appropriate existing prompt drawing module. Add English labels and help text to both `src/Translations.cpp` and `Interface/Translations/SkyPrompt_ENGLISH.txt`.
4. Document the settings on this page. Check defaults, custom values, menu editing, save/reload, export, and drawing in the relevant layouts. Effects implemented in SkyPrompt ship with SkyPrompt, not SkyPromptAddOn.

</details>

---

### Example

SkyPrompt is shipped with example theme files. Please see those or other mods that use the theme feature.

### Tips

- You can remove any field you don’t use; defaults will be applied.
- If you are going to switch between themes using the same client ID, make sure to specify all JSON fields you intend to use in all your themes.