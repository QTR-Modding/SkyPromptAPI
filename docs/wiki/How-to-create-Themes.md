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
| prompt_alignment | How prompts are arranged: "vertical", "horizontal", or "radial" |
| prompt_order | Whether the icon or text appears first: `"icon-first"` or `"text-first"` (default: `"icon-first"`) |
| prompt_pivot | Which point of the prompt content is anchored to its screen position: `"top-left"`, `"top-right"`, `"bottom-left"`, `"bottom-right"`, or `"center"` (default: `"bottom-right"`). Applies to vertical and horizontal layouts. |
| fadeSpeed | How quickly prompts fade in/out (smaller = slower) |
| progress_speed | How fast a “hold” / progress circle fills |

#### Special Visual Effects (Advanced – AddOn Needed)

If you use the [SkyPrompt AddOn](https://github.com/QTR-Modding/SkyPromptAddOn/wiki), you can enable extra visual effects.

| Field | What it does |
|-------|--------------|
| special_effect | Which effect to use (0 = none). Other numbers = different effects. |
| special_integers | Extra numbers the effect uses (e.g. colors). |
| special_floats | Extra decimal numbers (offsets, speeds, etc.). |
| special_bools | True/False switches to turn parts of an effect on/off. |
| special_strings | Extra text parameters (rarely needed). |

See [SkyPrompt-Addon wiki](https://github.com/QTR-Modding/SkyPromptAddOn/wiki) for more info.

---

### Example

SkyPrompt is shipped with example theme files. Please see those or other mods that use the theme feature.

### Tips

- You can remove any field you don’t use; defaults will be applied.
- If you are going to switch between themes using the same client ID, make sure to specify all JSON fields you intend to use in all your themes.