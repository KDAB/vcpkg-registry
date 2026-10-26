vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KDAB/KDUtils
    REF a9b17926a41c3e07c7d503d10784204c0df690d5 # fix_kdgui_cmake_config branch
    SHA512 c2f693b2edc4291ec7b105c80c19dbfce1475129697d24a55b3155be41d9ff70bc009ca7de322170134c21833e14948e87a1a7bcbb6dff69b7485f8807111fcf
    HEAD_REF main
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        testing    KDUTILS_BUILD_TESTS
        mqtt       KDUTILS_BUILD_MQTT_SUPPORT
)

vcpkg_cmake_configure(SOURCE_PATH ${SOURCE_PATH}
                      OPTIONS
                      -DKDUTILS_BUILD_EXAMPLES=OFF
                      ${FEATURE_OPTIONS})
vcpkg_cmake_install()

# Remove debug includes if they exist
if(EXISTS "${CURRENT_PACKAGES_DIR}/debug/include")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
endif()

# Fix CMake config files - each module goes to its own subdirectory in share/
if(EXISTS "${CURRENT_PACKAGES_DIR}/lib/cmake")
    vcpkg_cmake_config_fixup(PACKAGE_NAME KDUtils CONFIG_PATH lib/cmake/KDUtils DO_NOT_DELETE_PARENT_CONFIG_PATH)
    vcpkg_cmake_config_fixup(PACKAGE_NAME KDGui CONFIG_PATH lib/cmake/KDGui DO_NOT_DELETE_PARENT_CONFIG_PATH)
    vcpkg_cmake_config_fixup(PACKAGE_NAME KDFoundation CONFIG_PATH lib/cmake/KDFoundation)
endif()

# Copy usage file if it exists
if(EXISTS "${CMAKE_CURRENT_LIST_DIR}/usage")
    file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
endif()

# Copy License file
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")
