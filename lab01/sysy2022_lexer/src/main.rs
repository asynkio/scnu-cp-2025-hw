use logos::Logos;
use std::io::{self, Read};

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

fn main() {
    // Read entire SysY source from stdin
    let mut src = String::new();
    if let Err(e) = io::stdin().read_to_string(&mut src) {
        eprintln!("Failed to read stdin: {}", e);
        return;
    }

    // Create lexer from the input source
    let lex = Token::lexer(&src);

    for result in lex.spanned() {
        match result {
            (Ok(token), span) => {
                // Compute 1-based line number by counting '\n' before span.start
                let line = src[..span.start].bytes().filter(|&b| b == b'\n').count() + 1;
                let lexeme = &src[span.start..span.end];
                println!("{} {:?} {}", line, token, lexeme);
            }
            (Err(e), _span) => {
                println!("Error: {:?}", e);
            }
        }
    }
}
