vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KDAB/KDGpu
    REF bff0842178819bc146f2c9be5186e2fc1a194c61
    SHA512 e569f4b62949939e59d371b26f395341923b697c783795a27a3d48c1ed2109f11a91ae8614641f7ab4c23f2b0b4e8b8b9a43e1eedf397ccc088301930753cb80
    HEAD_REF main
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        kdgpuutils KDGPU_BUILD_KDGPUUTILS
        testing    KDGPU_BUILD_TESTS
	examples   KDGPU_BUILD_EXAMPLES
	kdgpukdgui KDGPU_BUILD_KDGPUKDGUI
	hlsl	   KDGPU_HLSL_SUPPORT
	openxr	   KDGPU_BUILD_KDXR
)

vcpkg_cmake_configure(SOURCE_PATH ${SOURCE_PATH}
                      OPTIONS
                      ${FEATURE_OPTIONS})
vcpkg_cmake_install()

# Remove debug includes if they exist
if(EXISTS "${CURRENT_PACKAGES_DIR}/debug/include")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
endif()

# Fix CMake config files - each module goes to its own subdirectory in share/
if(EXISTS "${CURRENT_PACKAGES_DIR}/lib/cmake")
    # Fix up the main KDGpu component
    if(EXISTS "${CURRENT_PACKAGES_DIR}/lib/cmake/KDGpu")
        vcpkg_cmake_config_fixup(PACKAGE_NAME KDGpu CONFIG_PATH lib/cmake/KDGpu DO_NOT_DELETE_PARENT_CONFIG_PATH)
    endif()
    
    # Fix up optional components only if they exist
    if(EXISTS "${CURRENT_PACKAGES_DIR}/lib/cmake/KDGpuUtils")
        vcpkg_cmake_config_fixup(PACKAGE_NAME KDGpuUtils CONFIG_PATH lib/cmake/KDGpuUtils DO_NOT_DELETE_PARENT_CONFIG_PATH)
    endif()
    if(EXISTS "${CURRENT_PACKAGES_DIR}/lib/cmake/KDGpuKDGui")
        vcpkg_cmake_config_fixup(PACKAGE_NAME KDGpuKDGui CONFIG_PATH lib/cmake/KDGpuKDGui DO_NOT_DELETE_PARENT_CONFIG_PATH)
    endif()
    if(EXISTS "${CURRENT_PACKAGES_DIR}/lib/cmake/KDXr")
        vcpkg_cmake_config_fixup(PACKAGE_NAME KDXr CONFIG_PATH lib/cmake/KDXr DO_NOT_DELETE_PARENT_CONFIG_PATH)
    endif()
    if(EXISTS "${CURRENT_PACKAGES_DIR}/lib/cmake/KDGpuExample")
        vcpkg_cmake_config_fixup(PACKAGE_NAME KDGpuExample CONFIG_PATH lib/cmake/KDGpuExample DO_NOT_DELETE_PARENT_CONFIG_PATH)
    endif()
endif()


# Copy usage file if it exists
if(EXISTS "${CMAKE_CURRENT_LIST_DIR}/usage")
    file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
endif()

# Copy License files
file(GLOB LICENSE_FILES "${SOURCE_PATH}/LICENSES/*.txt")
if(LICENSE_FILES)
    vcpkg_install_copyright(FILE_LIST ${LICENSE_FILES})
endif()
