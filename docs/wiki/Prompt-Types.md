# PromptType

The `PromptType` specifies the type of the prompt you are sending to the player.<br>
It determines the input action required for the prompt to be accepted. <br>
This enables designing prompts for different interaction styles.

## Full List of the Types

### 0 = `kSinglePress`
- The player must press the assigned button or key once.
- Most common interaction type.
- Suitable for simple actions like **Open**, **Activate**, or **Confirm**.
>⚠️ The user cannot decline `kSinglePress` prompts (see `kDecline` in [PromptEventTypes](https://github.com/QTR-Modding/SkyPromptAPI/wiki/Prompt-Event-Types))!

![kSinglePress](https://github.com/QTR-Modding/SkyPromptAPI/blob/main/resources/gifs/kSinglePress.gif)


### 1 = `kHold`
- The player must press and hold the assigned button or key briefly.
- Holding the button will cause a progress circle to fill until it completes the circle, and the prompt will be counted as accepted.
- Prevents accidental activation.
- Suitable for actions like **Delete**, **Drop**, or **Dangerous Action**.

![kHold](https://github.com/QTR-Modding/SkyPromptAPI/blob/main/resources/gifs/kHold.gif)


### 2 = `kHoldAndKeep`
- The player must press and continuously hold the button or key.
- The prompt remains active only while the button is held and the progress circle is complete.
- Suitable for actions like **Charge**, **Aim**, or **Maintain**.

![kHoldAndKeep](https://github.com/QTR-Modding/SkyPromptAPI/raw/main/resources/gifs/kHoldAndKeep.gif)

### 3 = `kHint`
- Same as `kSinglePress`, but it does not block device inputs.

### 4 = `kHintHold`
- Same as `kHold`, but it does not block device inputs.

### 5 = `kHintHoldAndKeep`
- Same as `kHoldAndKeep`, but it does not block device inputs.
