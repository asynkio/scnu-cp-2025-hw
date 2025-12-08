#import "@local/hw-template:1.0.0": *
#import "@preview/equate:0.3.2": equate
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/cetz:0.4.2" as cetz: canvas, draw, tree


#show: project.with(
  title: "CP HW06",
  authors: (
    (
      name: "Aksel Shen",
      email: "20234001053@m.scnu.edu.cn",
      affiliation: "South China Normal University",
    ),
  ),
  date: datetime.today().display(),
)

#let ast = math.class("normal", sym.ast)
#let bl = math.class("normal", sym.bullet)

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

= 1

考虑以下的文法，其中 $S$, $V$, $E$ 为非终结符，$=$, $id$, $*$ 为终结符：

$
  S & -> V = E \
  S & -> E \
  V & -> ast E \
  V & -> id \
  E & -> V \
$

1. 请写出上述文法的 LR(1) 的 DFA 和分析表。
2. 请写出上述文法的 LALR(1) 的 DFA 和分析表。

== 解

1. 对文法进行增广：

$
  S' & -> S \
   S & -> V = E \
   S & -> E \
   V & -> ast E \
   V & -> "id" \
   E & -> V \
$


#figure(scale(89%, reflow: true, diagram(
  node-shape: rect,
  node-stroke: .07em + gr2,
  node-corner-radius: 4pt,
  node-fill: gr1,
  edge-stroke: .06em + gr2,
  label-sep: 0.5pt,
  spacing: 2.0em,
  debug: 0,
  {
    let state(name, pos, cont, have-pad: true) = node(
      pos,
      name: name,
      if have-pad { pad(x: 5pt, cont) } else { cont }
        + place(
          right + bottom,
          dx: 3pt,
          dy: 3pt,
          text(10pt, black.transparentize(50%), name),
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
        [S' & -> bl S, \$] \
         [S & -> bl V = E, \$] \
         [S & -> bl E, \$] \
         [E & -> bl V, \$] \
         [V & -> bl ast E, =] \
        [ V & -> bl ast E, \$ ] \
         [V & -> bl id, =] \
        [ V & -> bl id, \$ ] \
      $,
    )
    state(
      "1",
      (1, -0.5),
      $
        [S' & -> S bl, \$] \
      $,
    )
    state(
      "2",
      (1, 0),
      $
        [S & -> V bl = E, \$] \
        [E & -> V bl, \$] \
      $,
      have-pad: false,
    )
    state(
      "3",
      (1, 0.3),
      $
        [S -> E bl, \$] \
      $,
    )
    state(
      "4",
      (0, 1),
      $
        [V & -> ast bl E, =] \
        [V & -> ast bl E, \$] \
        [E & -> bl V, =] \
        [E & -> bl V, \$] \
        [V & -> ast E bl, =] \
        [V & -> ast E bl, \$] \
        [V & -> id bl, =] \
        [V & -> id bl, \$] \
      $,
    )
    state(
      "5",
      (1, 0.6),
      $
        [V & -> id bl, =] \
        [V & -> id bl, \$] \
      $,
    )
    state(
      "6",
      (2, 0),
      $
        [S & -> V = bl E, \$] \
        [E & -> bl V, \$] \
        [V & -> bl ast E, \$] \
        [V & -> bl id, \$]
      $,
    )
    state(
      "7",
      (1, 0.95),
      $
        [V & -> ast E bl, =] \
        [V & -> ast E bl, \$] \
      $,
    )
    state(
      "8",
      (1, 1.5),
      $
        [E & -> V bl, =] \
        [E & -> V bl, \$] \
      $,
    )
    state(
      "9",
      (3, -0.2),
      $
        [S -> V = E bl, \$]
      $,
    )
    state(
      "10",
      (3, 0.3),
      $
        [E -> V bl, \$]
      $,
    )
    state(
      "11",
      (2, 1),
      $
        [V & -> ast bl E, \$] \
        [E & -> bl V, \$] \
        [V & -> ast E bl, \$] \
        [V & -> bl id, \$] \
      $,
    )
    state(
      "12",
      (3, 0.7),
      $
        [V & -> id bl, \$] \
      $,
    )
    state(
      "13",
      (3, 1.2),
      $
        [V -> ast E bl, \$]
      $,
    )
    trans(<0>, <1>, $S$)
    trans(<0>, <2>, $V$)
    trans(<0>, <3>, $E$)
    trans(<0>, <4>, $*$)
    trans(<0>, <5>, $id$)
    trans(<4>, <4>, $*$, bend: 99deg, loop-angle: -90deg)
    trans(<4>, <5>, $id$)
    trans(<4>, <7>, $E$)
    trans(<4>, <8>, $V$)
    trans(<2>, <6>, $=$)
    trans(<6>, <9>, $E$)
    trans(<6>, <10>, $V$)
    trans(<6>, <11>, $*$)
    trans(<6>, <12>, $id$)
    trans(<11>, <10>, $V$)
    trans(<11>, <11>, $*$, bend: 110deg, loop-angle: -90deg)
    trans(<11>, <12>, $id$)
    trans(<11>, <13>, $E$)
  },
)))

#figure(table(
  columns: (2.5em,) * 8,
  table.cell(rowspan: 2)[State],
  table.cell(colspan: 4)[Action],
  table.cell(colspan: 3)[Goto],
  $=$, $*$, $id$, $\$$, $S$, $V$, $E$,
  [0], [], [s4], [s5], [ ], [1], [2], [3],
  [1], [], [], [], [acc], [], [], [],
  [2], [s6], [], [], [r5], [], [], [],
  [3], [], [], [], [r2], [], [], [],
  [4], [], [s4], [s5], [], [], [8], [7],
  [5], [r4], [], [], [r4], [], [], [],
  [6], [], [s11], [s12], [], [], [10], [9],
  [7], [r3], [], [], [r3], [], [], [],
  [8], [r5], [], [], [r5], [], [], [],
  [9], [], [], [], [r1], [], [], [],
  [10], [], [], [], [r5], [], [], [],
  [11], [], [s11], [s12], [], [], [10], [13],
  [12], [], [], [], [r4], [], [], [],
  [13], [], [], [], [r3], [], [], [],
))

2.
#figure(diagram(
  node-shape: rect,
  node-stroke: .07em + gr2,
  node-corner-radius: 4pt,
  node-fill: gr1,
  edge-stroke: .06em + gr2,
  label-sep: 0.5pt,
  spacing: 2.0em,
  debug: 0,
  {
    let state(name, pos, cont, have-pad: true) = node(
      pos,
      name: name,
      if have-pad { pad(x: 5pt, cont) } else { cont }
        + place(
          right + bottom,
          dx: 3pt,
          dy: 3pt,
          text(10pt, black.transparentize(50%), name),
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
        [S' & -> bl S, \$] \
         [S & -> bl V = E, \$] \
         [S & -> bl E, \$] \
         [E & -> bl V, \$] \
         [V & -> bl ast E, =\/\$] \
        [ V & -> bl id, =\/\$ ] \
      $,
    )
    state(
      "1",
      (1, -0.5),
      $
        [S' & -> S bl, \$] \
      $,
    )
    state(
      "2",
      (1, 0),
      $
        [S & -> V bl = E, \$] \
        [E & -> V bl, \$] \
      $,
      have-pad: false,
    )
    state(
      "3",
      (1, 0.3),
      $
        [S -> E bl, \$] \
      $,
    )
    state(
      "4",
      (0, 1),
      $
        [V & -> ast bl E, =\/\$] \
        [E & -> bl V, =\/\$] \
        [V & -> ast E bl, =\/\$] \
        [V & -> id bl, =\/\$] \
      $,
    )
    state(
      "5",
      (1, 0.6),
      $
        [V & -> id bl, =\/\$] \
      $,
    )
    state(
      "6",
      (2, 1),
      $
        [S & -> V = bl E, \$] \
        [E & -> bl V, \$] \
        [V & -> bl ast E, \$] \
        [V & -> bl id, \$]
      $,
    )
    state(
      "7",
      (1, 0.95),
      $
        [V & -> ast E bl, =\/\$] \
      $,
    )
    state(
      "8",
      (1, 1.5),
      $
        [E & -> V bl, =\/\$] \
      $,
    )
    state(
      "9",
      (2, 0),
      $
        [S -> V = E bl, \$]
      $,
    )
    trans(<0>, <1.west>, $S$)
    trans(<0>, <2.west>, $V$)
    trans(<0>, <3.west>, $E$)
    trans(<0>, <4>, $*$)
    trans(<0>, <5.west>, $id$)
    trans(<4>, <4>, $*$, bend: 109deg, loop-angle: -90deg)
    trans(<4>, <5.west>, $id$)
    trans(<4>, <7>, $E$)
    trans(<4>, <8.west>, $V$)
    trans(<2.east>, <6>, $=$)
    trans(<6>, <9>, $E$)
    trans(<6>, <8.east>, $V$)
    trans(<6.south>, <4.south>, bend: 28deg, $*$)
    trans(<6>, <5.east>, $id$)
  },
))

#figure(table(
  columns: (2.5em,) * 8,
  table.cell(rowspan: 2)[State],
  table.cell(colspan: 4)[Action],
  table.cell(colspan: 3)[Goto],
  $=$, $*$, $id$, $\$$, $S$, $V$, $E$,
  [0], [], [s4], [s5], [ ], [1], [2], [3],
  [1], [], [], [], [acc], [], [], [],
  [2], [s6], [], [], [r5], [], [], [],
  [3], [], [], [], [r2], [], [], [],
  [4], [], [s4], [s5], [], [], [8], [7],
  [5], [r4], [], [], [r4], [], [], [],
  [6], [], [s4], [s5], [], [], [8], [9],
  [7], [r3], [], [], [r3], [], [], [],
  [8], [r5], [], [], [r5], [], [], [],
  [9], [], [], [], [r1], [], [], [],
))
= 2

考虑以下的文法：

$
  S & -> (L) \
  S & -> a \
  L & -> L, S \
  L & -> S
$

1. 如果需要计算输入串中有多少对匹配的括号，可以定义一个属性 npar，表示匹配的括号的
对数。请写出计算 npar 的属性文法。

2. 如果需要计算输入串的括号嵌套的深度，可以定义一个属性 deep，表示括号嵌套的深度。
请写出计算 deep 的属性文法。
