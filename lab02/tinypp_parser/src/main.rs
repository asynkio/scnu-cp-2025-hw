mod ast;
mod lexer;
mod parser;

use parser::Parser;
use std::io::{self, Read};

fn main() {
    let mut input = String::new();
    io::stdin()
        .read_to_string(&mut input)
        .expect("Failed to read input");

    let mut parser = Parser::new(&input);
    match parser.parse() {
        Ok(program) => {
            println!("{:#?}", program);
        }
        Err(e) => {
            eprintln!("Parse error: {}", e);
            std::process::exit(1);
        }
    }
}
