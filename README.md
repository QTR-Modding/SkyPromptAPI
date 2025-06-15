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

To use the SkyPrompt API port locally, copy the cmake/ folder from the SkyPrompt API repository into your project:

```markdown
your-project/
└── cmake/
    └── ports/
        └── skyprompt-api/
            ├── portfile.cmake
            └── vcpkg.json

```
