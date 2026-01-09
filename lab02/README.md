# Lab02: Tiny++ Parser

This is the implementation of a parser for the Tiny++ language for the second
lab of Compile Principles.

## Compilation

To compile the parser, navigate to the `tinypp_parser` directory and
run the following command:

```bash
cargo build --release
```

The executable will be located at `target/release/tinypp_parser`.

## Usage

To parse a Tiny++ program from a file:

```bash
cd tinypp_parser
cargo run --release < tests/test_factorial.tpp
```

Or using the compiled binary:

```bash
./tinypp_parser/target/release/tinypp_parser < program.tpp
```

The parser will output the Abstract Syntax Tree (AST) to stdout.

## Testing

To run all tests, navigate to the `tinypp_parser/tests` directory and execute:

```bash
cd tinypp_parser/tests
./run_tests.sh
```

To run a single test:

```bash
cd tinypp_parser/tests
./run_single_test.sh test_factorial
```

The test suite includes 11 comprehensive test cases covering various language features.

## Report

The lab report is written in Typst and the source code can be found at `report/main.typ`.
To generate the PDF version, run:

```bash
cd report
typst compile main.typ lab02_report.pdf
```
