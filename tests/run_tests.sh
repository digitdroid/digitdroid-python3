#!/bin/sh

FAILED=0
TESTED=0

C_RED='\e[0;31m'
C_GREEN='\e[0;32m'
C_YELLOW='\e[1;33m'
C_RESET='\e[0m'

msg() {
    /bin/echo -e "$@"
}

assert() {
    TESTED=$((TESTED + 1))

    "$@"

    if [ ${?} -ne 0 ]; then
        FAILED=$((FAILED + 1))
        msg -n "${C_RED}FAIL${C_RESET}"
    else
        msg -n "${C_GREEN}PASS${C_RESET}"
    fi

    msg " | assert $@";
}

catch() {
    local PASSED=$(( $TESTED - $FAILED ))
    local ELAPSED_TIME="$(($END_TIME-$START_TIME))"
    local PASSED_MSG="${PASSED} tests passed"
    local FAILED_MSG="${FAILED} tests failed"

    msg "${C_YELLOW}==> Testing finished${C_RESET}\n"
    msg "Total tests: ${TESTED}, execution time: ${ELAPSED_TIME} seconds"

    [ ${PASSED} -gt 0 ] && PASSED_MSG="${C_GREEN}${PASSED_MSG}${C_RESET}"
    msg "${PASSED_MSG}"
    [ ${FAILED} -gt 0 ] && FAILED_MSG="${C_RED}${FAILED_MSG}${C_RESET}"
    msg "${FAILED_MSG}\n"
    [ ${FAILED} -gt 0 ] && exit 1
}

trap catch EXIT

msg "${C_YELLOW}==> Testing started${C_RESET}"

START_TIME="$(date -u +%s)"

# check current user and required binaries
assert test $(whoami) = 'app'
assert test $(which python) = '/venv/bin/python'
assert test $(which pip) = '/venv/bin/pip'

# check permissions for created directories
assert test ! -O /root
assert test -O /app
assert test -O /venv

# check if the test files are successfully created
assert test -f /tmp/test-file.sh
assert test -f /tmp/test-file.py

assert test "$(pip freeze -r /requirements.txt | grep "." | tail -n 2 | head -n 1)" = "pytz==2020.1"

END_TIME="$(date -u +%s)"
