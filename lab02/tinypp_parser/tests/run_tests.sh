#!/bin/bash
# Test runner for Tiny++ parser

PARSER="../target/release/tinypp_parser"
TEST_DIR="."
PASSED=0
FAILED=0

# Build the parser first
echo "Building parser..."
cd .. && cargo build --release --quiet 2>/dev/null && cd tests || exit 1

echo ""
echo "Running Tiny++ Parser Tests"
echo "============================"
echo ""

for test_file in "$TEST_DIR"/*.tpp; do
    test_name=$(basename "$test_file" .tpp)
    echo "Testing: $test_name"
    
    if $PARSER < "$test_file" > "${test_name}_output.txt" 2>&1; then
        echo "  ✓ PASSED"
        PASSED=$((PASSED + 1))
    else
        echo "  ✗ FAILED"
        FAILED=$((FAILED + 1))
    fi
    echo ""
done

echo "============================"
echo "Results: $PASSED passed, $FAILED failed"
echo ""

# Clean up output files
rm -f *_output.txt
