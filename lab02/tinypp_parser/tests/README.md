# Tiny++ Parser Tests

This directory contains test cases for the Tiny++ parser.

## Test Files

1. **test_basic.tpp** - Basic assignment and arithmetic operations
2. **test_if_else.tpp** - If-then-else conditional statement
3. **test_while.tpp** - While loop
4. **test_for.tpp** - For loop with both `to` and `downto`
5. **test_repeat.tpp** - Repeat-until loop
6. **test_operators.tpp** - All comparison and arithmetic operators
7. **test_assign_ops.tpp** - Assignment operators (:=, +=, -=)
8. **test_nested.tpp** - Nested control structures
9. **test_expressions.tpp** - Complex expressions with parentheses
10. **test_factorial.tpp** - Practical example: factorial calculation

## Running Tests

### Run all tests:
```bash
cd tests
chmod +x run_tests.sh
./run_tests.sh
```

### Run a single test:
```bash
cd tinypp_parser
cargo run --release < tests/test_basic.tpp
```

## Expected Behavior

Each test should parse successfully and output a syntax tree structure showing:
- Program structure
- Statement types
- Expression trees with proper operator precedence
- Variable names and constants

## Tiny++ Language Features Tested

- **Statements**: if, while, for, repeat, read, write, assign
- **Operators**: 
  - Arithmetic: +, -, *, /, %, ^
  - Comparison: <, =, >, <=, >=, <>
  - Assignment: :=, +=, -=
- **Expressions**: Proper precedence and associativity
- **Comments**: Text enclosed in `{}`
- **Control flow**: Nested structures and multiple branches
