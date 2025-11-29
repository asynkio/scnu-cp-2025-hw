# Lab01: SysY2022 Lexer

This is the implementation of a lexer for the SysY2022 language for the first
lab of Compile Principles.

## Compilation

To compile the lexer, navigate to the `sysy2022_lexer` directory and
run the following command:

```bash
cargo build --release
```

The executable will be located at `target/release/sysy2022_lexer`.

## Testing

To run the integration tests, navigate to the `sysy2022_lexer` directory and use:

```bash
cargo test
```

This command will automatically run the tests defined in `tests/basic.rs`,
which processes the files in the `testcase/` directory.

## Report

The lab report is written in Typst and the source code can be found at `report/main.typ`.
The PDF version is located at `report/lab01_report.pdf`.
