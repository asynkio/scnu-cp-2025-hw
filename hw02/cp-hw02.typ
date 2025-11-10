#import "@local/hw-template:1.0.0": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import fletcher.shapes: ellipse

#show: project.with(
  title: "CP HW02",
  authors: (
    (
      name: "Aksel Shen",
      email: "20234001053@m.scnu.edu.cn",
      affiliation: "South China Normal University",
    ),
  ),
  date: "2025-10-27",
)

= 1.

考虑正则表达式：

$
  (a a|b)^*a (a|b b)^*
$

#set enum(numbering: n => text(font: "HYShuSongYiJ")[(#n)])

1. 构造该正则表达式对应的NFA。

#let r = 0.7em

#grid(
  columns: 1,
  figure(
    diagram(
      node-stroke: .06em,
      edge-stroke: .06em,
      label-sep: 2pt,
      spacing: (1.0em, 0.3em),
      edge((-1, 0), "r", "-|>"),
      node((0, 0), $0$, name: <0>, radius: r),
      edge($epsilon$, "-|>"),
      node((1, 0), $1$, name: <1>, radius: r),
      edge($epsilon$, "-|>"),
      node((2, -1), $2$, name: <2>, radius: r),
      edge($a$, "-|>"),
      node((3, -1), $3$, name: <3>, radius: r),
      edge($epsilon$, "-|>"),
      node((4, -1), $4$, name: <4>, radius: r),
      edge($a$, "-|>"),
      node((5, -1), $5$, name: <5>, radius: r),
      edge($epsilon$, "-|>"),
      node((6, 0), $8$, name: <8>, radius: r),
      edge($epsilon$, "-|>"),
      node((7, 0), $9$, name: <9>, radius: r),
      edge($a$, "-|>"),
      node((8, 0), $10$, name: <10>, radius: r),
      edge($epsilon$, "-|>"),
      node((9, 0), $11$, name: <11>, radius: r),
      edge($epsilon$, "-|>"),
      node((10, -1), $12$, name: <12>, radius: r),
      edge($a$, "-|>"),
      node((13, -1), $13$, name: <13>, radius: r),
      edge($epsilon$, "-|>"),
      node((14, 0), $18$, name: <18>, radius: r),
      edge($epsilon$, "-|>"),
      node((15, 0), $19$, name: <19>, radius: r, extrude: (-2, 0)),

      edge((1, 0), (2, 1), $epsilon$, "-|>"),
      node((2, 1), $6$, name: <6>, radius: r),
      edge($b$, "-|>"),
      node((5, 1), $7$, name: <7>, radius: r),
      edge((5, 1), (6, 0), $epsilon$, "-|>"),

      edge((9, 0), (10, 1), $epsilon$, "-|>"),
      node((10, 1), $14$, name: <14>, radius: r),
      edge($b$, "-|>"),
      node((11, 1), $15$, name: <15>, radius: r),
      edge($epsilon$, "-|>"),
      node((12, 1), $16$, name: <16>, radius: r),
      edge($b$, "-|>"),
      node((13, 1), $17$, name: <17>, radius: r),
      edge((13, 1), (14, 0), $epsilon$, "-|>"),

      edge(<8>, (6, -4), (1, -4), <1>, $epsilon$, "-|>"),
      edge(<0>, (0, 4), (7, 4), <9>, $epsilon$, "-|>"),

      edge((14, 0), (14, -4), (9, -4), (9, 0), $epsilon$, "-|>"),
      edge((8, 0), (8, 4), (15, 4), (15, 0), $epsilon$, "-|>"),
    ),
  ),
)

#set align(left)

2. 将得到的NFA转为等价的DFA。

#grid(
  columns: (1fr, 1fr),
  $
    dash(s_0) & = {s_0, s_1, s_2, s_6, s_9}, \
    dash(s_1) & = {s_1, s_2, s_6}, \
    dash(s_2) & = {s_2}, \
    dash(s_3) & = {s_3, s_4}, \
    dash(s_4) & = {s_4}, \
    dash(s_5) & = {s_1, s_2, s_5, s_6, s_8, s_9}, \
    dash(s_6) & = {s_6}, \
    dash(s_7) & = {s_1, s_2, s_6, s_7, s_8, s_9}, \
    dash(s_8) & = {s_1, s_2, s_6, s_8, s_9}, \
    dash(s_9) & = {s_9},
  $,
  $
    dash(s_10) & = {s_10, s_11, s_12, s_14, s_19}, \
    dash(s_11) & = {s_11, s_12, s_14}, \
    dash(s_12) & = {s_12}, \
    dash(s_13) & = {s_11, s_12, s_13, s_14, s_18, s_19}, \
    dash(s_14) & = {s_14}, \
    dash(s_15) & = {s_15, s_16}, \
    dash(s_16) & = {s_16}, \
    dash(s_17) & = {s_11, s_12, s_14, s_17, s_18, s_19}, \
    dash(s_18) & = {s_11, s_12, s_14, s_18, s_19}, \
    dash(s_19) & = {s_19}.
  $,
)

#let r = 1em

#figure(
  diagram(
    node-stroke: .06em,
    edge-stroke: .06em,
    label-sep: 0.5pt,
    spacing: 2.9em,
    edge((-1, 0), "r", "-|>"),
    node((0, 0), $0$),
    edge("r", $a$, "-|>"),
    edge("d", $b$, "-|>"),
    node((1, 0), $1$, extrude: (-3, 0)),
    edge("r", $a$, "-|>"),
    edge("d", $b$, "-|>"),
    node((2, 0), $3$, extrude: (-3, 0)),
    edge("r", $a$, "-|>"),
    edge("d", $b$, "-|>", label-pos: 0.3),
    node((3, 0), $5$, extrude: (-3, 0)),
    edge("l", $a$, "-|>", bend: -40deg),
    edge("lld", $b$, "-|>", label-pos: 0.7),
    node((0, 1), $2$),
    edge("ud", bend: 130deg, loop-angle: 180deg, $b$, "-|>"),
    edge("ur", $a$, "-|>"),
    node((1, 1), $4$),
    edge("d", $b$, "-|>"),
    node((2, 1), $6$),
    edge("d", $a$, "-|>"),
    edge("r", $b$, "-|>"),
    node((3, 1), $9$, extrude: (-3, 0)),
    edge("u", $a$, "-|>"),
    edge("l", $b$, "-|>", bend: -40deg),
    node((1, 2), $7$, extrude: (-3, 0)),
    edge("u", $b$, "-|>", bend: -40deg),
    edge("d", $a$, "-|>"),
    node((2, 2), $8$),
    edge("r", $a$, "-|>"),
    node((1, 3), $10$, radius: r, extrude: (-3, 0)),
    edge("ud", bend: 130deg, loop-angle: 0deg, $a$, "-|>"),
    edge("uu", $b$, "-|>", bend: 33deg),
    node((3, 2), $11$, radius: r),
    edge("l", $a$, "-|>", bend: -40deg),
    edge(auto, (3, 3.6), "lll", (0, 1), $b$, "-|>", label-pos: 0.15),
  ),
)


3. 将得到的DFA最小化。

#figure(
  diagram(
    node-stroke: .06em,
    edge-stroke: .06em,
    label-sep: 1pt,
    spacing: (5em, 5em),
    node((0, 0), $0$),
    node((1, 0), $1$),
    node((0, 1), $2$, extrude: (-3, 0)),
    node((1, 1), $3$),
    edge((0, 0), (0, 0), $b$, "<|-", bend: 130deg),
    edge((0, 0), (1, 0), $a$, "-|>"),
    edge((1, 0), (0, 0), $a$, "-|>", bend: -40deg),
    edge((0, 0), (0, 1), $a$, "-|>"),
    edge((0, 1), (0, 1), $a$, "<|-", bend: -130deg),
    edge((0, 1), (1, 1), $b$, "-|>"),
    edge((1, 1), (0, 1), $b$, "-|>", bend: -40deg),
  ),
)
