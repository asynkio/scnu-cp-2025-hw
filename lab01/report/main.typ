#import "@local/hw-template:1.0.0": *

#show: project.with(
  title: "Compile Principles: Lab01",
  authors: (
    (
      name: "Aksel Shen",
      email: "20234001053@m.scnu.edu.cn",
      affiliation: "South China Normal University",
    ),
  ),
  date: datetime.today().display(),
)

#set heading(numbering: "1.1")

#align(center)[
  #set par(justify: false)
  *_Abstract_* \
  In this lab, we implemented a lexer for SysY2022 using Logos --- a
  lexer generator for Rust. The lexer analyzes a source code of SysY2022
  and produces a sequence of tokens, which can be used
  for further processing by the parser. \
  #v(1em, weak: true)
]

= Introduction

As a crucial component of a compiler, a lexical analyzer (or lexer) is
responsible for reading the source code and breaking it down into a sequence of
tokens, which are the basic building blocks of the programming language.

In this lab, we need to implement a lexer for SysY2022, a simplified version of
the C programming language. The lexer should be able to recognize various tokens,
including keywords, identifiers, literals, operators, and punctuation.

= Implementation

We chose to use #link("https://github.com/maciejhirsz/logos")[Logos], a lexer
generator for Rust, to implement our lexer.

The reason for this choice is that
Logos provides a simple and efficient way to define token patterns using regular
expressions, and it automatically combines them into a deterministic finite automaton
(DFA) for efficient tokenization. And since this is completed at compile time, it
results in very fast, high-performance lexers.
