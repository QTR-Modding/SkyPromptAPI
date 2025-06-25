# header-only library
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO QTR-Modding/SkyPromptAPI
    REF 4e1c7925d01c8f3bac7ee025588eca8805f32f78
    SHA512 1d756e530c49b9d9abf7d29c4d6c878da74fe4685fd72727f78badacb203645d70a6a6d6404a70fafff66af9797014f9223d97282d4264a9fb6266cacb58f12f
    HEAD_REF update
)

# Install codes
set(SkyPromptAPI_SOURCE	${SOURCE_PATH}/include/SkyPrompt)
file(INSTALL ${SkyPromptAPI_SOURCE} DESTINATION ${CURRENT_PACKAGES_DIR}/include)
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/NOTICE")