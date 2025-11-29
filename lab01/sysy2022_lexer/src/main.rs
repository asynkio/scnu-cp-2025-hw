use logos::Logos;
use std::env;
use std::fs::File;
use std::io::{self, BufWriter, Read, Write};

#[derive(Logos, Debug, PartialEq)]
#[logos(skip r"[ \t\n\f]+")] // Skip whitespace
#[logos(skip r"//[^\n]*")] // Skip single-line comments
#[logos(skip r"/\*([^*]|\*+[^*/])*\*+/")] // Skip multi-line comments
enum Token {
    #[token("main")]
    KwMain,

    #[token("const")]
    KwConst,

    #[token("int")]
    KwInt,

    #[token("break")]
    KwBreak,

    #[token("continue")]
    KwContinue,

    #[token("if")]
    KwIf,

    #[token("else")]
    KwElse,

    #[token("while")]
    KwWhile,

    #[token("getint")]
    KwGetInt,

    #[token("printf")]
    KwPrintf,

    #[token("return")]
    KwReturn,

    #[token("void")]
    KwVoid,

    #[token("=")]
    Assign,

    #[token("==")]
    Eq,

    #[token("!=")]
    Neq,

    #[token("<")]
    Lt,

    #[token("<=")]
    Leq,

    #[token(">")]
    Gt,

    #[token(">=")]
    Geq,

    #[token("&&")]
    And,

    #[token("||")]
    Or,

    #[token("!")]
    Not,

    #[token("+")]
    Plus,

    #[token("-")]
    Minus,

    #[token("*")]
    Times,

    #[token("/")]
    Div,

    #[token("%")]
    Mod,

    #[token("(")]
    ParenL,

    #[token(")")]
    ParenR,

    #[token("{")]
    BraceL,

    #[token("}")]
    BraceR,

    #[token(";")]
    Semicn,

    #[token(",")]
    Comma,

    #[regex(r"[_a-zA-Z][a-zA-Z]*")]
    Ident,

    // Return Token variant name exactly as defined (without payloads)
    // String constant with escape sequences
    #[regex(r#""([^"\\]|\\.)*""#, |lex| {
        let s = lex.slice();
        s.strip_prefix('\"').and_then(|s| s.strip_suffix('\"')).unwrap().to_string()
    })]
    StrConst(String),

    // Zero
    #[token("0", |_| 0)]
    // Decimal
    #[regex(r"-?[1-9][0-9]*", |lex| lex.slice().parse::<isize>().unwrap())]
    // Octal
    #[regex(r"-?0[0-7]+", |lex| isize::from_str_radix(&lex.slice()[1..], 8).unwrap())]
    // Hexadecimal
    #[regex(r"-?0[xX][0-9a-fA-F]+", |lex| isize::from_str_radix(&lex.slice()[2..], 16).unwrap())]
    IntConst(isize),
}

fn print_usage() {
    eprintln!(
        "Usage: sysy2022_lexer [-i|--input <file>] [-o|--output <file>]\n\n\
         If no input is provided, reads from stdin. If no output is provided, writes to stdout."
    );
}

fn main() {
    // Parse command line arguments: -i/--input, -o/--output
    let mut input_path: Option<String> = None;
    let mut output_path: Option<String> = None;

    let mut args = env::args().skip(1);
    while let Some(arg) = args.next() {
        match arg.as_str() {
            "-i" | "--input" => {
                if let Some(p) = args.next() {
                    input_path = Some(p);
                } else {
                    eprintln!("Missing value for {}", arg);
                    print_usage();
                    std::process::exit(1);
                }
            }
            "-o" | "--output" => {
                if let Some(p) = args.next() {
                    output_path = Some(p);
                } else {
                    eprintln!("Missing value for {}", arg);
                    print_usage();
                    std::process::exit(1);
                }
            }
            "--" => {
                // Stop parsing on --
                break;
            }
            _ => {
                eprintln!("Unknown argument: {}", arg);
                print_usage();
                std::process::exit(1);
            }
        }
    }

    // Read source from input file or stdin
    let mut src = String::new();
    if let Some(path) = input_path.as_deref() {
        match File::open(path) {
            Ok(mut f) => {
                if let Err(e) = f.read_to_string(&mut src) {
                    eprintln!("Failed to read {}: {}", path, e);
                    std::process::exit(1);
                }
            }
            Err(e) => {
                eprintln!("Failed to open {}: {}", path, e);
                std::process::exit(1);
            }
        }
    }
    if let Err(e) = io::stdin().read_to_string(&mut src) {
        eprintln!("Failed to read stdin: {}", e);
        std::process::exit(1);
    }

    // Prepare output writer: file or stdout
    let stdout = io::stdout();
    let mut out: Box<dyn Write> = if let Some(path) = output_path.as_deref() {
        match File::create(path) {
            Ok(file) => Box::new(BufWriter::new(file)),
            Err(e) => {
                eprintln!("Failed to create {}: {}", path, e);
                std::process::exit(1);
            }
        }
    } else {
        Box::new(BufWriter::new(stdout.lock()))
    };

    // Create lexer from the input source
    let lex = Token::lexer(&src);

    for result in lex.spanned() {
        match result {
            (Ok(token), span) => {
                // Compute 1-based line number by counting '\n' before span.start
                let line = src[..span.start].bytes().filter(|&b| b == b'\n').count() + 1;
                let lexeme = &src[span.start..span.end];
                // Write to the selected output
                if let Err(e) = writeln!(out, "{} {:?} {}", line, token, lexeme) {
                    eprintln!("Failed to write output: {}", e);
                    std::process::exit(1);
                }
            }
            (Err(e), _span) => {
                if let Err(werr) = writeln!(out, "Error: {:?}", e) {
                    eprintln!("Failed to write output: {}", werr);
                    std::process::exit(1);
                }
            }
        }
    }
}
