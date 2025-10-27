vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KDAB/KDUtils
    REF 35a8651714d5bf760a9f62554e263831e31a7753
    SHA512 f2bb0c826d3520d0ebb745ca23c76705ff07c0fa61df579678eca913b873038225fad76b911482e539f9b8d24bc3875af951e3b333f3a1cd26fcb5639a26e5cd
#    REF 25689bf03f1559e28cdda651625a08c51305afe4
#    SHA512 ae0856f77f1ff3cd487bb1008160452b06f08b41b3928fd7090789f5e880c6aca73deeb6f38c23a6e4fd480be122e37270ccf068f91820b2a4ea76857b841abb
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
