#import "@local/hw-template:1.0.0": *
#import "@preview/equate:0.3.2": equate
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/cetz:0.4.2" as cetz: canvas, draw, tree

#show: project.with(
  title: "CP HW05",
  authors: (
    (
      name: "Aksel Shen",
      email: "20234001053@m.scnu.edu.cn",
      affiliation: "South China Normal University",
    ),
  ),
  date: datetime.today().display(),
)

= 1.

考虑以下的文法：

#show: equate.with(breakable: true, sub-numbering: false)
#set math.equation(numbering: "(1.1)", number-align: bottom)

$
  S & -> A a A b \
  S & -> B b B a \
  A & -> epsilon \
  B & -> epsilon \
$

1. 请写出上述文法的 LL(1) 分析表，并说明这个文法是否是 LL(1) 文法。
2. 请画出上述文法的 LR(0) 项目的 DFA。
3. 请说明上述文法是否是 LR(0) 文法和 SLR(1) 文法。

== 解


#set table(
  align: (x, y) => (
    if x == 0 or y == 0 {
      center
    } else { left }
  ),
)
1.
  #figure(
    table(
      columns: 3,
      [], $a$, $b$,
      $S$, $-> A a A b$, $-> B b B a$,
      $A$, $-> epsilon$, $-> epsilon$,
      $B$, $-> epsilon$, $-> epsilon$,
    ),
  )

  是 LL(1) 文法，因为上述分析表中每个单元格最多只有一个产生式，
  不存在冲突。

#let bl = math.class("normal", sym.bullet)
#set math.equation(numbering: none)

#let gr1 = gradient.linear(
  space: oklch,
  angle: 119deg,
  rgb("#FC5C7D").lighten(89%),
  rgb("#6A82FB").lighten(30%),
)

#let gr2 = gradient.linear(
  rgb("#c33764"),
  rgb("#1d2671"),
  angle: 70deg,
)

2. 对文法进行扩充：

$
  S' & -> S \
   S & -> A a A b \
   S & -> B b B a \
   A & -> epsilon \
   B & -> epsilon \
$

构造 DFA：

#figure(diagram(
  node-shape: rect,
  node-stroke: .07em + gr2,
  node-corner-radius: 4pt,
  node-fill: gr1,
  edge-stroke: .06em + gr2,
  label-sep: 0.4pt,
  spacing: 2.2em,
  {
    let state(name, pos, cont, have-pad: true) = node(
      pos,
      name: name,
      if have-pad { pad(x: 5pt, cont) } else { cont }
        + place(
          right + bottom,
          dx: 3pt,
          dy: 3pt,
          text(9pt, black.transparentize(50%), name),
        ),
    )
    let trans(a, b, label, ..args) = edge(
      a,
      b,
      label,
      "-|>",
      label-side: center,
      ..args,
    )
    state(
      "0",
      (0, 0),
      $
        S' & -> bl S \
         S & -> bl A a A b \
         S & -> bl B b B a \
         A & -> bl \
         B & -> bl
      $,
      have-pad: false,
    )
    state(
      "1",
      (0, 1),
      $
        S' -> S bl
      $,
    )
    state(
      "2",
      (1, 0),
      $
        S -> A bl a A b \
      $,
    )
    state(
      "3",
      (1, 1),
      $
        S -> B bl b B a \
      $,
    )
    state(
      "4",
      (2, 0),
      $
        S & -> A a bl A b \
        A & -> bl
      $,
      have-pad: false,
    )
    state(
      "5",
      (2, 1),
      $
        S & -> B b bl B a \
        B & -> bl
      $,
      have-pad: false,
    )
    state(
      "6",
      (3, 0),
      $
        S & -> A a A bl b \
      $,
    )
    state(
      "7",
      (3, 1),
      $
        S & -> B b B bl a
      $,
    )
    state(
      "8",
      (4, 0),
      $
        S -> A a A b bl \
      $,
    )
    state(
      "9",
      (4, 1),
      $
        S -> B b B a bl \
      $,
    )
    trans(<0>, <1>, $S$)
    trans(<0>, <2>, $A$)
    trans(<0>, <3>, $B$)
    trans(<2>, <4>, $a$)
    trans(<3>, <5>, $b$)
    trans(<4>, <6>, $A$)
    trans(<5>, <7>, $B$)
    trans(<6>, <8>, $b$)
    trans(<7>, <9>, $a$)
  },
))

#pagebreak()

3. 不是 LR(0) 文法，也不是 SLR(1) 文法。

  LR(0) 文法要求任何状态下的项目集都不能存在归约-归约冲突和移进-规约冲突。
  而在状态 0 中，存在两个归约项目 $A -> bl$ 和 $B -> bl$，产生了归约-归约冲突，
  因此该文法不是 LR(0) 文法。

  SLR(1) 文法要求在存在归约-归约冲突的状态下，$"follow"(A) inter "follow"(B) = emptyset$。
  而状态 0 中，$"follow"(A) = {a, b}$，$"follow"(B) = {a, b}$，$"follow"(A) inter "follow"(B) = {a, b} != emptyset$，
  因此，该文法不是 SLR(1) 文法。
