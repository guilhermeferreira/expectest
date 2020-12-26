# Expectest

Expectest is a integration test suite for command-line, graphical, and Web applications.

Its goal is provide a GTest-like output and reporting for integration tests.

## Requirements

Expectest provides an unified approach to different testing tools (i.e. it's built on top of other testing tools).

For command-line interface testing, Expectest uses expect. For Web interface, it uses Selenium.

## Features

The Expectest provides Google Test like output:

```shell
$ expect test.tcl ncat examples/ncat/
[==========] Running 1 tests.
[----------] ncat_server
[----------] 0 tests from ncat_server (0 ms total)
[----------] ncat_client
[ RUN      ] ncat_client.echo_success
ncat localhost 5555
right message
[       OK ] ncat_client.echo_success (20 ms)
[ RUN      ] ncat_client.echo_failure
right message
right message
[     FAIL ] ncat_client.echo_failure (5000 ms)
[----------] 2 tests from ncat_client (5021 ms total)
[==========] 2 test(s) ran.
[  PASSED  ] 1 test(s).
[  FAILED  ] 1 tests.
```

And produces a JUnit XML file with the results compatible with CI tools like Jenkins.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<testsuites tests="2" failures="1" disabled="0" errors="0" timestamp="2020-12-26T23:31:24" time="0" name="AllTests">
  <testsuite name="ncat" tests="2" failures="1" disabled="0" errors="0" time="0">
    <testcase name="echo_success" status="run" time="0" classname="ncat_client"/>
    <testcase name="echo_failure" status="run" time="0" classname="ncat_client">
      <failure message="Failed echo_failure testcase"/>
    </testcase>
  </testsuite>
</testsuites>
```

## Usage

The framework is composed of the ```test.tcl```. This script runs a set of test files created by the user. The user runs the test with the following command:

```shell
$ expect test.tcl <PROG> <TEST DIR>
```

or 

```shell
$ ./test.tcl <PROG> <TEST DIR>
```

where:
- __PROG__ is the program under test.
- __TEST DIR__ is the directory where the test files are located. Each test file must have the ```_test.tcl``` suffix.

Each test has a setup, a set of test cases, and a test teardown.

### Test setup

There is call to ```testcase_setup``` per file. This function begins a set of test cases.

```tcl
testcase_setup "<TEST SUITE NAME>" "<PROG ARGS>" "<PROG PROMPT>"
```

__TEST SUITE NAME__ marks the beggining of a group of test cases. __PROG ARGS__ specify the command line arguments used for this group of tests. And __PROG PROMPT__ tells the test suite which prompt the it must wait for (i.e. the prompt string used by interactive programs).

### Test cases

The following line specify a test case.

```tcl
append test_report [ testcase "<TEST SUITE NAME>" "<TEST CASE NAME>" "<PROG COMMAND>\r" "<PROG RESPONSE>" ]
```
This test case bellongs to the __TEST SUITE NAME__ set of tests. This specific test has the name __TEST CASE NAME__.

This test case passes if it receives __PROG RESPONSE__ after sending __PROG COMMAND__.

### Test teardown

```tcl
testcase_teardown "<TEST SUITE NAME>" "<PROG EXIT COMMAND>\r\r"
```
__TEST SUITE NAME__ marks the end of a group of test cases. And __PROG EXIT COMMAND__ is the command used to finish the program under test.


## Examples

Here are some examples of using the expectest suite.

### Testing python3 interpreter

Create a test file with suffix ```_test.tcl```. For example, ```python3_test.tcl```.

Write the following contents:

```tcl
testcase_setup "python_test" "" ">>>"

set test_cmd "1 + 1\r"
set test_result "2"
append test_report [ testcase "python_test" "addition" $test_cmd $test_result ]

testcase_teardown "python_test" "exit()\r\r"
```

The run the test with the command:

```shell
$ ./test.tcl python3 examples/python3/
```

- ```test.tcl``` is the Expect script.
- ```python3``` is the program under test.
- ```.``` is the directory where the test scripts are located. In this case, ```python3_test.tcl``` is in the current directory.

### Testing ncat loopback server

```shell
$ ./test.tcl ncat examples/ncat/
```

## Future features

TODO

1) Convert this project to Python using PyExpect

2) Allow different output formats, not only Google Test, but Catch2 too.
