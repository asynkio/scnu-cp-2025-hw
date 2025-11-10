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
  title: "CP HW04",
  authors: (
    (
      name: "Aksel Shen",
      email: "20234001053@m.scnu.edu.cn",
      affiliation: "South China Normal University",
    ),
  ),
  date: "2025-11-10",
)

以下文法中的大写字母为非终结符，小写字母为终结符，$S$ 为起始符号。

= 1.

考虑以下的文法：

$
  S & -> a B S | b A S | epsilon \
  A & -> b A A | a \
  B & -> a B B | b \
$

1. 请计算每个非终结符的 first 集合和 follow 集合。
2. 请计算每个规则右面的符号串的 first 集合。
3. 构造上述文法的预测分析表。

== 解：

1.
$
  "first"(S) & = {a, b, epsilon} \
  "first"(A) & = {a, b} \
  "first"(B) & = {a, b} \
  "follow"(S) & = {\$} union "follow"(S) = {\$} \
  "follow"(A) & = ("first"(S) \\ {epsilon}) union "first"(A) union "follow"(A) = {a, b, \$} \
  "follow"(B) & = ("first"(S) \\ {epsilon}) union "first"(B) union "follow"(B) = {a, b, \$} \
$

2.
$
    "first"(a B S) & = {a} \
    "first"(b A S) & = {b} \
  "first"(epsilon) & = {epsilon} \
    "first"(b A A) & = {b} \
        "first"(a) & = {a} \
    "first"(a B B) & = {a} \
        "first"(b) & = {b}
$

#set table(
  align: (x, y) => (
    if x == 0 or y == 0 {
      center
    } else { left }
  ),
)

3.
#figure(
  table(
    columns: (30pt, 50pt, 50pt, 50pt),
    [], $a$, $b$, $\$$,
    $S$, $-> a B S$, $-> b A S$, $-> epsilon$,
    $A$, $-> a$, $-> b A A$, [],
    $B$, $-> a B B$, $-> b$, [],
  ),
)

#pagebreak()

= 2.

请判断以下文法是不是 LL(1) 文法并给出理由：

$
  S & -> A B | P Q x \
  A & -> x y \
  B & -> b c \
  P & -> d P | epsilon \
  Q & -> a Q | epsilon \
$

== 解：

不是。

对于 $S -> A B$ 与 $S -> P Q x$，有 $"first"(A B) = "first"(A) = {x}$，
$"first"(P Q x) = ("first"(P) \\ epsilon) union ("first"(Q) \\ epsilon) union {x} = {a, d, x}$，则
$"first"(A B) union "first"(P Q x) = {x} eq.not emptyset$，
不满足 LL(1) 文法的条件。因此，该文法不是 LL(1) 文法。
