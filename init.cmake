set(
    HUNTER_CACHE_SERVERS
    "https://github.com/elucideye/hunter-cache"
    CACHE
    STRING
    "Hunter cache servers"
)

# https://docs.travis-ci.com/user/environment-variables/#Default-Environment-Variables
string(COMPARE EQUAL "$ENV{TRAVIS}" "true" is_travis)

# https://www.appveyor.com/docs/environment-variables/
string(COMPARE EQUAL "$ENV{APPVEYOR}" "True" is_appveyor)

string(COMPARE EQUAL "$ENV{GITHUB_USER_PASSWORD}" "" password_is_empty)

if(password_is_empty)
  set(default_upload OFF)
elseif(is_travis OR is_appveyor)
  set(default_upload ON)
else()
  set(default_upload OFF)
endif()

option(HUNTER_RUN_UPLOAD "Upload cache binaries" ${default_upload})
message("HUNTER_RUN_UPLOAD: ${HUNTER_RUN_UPLOAD}")

set(
    HUNTER_PASSWORDS_PATH
    "${CMAKE_CURRENT_LIST_DIR}/passwords.cmake"
    CACHE
    FILEPATH
    "Hunter passwords"
)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake/Modules")

# HunterGate.cmake should be included by parent project. Parent project should
# have this module anyway because it will be used in Hunter without
# 'drishti-upload' submodule.  This call *is* used for the CI builds/tests
# of the drishti repository.
HunterGate(
    URL "https://github.com/ruslo/hunter/archive/v0.21.19.tar.gz"
    SHA1 "5ead1e069b437930d0de8a21824b20fb52b37b50"
    FILEPATH "${CMAKE_CURRENT_LIST_DIR}/config.cmake"
)
