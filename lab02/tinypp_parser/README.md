# Tiny++ Parser

A recursive descent parser for the Tiny++ programming language written in Rust.

## Features

- Complete Tiny++ language support
- Lexical analysis using the `logos` crate
- Recursive descent parsing
- Abstract Syntax Tree (AST) generation
- Pretty-printed debug output

## Building

```bash
cargo build --release
```

## Usage

### Parse a Tiny++ program from stdin

```bash
cargo run --release < program.tpp
```

### Parse a Tiny++ program from a file

```bash
cargo run --release < tests/test_factorial.tpp
```

### Or use the compiled binary

```bash
./target/release/tinypp_parser < program.tpp
```

## Language Support

### Statements

- `if ... then ... end`
- `if ... then ... else ... end`
- `while ... do ... enddo`
- `for ... := ... to ... enddo`
- `for ... := ... downto ... enddo`
- `repeat ... until ...`
- `read identifier`
- `write expression`
- `identifier := expression`
- `identifier += expression`
- `identifier -= expression`

### Operators

**Arithmetic:** `+`, `-`, `*`, `/`, `%` (modulo), `^` (power)  
**Comparison:** `<`, `=`, `>`, `<=`, `>=`, `<>` (not equal)  
**Assignment:** `:=`, `+=`, `-=`

### Other Features

- Comments: `{comment text}`
- Proper operator precedence
- Parenthesized expressions
- Statement sequences with `;`

## Testing

A comprehensive test suite is available in the `tests/` directory.

### Run all tests

```bash
cd tests
./run_tests.sh
```

### Available tests

- `test_basic` - Basic assignment and arithmetic
- `test_if_else` - Conditional statements
- `test_while` - While loops
- `test_for` - For loops (to/downto)
- `test_repeat` - Repeat-until loops
- `test_operators` - All operators
- `test_assign_ops` - Assignment operators
- `test_nested` - Nested structures
- `test_expressions` - Complex expressions
- `test_factorial` - Factorial calculation
- `test_gcd` - GCD algorithm

See `tests/TEST_SUMMARY.md` for detailed coverage information.

## Example

**Input (program.tpp):**

```

read n;
fact := 1;
for i := 1 to n
  fact := fact * i
enddo;
write fact

```

**Output (AST):**

```

Program {
    statements: [
        Read { variable: "n" },
        Assign { variable: "fact", op: Assign, value: IntConst(1) },
        For {
            variable: "i",
            start: IntConst(1),
            end: Id("n"),
            is_to: true,
            body: [
                Assign {
                    variable: "fact",
                    op: Assign,
                    value: Binary {
                        left: Id("fact"),
                        op: Times,
                        right: Id("i")
                    }
                }
            ]
        },
        Write { value: Id("fact") }
    ]
}

```

## Project Structure

```

tinypp_parser/
├── src/
│   ├── main.rs      # Entry point, reads input and outputs AST
│   ├── lexer.rs     # Lexical analyzer (tokenization)
│   ├── parser.rs    # Recursive descent parser
│   └── ast.rs       # AST data structures
├── tests/           # Test suite
│   ├── *.tpp        # Test programs
│   ├── run_tests.sh # Test runner
│   └── README.md    # Test documentation
└── Cargo.toml       # Dependencies

```

## Dependencies

- `logos` 0.16.0 - Lexical analysis library
