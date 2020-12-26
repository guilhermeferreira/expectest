#
# Server: loopback server
testcase_setup "ncat_server" "-l 5555 --keep-open --exec \"/bin/cat\" &" ""
testcase_teardown "ncat_server" ""

#
# Client
testcase_setup "ncat_client" "localhost 5555" ""

# Should be [       OK ]
set test_cmd "right message\r"
set test_result "right message"
append test_report [ testcase "ncat_client" "echo_success" $test_cmd $test_result ]

# Should [     FAIL ]
set test_cmd "right message\r"
set test_result "wrong message"
append test_report [ testcase "ncat_client" "echo_failure" $test_cmd $test_result ]

testcase_teardown "ncat_client" ""
