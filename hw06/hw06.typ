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

= 1

考虑以下的文法，其中 $S$, $V$, $E$ 为非终结符，$=$, $id$, $*$ 为终结符：

$
  S & -> V = E \
  S & -> E \
  V & -> ast E \
  V & -> "id" \
  E & -> V \
$

1. 请写出上述文法的 LR(1) 的 DFA 和分析表。
2. 请写出上述文法的 LALR(1) 的 DFA 和分析表。

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
