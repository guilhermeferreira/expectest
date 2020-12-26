testcase_setup "python_test" "" ">>>"

set test_cmd "1 + 1\r"
set test_result "2"
append test_report [ testcase "python_test" "addition" $test_cmd $test_result ]

testcase_teardown "python_test" "exit()\r\r"
