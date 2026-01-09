use crate::ast::*;
use crate::lexer::{Lexer, Token};

pub struct Parser<'a> {
    lexer: Lexer<'a>,
    current_token: Option<Token>,
}

impl<'a> Parser<'a> {
    pub fn new(input: &'a str) -> Self {
        let mut lexer = Lexer::new(input);
        let current_token = lexer.next();
        Parser {
            lexer,
            current_token,
        }
    }

    fn advance(&mut self) {
        self.current_token = self.lexer.next();
    }

    fn expect(&mut self, expected: Token) -> Result<(), String> {
        if self.current_token == Some(expected.clone()) {
            self.advance();
            Ok(())
        } else {
            Err(format!(
                "Expected {:?}, found {:?}",
                expected, self.current_token
            ))
        }
    }

    pub fn parse(&mut self) -> Result<Program, String> {
        let statements = self.parse_stmt_sequence()?;
        Ok(Program { statements })
    }

    fn parse_stmt_sequence(&mut self) -> Result<Vec<Statement>, String> {
        let mut statements = vec![self.parse_statement()?];

        while self.current_token == Some(Token::Semicn) {
            self.advance();
            statements.push(self.parse_statement()?);
        }

        Ok(statements)
    }

    fn parse_statement(&mut self) -> Result<Statement, String> {
        match &self.current_token {
            Some(Token::KwIf) => self.parse_if_stmt(),
            Some(Token::KwRepeat) => self.parse_repeat_stmt(),
            Some(Token::KwWhile) => self.parse_while_stmt(),
            Some(Token::KwFor) => self.parse_for_stmt(),
            Some(Token::KwRead) => self.parse_read_stmt(),
            Some(Token::KwWrite) => self.parse_write_stmt(),
            Some(Token::Ident) => self.parse_assign_stmt(),
            _ => Err(format!("Unexpected token: {:?}", self.current_token)),
        }
    }

    fn parse_if_stmt(&mut self) -> Result<Statement, String> {
        self.expect(Token::KwIf)?;
        let condition = self.parse_exp()?;
        self.expect(Token::KwThen)?;
        let then_branch = self.parse_stmt_sequence()?;

        let else_branch = if self.current_token == Some(Token::KwElse) {
            self.advance();
            Some(self.parse_stmt_sequence()?)
        } else {
            None
        };

        self.expect(Token::KwEnd)?;

        Ok(Statement::If {
            condition,
            then_branch,
            else_branch,
        })
    }

    fn parse_repeat_stmt(&mut self) -> Result<Statement, String> {
        self.expect(Token::KwRepeat)?;
        let body = self.parse_stmt_sequence()?;
        self.expect(Token::KwUntil)?;
        let until_condition = self.parse_exp()?;

        Ok(Statement::Repeat {
            body,
            until_condition,
        })
    }

    fn parse_while_stmt(&mut self) -> Result<Statement, String> {
        self.expect(Token::KwWhile)?;
        let condition = self.parse_exp()?;
        self.expect(Token::KwDo)?;
        let body = self.parse_stmt_sequence()?;
        self.expect(Token::KwEnddo)?;

        Ok(Statement::While { condition, body })
    }

    fn parse_for_stmt(&mut self) -> Result<Statement, String> {
        self.expect(Token::KwFor)?;

        let variable = if let Some(Token::Ident) = self.current_token {
            let name = self.lexer.slice().to_string();
            self.advance();
            name
        } else {
            return Err("Expected identifier in for statement".to_string());
        };

        self.expect(Token::Assign)?;
        let start = self.parse_simple_exp()?;

        let is_to = if self.current_token == Some(Token::KwTo) {
            self.advance();
            true
        } else if self.current_token == Some(Token::KwDownto) {
            self.advance();
            false
        } else {
            return Err("Expected 'to' or 'downto' in for statement".to_string());
        };

        let end = self.parse_simple_exp()?;
        let body = self.parse_stmt_sequence()?;
        self.expect(Token::KwEnddo)?;

        Ok(Statement::For {
            variable,
            start,
            end,
            is_to,
            body,
        })
    }

    fn parse_assign_stmt(&mut self) -> Result<Statement, String> {
        let variable = if let Some(Token::Ident) = self.current_token {
            let name = self.lexer.slice().to_string();
            self.advance();
            name
        } else {
            return Err("Expected identifier in assignment".to_string());
        };

        let op = match self.current_token {
            Some(Token::Assign) => {
                self.advance();
                AssignOp::Assign
            }
            Some(Token::PlusAssign) => {
                self.advance();
                AssignOp::PlusAssign
            }
            Some(Token::MinusAssign) => {
                self.advance();
                AssignOp::MinusAssign
            }
            _ => return Err("Expected assignment operator".to_string()),
        };

        let value = self.parse_exp()?;

        Ok(Statement::Assign {
            variable,
            op,
            value,
        })
    }

    fn parse_read_stmt(&mut self) -> Result<Statement, String> {
        self.expect(Token::KwRead)?;

        let variable = if let Some(Token::Ident) = self.current_token {
            let name = self.lexer.slice().to_string();
            self.advance();
            name
        } else {
            return Err("Expected identifier in read statement".to_string());
        };

        Ok(Statement::Read { variable })
    }

    fn parse_write_stmt(&mut self) -> Result<Statement, String> {
        self.expect(Token::KwWrite)?;
        let value = self.parse_exp()?;

        Ok(Statement::Write { value })
    }

    fn parse_exp(&mut self) -> Result<Expression, String> {
        let left = self.parse_simple_exp()?;

        if let Some(op) = self.parse_comparison_op() {
            self.advance();
            let right = self.parse_simple_exp()?;
            Ok(Expression::Binary {
                left: Box::new(left),
                op,
                right: Box::new(right),
            })
        } else {
            Ok(left)
        }
    }

    fn parse_comparison_op(&self) -> Option<BinaryOp> {
        match self.current_token {
            Some(Token::Lt) => Some(BinaryOp::Lt),
            Some(Token::Eq) => Some(BinaryOp::Eq),
            Some(Token::Gt) => Some(BinaryOp::Gt),
            Some(Token::Geq) => Some(BinaryOp::Geq),
            Some(Token::Leq) => Some(BinaryOp::Leq),
            Some(Token::Neq) => Some(BinaryOp::Neq),
            _ => None,
        }
    }

    fn parse_simple_exp(&mut self) -> Result<Expression, String> {
        let mut left = self.parse_term()?;

        while let Some(op) = self.parse_addop() {
            self.advance();
            let right = self.parse_term()?;
            left = Expression::Binary {
                left: Box::new(left),
                op,
                right: Box::new(right),
            };
        }

        Ok(left)
    }

    fn parse_addop(&self) -> Option<BinaryOp> {
        match self.current_token {
            Some(Token::Plus) => Some(BinaryOp::Plus),
            Some(Token::Minus) => Some(BinaryOp::Minus),
            _ => None,
        }
    }

    fn parse_term(&mut self) -> Result<Expression, String> {
        let mut left = self.parse_power()?;

        while let Some(op) = self.parse_mulop() {
            self.advance();
            let right = self.parse_power()?;
            left = Expression::Binary {
                left: Box::new(left),
                op,
                right: Box::new(right),
            };
        }

        Ok(left)
    }

    fn parse_mulop(&self) -> Option<BinaryOp> {
        match self.current_token {
            Some(Token::Times) => Some(BinaryOp::Times),
            Some(Token::Div) => Some(BinaryOp::Div),
            Some(Token::Mod) => Some(BinaryOp::Mod),
            _ => None,
        }
    }

    fn parse_power(&mut self) -> Result<Expression, String> {
        let left = self.parse_factor()?;

        if self.current_token == Some(Token::Pow) {
            self.advance();
            let right = self.parse_power()?;
            Ok(Expression::Binary {
                left: Box::new(left),
                op: BinaryOp::Pow,
                right: Box::new(right),
            })
        } else {
            Ok(left)
        }
    }

    fn parse_factor(&mut self) -> Result<Expression, String> {
        match &self.current_token {
            Some(Token::ParenL) => {
                self.advance();
                let exp = self.parse_exp()?;
                self.expect(Token::ParenR)?;
                Ok(exp)
            }
            Some(Token::IntConst(value)) => {
                let val = *value;
                self.advance();
                Ok(Expression::IntConst(val))
            }
            Some(Token::Ident) => {
                let name = self.lexer.slice().to_string();
                self.advance();
                Ok(Expression::Id(name))
            }
            _ => Err(format!(
                "Unexpected token in factor: {:?}",
                self.current_token
            )),
        }
    }
}
