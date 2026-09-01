# PromptEventType

The `PromptEventType` defines the types of events that can occur in response to a prompt. <br>
These events reflect player interactions and system-driven changes.<br>
See [here](https://youtu.be/TTSWAxGN17o?si=BRvznQaFY9gf0r-p&t=555) for a video explanation of the Prompt Event Types.

## The Full List of Prompt Event Types

### 0 = `kAccepted`
- The player accepted or confirmed the prompt.
- Triggered by the expected input (press or hold).

### 1 = `kDeclined`
- The player declined or dismissed the prompt.
- Typically triggered by a cancel action.

### 2 = `kRemovedByMod`
- The prompt was removed by a mod or script.
- Not caused by player input.
- See [here](https://youtu.be/TTSWAxGN17o?si=J_bQ4O930InFDx5C&t=698) for more explanation.

### 3 = `kTimingOut`
- The prompt is about to time out.
- Useful for handling last-moment logic.

### 4 = `kTimeout`
- The prompt has timed out.
- No longer available for interaction.

### 5 = `kDown`
- The assigned button or key was pressed down.
- May be followed by `kUp`.

### 6 = `kUp`
- The assigned button or key was released after being pressed.

### 7 = `kMove`
- An analog input was moved (e.g. mouse or gamepad stick).
- Movement delta is included in the event data.

These values enable full tracking of player interaction and system state for prompts.
