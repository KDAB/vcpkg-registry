vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO KDAB/KDUtils
    REF a1458532372bf82a6ee97c95dbdea7c5c2d8dc6a
    SHA512 128dee0c7346a254b6b8b068d1005670dc10b104965634af5b65479c1ed499d471d99006bda73802da64174326baaaffcaa2d9894391ef65a8b85d5a65bf96e0
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
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")
