# Refreshing Prompts

You can use `SendPrompt` also to **refresh** your prompts if they're already visible.<br>
See [here](https://github.com/QTR-Modding/SkyPrompt/blob/main/include/Renderer.h#L12) for **`ButtonMutables`**, i.e., things you can refresh.<br>
Note that in this case, `SendPrompt` will return `false`, which is expected behavior, since your prompts are already displayed.<br>
In order to **update/refresh** one of the **mutables**, simply call `SendPrompt` again with your updated parameters/prompts.

# Progress Circle
## Controlling the Progress Circle
> ⚠️ Currently only available for Single-Press prompts.

You can take control of the progress circle that will appear around your button by giving a value to the `progress` field that is not `0.0`.

### Values in (0,1)
Values larger than 0 and smaller than 1 will set the progress circle to that fraction of the complete circle.

### Values in ℝ ∖ ℤ ###
You can give numbers that are not whole numbers (non-integers) to trigger special instructions to SkyPrompt.
SkyPrompt will map these numbers to an integer and a fractional part:
$x \mapsto (z, r) \in ℤ \oplus (0, 1)$,
where the integer part will be a **multiplier** and the fractional part the **fraction** of the full circle as before.
The progress circle will then move starting from the **fraction** at the speed of the **multiplier**.
#### The Multiplier
Currently, a multiplier of magnitude 1 will lead to a full circle progress in 10 seconds.
#### Direction of the progress
The direction of the movement of the progress circle can be controlled by the sign of the value.
A positive value will lead to a decreasing progress, vice versa.
>⚠️ Important!
Once the progress circle reaches 0 or 1, you will get a `kDeclined` event in both cases.<br>
#### Examples
1. A prompt that gives the user a 1-second window to perform a certain action: `10.99`
2. A prompt that gives the user to execute an action earlier that will auto-perform itself in 5 seconds: `-2.01`
3. `Tutorial4` (Quick-Time) and `Tutorial5` (Button-Mash) in [`Tutorial.h`](https://github.com/QTR-Modding/SkyPrompt/blob/main/include/Tutorial.h) and [`Tutorial.cpp`](https://github.com/QTR-Modding/SkyPrompt/blob/main/src/Tutorial.cpp).