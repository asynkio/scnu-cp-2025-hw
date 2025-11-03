#import "@local/hw-template:1.0.0": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/cetz:0.4.2" as cetz: canvas, draw, tree
#import fletcher.shapes: ellipse

#set par(justify: true)
#set page(
  footer: context [
    #set align(center)
    #set text(10pt)
    #counter(page).display() \
    #set text(8pt)
    本文档使用 Typst 排版创建，源代码存放于 #link("https://github.com/asynkio/scnu-cp-2025-hw")，根据
    Apache-2.0 许可证发布。
  ],
)

#show: project.with(
  title: "CP HW03",
  authors: (
    (
      name: "Aksel Shen",
      email: "20234001053@m.scnu.edu.cn",
      affiliation: "South China Normal University",
    ),
  ),
  date: "2025-11-3",
)

= 1.

考虑如下的文法：

$
  S & -> (L) \
  S & -> a \
  L & -> L,S \
  L & -> S \
$

其中 $S$ 和 $L$ 为非终结符，$S$ 为起始符号，“$(), a$” 均为终结符。

1. 请给出 $(a, (a, a))$ 的最左推导和最右推导。

2. 请画出 $(a, ((a, a), (a, a)))$ 的分析树。

*解：*

1.
  最左推导：

  $
    S & => (L) => (L,S) => (S,S) => (a,S) => (a,(L)) \
      & => (a, (L,S)) => (a, (S,S)) => (a, (a,S)) => (a, (a,a)).
  $

  最右推导：
  $
    S & => (L) => (L,S) => (L,(L)) => (L,(L,S)) \
      & => (L,(L,a)) => (L,(S,a)) => (L,(a,a)) => (S,(a,a)) => (a,(a,a)). \
  $

// 这什么鬼格式啊……
2.
#figure(
  canvas({
    import draw: *
    scale(54%)
    let tree_data = (
      $S$,
      $($,
      (
        $L$,
        (
          $L$,
          ($S$, $a$),
        ),
        $,$,
        (
          $S$,
          $($,
          (
            $L$,
            ($L$, ($S$, $($, ($L$, ($L$, ($S$, $a$)), $,$, ($S$, $a$)), $)$)),
            $,$,
            ($S$, $($, ($L$, ($L$, ($S$, $a$)), $,$, ($S$, $a$)), $)$),
          ),
          $)$,
        ),
      ),
      $)$,
    )
    tree.tree(
      tree_data,
      grow: 1.2,
      spread: 1.2,
      draw-node: (node, ..) => {
        if node.content in ($S$, $L$) {
          rect(
            (-.5, -.5),
            (.5, .5),
            fill: aqua.lighten(50%),
            stroke: 0.8pt,
            anchor: "center",
          )
        } else {
          circle((), radius: 0.5, fill: yellow.lighten(50%), stroke: 0.8pt)
        }
        content((0, 0), node.content)
      },
      draw-edge: (from, to, ..) => {
        let (a, b) = (from + ".south", to + ".north")
        line((a, .0, b), (b, -.1, a), stroke: 0.8pt)
      },
    )
  }),
)

#pagebreak()

= 2.

由字母表 $Sigma = {a_1, a_2, ..., a_n}$
所定义的命题逻辑语言 $L$ 是按照方式定义的：

1. 对于任何命题符号 $a_i in Sigma$，$a_i in L$；
2. 如果 $alpha in L$ 是命题公式，那么 $(not alpha) in L$；
3. 如果 $alpha, beta in L$，那么 $(alpha or beta), (alpha and beta) in L$。

请用文法规则描述语言 $L$。在规则之前，先定义你的终结符，非终结符和起始符号。

*解：*

终结符：$T = {a_1, a_2, ..., a_n, (, ), not, or, and} ,$

非终结符：$N = {S},$

起始符号：$S$.

文法规则：

$
  S & -> a_1 | a_2 | ... | a_n \
  S & -> (not S) \
  S & -> (S or S) \
  S & -> (S and S)
$
