## Create a theme

A theme controls how SkyPrompt's prompts look: their layout, position, size, font, and effects.
You can create one in-game or edit its JSON file in a text editor.

### Start in-game

1. Open **SkyPrompt > Theme** in the Mod Control Panel.
2. Choose the theme marked **(active)** to edit the prompts currently shown. The selector chooses what you edit; it does not make other mods use that theme.
3. Adjust **Layout**, **Position**, **Appearance**, and **Animation**. Close the menu to see the result.
4. Choose **Export Theme**, edit the suggested name if you want, and export. Enter the name without `.json`; SkyPrompt adds it.

Theme files go in `Data\SKSE\Plugins\SkyPrompt\themes\`. For example, exporting as
`MyTheme` creates `MyTheme.json`.

<a name="exporting-a-theme-in-game"></a>

| Action | What it does |
| --- | --- |
| Edit **Default** | Changes the fallback appearance for mods without an assigned theme. Changes save automatically to `Data\SKSE\Plugins\SkyPrompt\settings.json`. |
| **Save Theme** | Saves your edits to the selected named theme's existing file. Until you save, those edits last only for the current session or until reloaded. |
| **Export Theme** | Writes the selected theme's settings to the filename you enter. An existing file with that name is overwritten. |
| **Reload Themes** | Rereads already-loaded theme files, replacing any unsaved menu edits. It does not discover new filenames; restart Skyrim after adding a new file. |

Editing a file in the themes folder does not change **Default**.

### Use the theme in a mod

Creating a file does not automatically assign it to a mod. After registering with
SkyPrompt, a mod can request a theme for its `clientID` (the ID returned by registration):

```cpp
SkyPromptAPI::RequestTheme(clientID, "MyTheme");
```

In Papyrus, the equivalent is:

```papyrus
SkyPrompt.RequestTheme(clientID, "MyTheme")
```

Use the **filename without `.json`**, not the `name` written inside the file.
See the [C++ tutorial](https://github.com/QTR-Modding/SkyPromptAPI/wiki/SkyPrompt-API-Tutorial-(cpp)#optional-requesting-a-theme)
or [Papyrus tutorial](https://github.com/QTR-Modding/SkyPromptAPI/wiki/SkyPrompt-API-Tutorial-(Papyrus)#using-themes) for registration and complete examples.

To change a theme an existing mod already uses, edit that file and press **Reload Themes**.
You can also export to that same filename and reload it. Ship your theme at the
same path under `Data` so users receive the file your mod requests.

<a name="example"></a>

### Start with JSON instead

Save this as `MyTheme.json` in the themes folder, then use it as described above:

```json
{
    "name": "My Theme",
    "prompt_alignment": "vertical",
    "prompt_order": "icon-first",
    "prompt_size": 45.65
}
```

You can leave out settings you do not need. Missing fields use built-in theme-file
defaults, not your edited Default theme or values from a previously requested theme.
Export from the menu if you want a file that captures all your current settings.

Use decimal points for size, position, spacing, speed, and other float settings:
`1.0`, not `1`. Write `n_max_buttons` and effect IDs as integers, such as `4`.

<a name="diamond-layout"></a>

## Layouts

Choose **Prompt Alignment** in the menu or set `prompt_alignment` in JSON.

| Value | Arrangement |
| --- | --- |
| `vertical` | A column of prompts, from top to bottom. |
| `horizontal` | A row of prompts, from left to right. |
| `radial` | A curved column, with the icons and text rotated along the curve. |
| `diamond` | Bottom, right, left, then top. Further prompts repeat that order. Bottom/top rows grow left to right; left/right columns grow top to bottom. |
| `list` | A scrollable column. Only the selected prompt shows a button icon; the other visible prompts show text only. |

### Icon and text order

`prompt_order` controls the order **within a prompt**, not which prompt comes first.
Use `"icon-first"` for the icon before the text, or `"text-first"` for the reverse.

Diamond alternates this around its four sides: with `"icon-first"`, bottom/right
are icon-first and left/top are text-first. `"text-first"` reverses all four.
These positions do not depend on physical gamepad buttons; users can rebind their controls.

### Prompt count and scrolling

`n_max_buttons` defaults to `4`. Use a positive integer.

1. **Vertical, Horizontal, Radial, and Diamond:** it limits the number of separate prompts. Actions stacked on the same prompt share that slot.
2. **List:** it limits the number of visible rows, not the total. The mouse wheel or D-pad Up/Down selects other rows, scrolling when needed. Arrows show more rows above or below. Skyrim's **Activate** control operates the selected prompt, using that prompt's press/hold behavior.

Outside List, keep the number of input-blocking prompts small, especially for
gamepad users. More rows can also be useful for non-blocking prompts such as
[`kHint`](https://github.com/QTR-Modding/SkyPromptAPI/wiki/Prompt-Types).

<details>
<summary>Theme fields and defaults</summary>

These defaults apply when a field is missing from a theme file.

### Basic Info

| Field | Meaning |
| --- | --- |
| `name` | Display name for the theme. Theme requests still use the filename. |
| `description` | A short description. |
| `author` | Your name or nickname. |
| `version` | Your theme's version label. |

### Position on Screen

The position is an **anchor**: a point where SkyPrompt places the prompt group.
The pivot chooses which part of the group sits on that point.
Resolution-scaled pixels adjust with the game's display scale.

| Field | Meaning | Default |
| --- | --- | --- |
| `xPercent` | Horizontal anchor position: `0.0` is the left edge, `1.0` is the right edge. | `0.85` |
| `yPercent` | Vertical anchor position: `0.0` is the top edge, `1.0` is the bottom edge. | `0.85` |
| `marginX` | Offset in resolution-scaled pixels. Positive moves left; negative moves right. | `0.0` |
| `marginY` | Offset in resolution-scaled pixels. Positive moves up; negative moves down. | `0.0` |
| `prompt_pivot` | `"top-left"`, `"top-right"`, `"bottom-left"`, `"bottom-right"`, or `"center"`. Applies to every layout except Radial. | `"bottom-right"` |

For example, `xPercent: 1.0` with `marginX: 40.0` places the anchor 40
resolution-scaled pixels left of the right edge. With `"bottom-right"` as the pivot,
the group extends left and up from its anchor.

For prompts attached to world objects, the object supplies the anchor instead of
`xPercent`/`yPercent`. Margins still apply.

### Size & Spacing

| Field | Meaning | Default |
| --- | --- | --- |
| `n_max_buttons` | Separate prompt limit, or visible row count in List. See [Prompt count and scrolling](#prompt-count-and-scrolling). | `4` |
| `prompt_size` | Text size in resolution-scaled pixels. Icons scale with it. | `45.65` |
| `icon2font_ratio` | Icon size relative to the text size. `1.0` uses the same size. | `1.0` |
| `linespacing` | Extra spacing between prompts. Higher values spread them farther apart. | `0.267` |

### Look & Feel

| Field | Meaning | Default |
| --- | --- | --- |
| `prompt_alignment` | One of the five [layouts](#layouts). | `"vertical"` |
| `prompt_order` | `"icon-first"` or `"text-first"`; see [Icon and text order](#icon-and-text-order). | `"icon-first"` |
| `font_name` | Font filename, including `.ttf` or `.otf`, from `Data\Interface\ImGuiIcons\Fonts\`. Include any custom font in your mod. | `"Jost-Regular.ttf"` |
| `font_shadow` | Text shadow opacity: `0.0` is none, `1.0` is fully opaque. | `0.2` |
| `fadeSpeed` | Fade-in/out speed. Higher is faster; use a positive value. | `0.02` |
| `progress_speed` | How quickly a held button fills its progress circle. Higher values shorten progress-based holds; use a positive value. | `0.552` |

</details>

<a name="special-visual-effects-advanced--addon-needed"></a>

## Special Visual Effects

Open **Special Effects > Add Effect** in the Theme editor. Choose an effect,
expand its settings, and adjust it. The X beside its name removes it.
You can combine different effects.

| Effect | What it does | JSON ID |
| --- | --- | --- |
| Viny Arcs | Decorative glowing arcs around the prompt group. | `1` |
| Text Background | A colored background behind each prompt's text, excluding the icon. | `2` |
| Progress Circle | Customizes the progress circle, track, and feedback marks. | `3` |
| List Indicators | Customizes the arrows for hidden List rows. | `4` |
| Activation Pop | Adds a growing, fading copy when a prompt is activated. **Icon Only** leaves out the text. | `5` |

Normal progress feedback and List arrows already appear without adding effects.
Add Progress Circle or List Indicators to change or hide them. Activation Pop is
triggered by activating a prompt, not by moving the List selection.

### Effects in JSON

Add `special_effects` to a theme. It is a list, with one entry per effect;
`special_effect` identifies the effect by its number above. For example:

```json
{
    "name": "My Theme",
    "special_effects": [
        { "special_effect": 5 }
    ]
}
```

This complete theme enables Activation Pop with its defaults. To combine it with
a text background and make the pop icon-only:

```json
{
    "name": "My Theme",
    "special_effects": [
        { "special_effect": 2, "special_floats": [8.0, 4.0, 3.0] },
        { "special_effect": 5, "special_bools": [true] }
    ]
}
```

The background has 8 pixels of horizontal padding, 4 pixels of vertical padding,
and a 3-pixel corner radius. The pop's `true` turns on **Icon Only**.
When editing an existing theme, keep its other fields and change only the effects.

<details>
<summary>Effect parameters and defaults</summary>

### Reading the settings

`special_floats` holds decimal numbers, `special_bools` holds `true`/`false`
switches, and `special_integers` holds whole numbers such as colors.
`special_strings` is available for effects that need text values; effects 3-5 do not use it.

Values go in square brackets, in the order shown below. Position 0 means the
first value. For example, Activation Pop's `[0.3, 1.25, 0.6]` means a duration of
0.3 seconds, an end scale of 1.25, and an opacity of 0.6. To change a later value,
include the earlier values too. You can leave out trailing values to keep their defaults.

For colors, use the in-game color picker and **Export Theme** to get the numbers
for your JSON. For manual conversion, the format is unsigned packed ABGR, written
as a decimal integer. Color `0` is fully transparent. In the color defaults below,
RGBA means red, green, blue, and alpha; each ranges from 0 to 255, with alpha
controlling transparency.

### Viny Arcs (ID 1)

See the [Viny Arcs settings](https://github.com/QTR-Modding/SkyPromptAddOn/wiki/Special-Effects#effect-1-layered-gradient-arcs)
in the AddOn wiki for its colors, offsets, and switches.

### Text Background (ID 2)

`special_floats`, in order: horizontal padding, vertical padding, corner radius.
All default to `0.0` and use screen pixels. Padding is added to each side of the
text, so horizontal padding of `8.0` adds 8 pixels on both the left and right.
Negative padding shrinks the background; a negative corner radius is treated as zero.

`special_integers`: background color, default black with alpha 128
(`2147483648`). There are no boolean or text settings.

### Progress Circle (ID 3)

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

### List Indicators (ID 4)

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

### Activation Pop (ID 5)

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

### Older theme files

The older single-effect format still works. If a file contains both that format
and `special_effects`, the list takes precedence. An empty list (`"special_effects": []`)
removes configured effects; normal progress circles and List arrows remain.
In the older format, `"special_effect": 0` means no extra effect.
For example, this older Text Background theme still works:

```json
{
    "name": "My Theme",
    "special_effect": 2,
    "special_floats": [8.0, 4.0, 3.0]
}
```

</details>

## Community effects

[SkyPromptAddOn](https://github.com/QTR-Modding/SkyPromptAddOn) contains community-created special effects.
Its [guide](https://github.com/QTR-Modding/SkyPromptAddOn/wiki/Special-Effects#adding-more-effects)
explains how to add an effect.
