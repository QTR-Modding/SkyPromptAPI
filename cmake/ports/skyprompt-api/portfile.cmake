# header-only library
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO QTR-Modding/SkyPromptAPI
    REF c61a091a5fb764a2219a46e2d33332dc1fc15ba6
    SHA512 805a4f97981abca4a426e1efcb0b1acdb1eaefebd35a43d802a291472a134a6160e244ddfd42742e3576bf137e974df2d21560d3c03a8e50963e3323512a143f
    HEAD_REF main
)

# Install codes
set(SkyPromptAPI_SOURCE	${SOURCE_PATH}/include/SkyPrompt)
file(INSTALL ${SkyPromptAPI_SOURCE} DESTINATION ${CURRENT_PACKAGES_DIR}/include)
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
