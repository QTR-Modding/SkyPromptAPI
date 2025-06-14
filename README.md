# SkyPrompt API

https://www.nexusmods.com/skyrimspecialedition/mods/148703

---

## Installation (via vcpkg)

Add to your `vcpkg.json`:

```json
"dependencies": [
  "skyprompt-api"
]
```

In your `CMakeLists.txt`:

```cmake
find_path(SkyPromptAPI_INCLUDE_DIRS "SkyPrompt/API.hpp")
target_include_directories(your_target PRIVATE ${SkyPromptAPI_INCLUDE_DIRS})
```

This is a header-only library; no linking is needed.

---

## Tutorial
https://www.nexusmods.com/skyrimspecialedition/articles/10207

---
