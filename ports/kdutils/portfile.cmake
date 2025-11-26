vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KDAB/KDUtils
    REF 7fda7f5028cc3b12008ffa494bef689a3a1a809f
    SHA512 2d4af6d07853e9f39ee0e01b54c2474c2ba1877364c4f9964fd8707a4c903b5d09f014bcd6d103de604ac8992cec8fa0da1768c720ad8e2ea4ecd8f6cb7f328c
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
