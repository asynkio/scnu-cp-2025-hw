use logos::Logos;

#[derive(Logos, Debug, PartialEq)]
#[logos(skip r"[ \t\n\f]+")] // Skip whitespace
#[logos(skip r"\{[^{}]*\}")] // Skip comments enclosed in {}
enum Token {
    #[token("if")]
    KwIf,

    #[token("then")]
    KwThen,

    #[token("else")]
    KwElse,

    #[token("end")]
    KwEnd,

    #[token("repeat")]
    KwRepeat,

    #[token("until")]
    KwUntil,

    #[token("read")]
    KwRead,

    #[token("write")]
    KwWrite,

    #[token("=")]
    Eq,

    #[token("<")]
    Lt,

    #[token("+")]
    Plus,

    #[token("-")]
    Minus,

    #[token("*")]
    Times,

    #[token("/")]
    Div,

    #[token("(")]
    ParenL,

    #[token(")")]
    ParenR,

    #[token(";")]
    Semicn,

    #[token(":=")]
    Assign,

    #[regex(r"[a-zA-Z]+")]
    Ident,

    #[regex(r"[0-9]+", |lex| lex.slice().parse::<isize>().unwrap())]
    IntConst(isize),

    // Added in TINY++
    #[token("while")]
    KwWhile,

    #[token("do")]
    KwDo,

    #[token("enddo")]
    KwEnddo,

    #[token("for")]
    KwFor,

    #[token("to")]
    KwTo,

    #[token("downto")]
    KwDownto,

    #[token("+=")]
    PlusAssign,

    #[token("-=")]
    MinusAssign,

    #[token("%")]
    Mod,

    #[token("^")]
    Pow,

    #[token(">")]
    Gt,

    #[token("<=")]
    Leq,

    #[token(">=")]
    Geq,

    #[token("<>")]
    Neq,
}
