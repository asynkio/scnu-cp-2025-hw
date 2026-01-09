#[derive(Debug)]
pub struct Program {
    pub statements: Vec<Statement>,
}

#[derive(Debug)]
pub enum Statement {
    If {
        condition: Expression,
        then_branch: Vec<Statement>,
        else_branch: Option<Vec<Statement>>,
    },

    Repeat {
        body: Vec<Statement>,
        until_condition: Expression,
    },

    Assign {
        variable: String,
        op: AssignOp,
        value: Expression,
    },

    Read {
        variable: String,
    },

    Write {
        value: Expression,
    },

    // --- Added in TINY++ ---
    While {
        condition: Expression,
        body: Vec<Statement>,
    },

    For {
        variable: String,
        start: Expression,
        end: Expression,
        is_to: bool,
        body: Vec<Statement>,
    },
}

#[derive(Debug)]
pub enum AssignOp {
    Assign,      // :=
    PlusAssign,  // +=
    MinusAssign, // -=
}

#[derive(Debug)]
pub enum Expression {
    Binary {
        left: Box<Expression>,
        op: BinaryOp,
        right: Box<Expression>,
    },
    Id(String),
    IntConst(isize),
}

#[derive(Debug)]
pub enum BinaryOp {
    Lt,
    Eq,
    Plus,
    Minus,
    Times,
    Div,
    // --- Added in TINY++ ---
    Gt,
    Geq,
    Leq,
    Neq,
    Mod,
    Pow,
}

