#import "@local/hw-template:1.0.0": *
#import "@preview/equate:0.3.2": equate
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/cetz:0.4.2" as cetz: canvas, draw, tree
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *



#show: project.with(
  title: "CP 期中练习",
  authors: (
    (
      name: "Aksel Shen",
      email: "20234001053@m.scnu.edu.cn",
      affiliation: "South China Normal University",
    ),
  ),
  date: datetime.today().display(),
)

#show raw: it => it.text
#show: codly-init.with()
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

= 1.

考虑字母表 ${a, b}$ 下的正则表达式

$ (a|b)^* a b (a|b)^* $

1. 请给出正则表达式对应的 NFA。

2. 请给出上述 NFA 对应的 DFA 并最小化 DFA 的状态。

== 解

=== (1)

构造 NFA 如下：

#let nloop = (bend: -130deg, loop-angle: 270deg, label-side: right)

#figure(diagram(
  node-shape: circle,
  node-stroke: .07em + gr2,
  node-fill: gr1,
  edge-stroke: .06em + gr2,
  label-sep: 1pt,
  spacing: 3em,
  {
    node((0, 0), [0])
    node((1, 0), [1])
    node((2, 0), [2], extrude: (1, -1))

    edge((-1, 0), "r", "-|>")
    edge((0, 0), (0, 0), $a comma b$, "-|>", ..nloop)
    edge((0, 0), (1, 0), $a$, "-|>")
    edge((1, 0), (2, 0), $b$, "-|>")
    edge((2, 0), (2, 0), $a comma b$, "-|>", ..nloop)
  },
))

=== (2)

构造 DFA 如下：

#figure(diagram(
  node-shape: circle,
  node-stroke: .07em + gr2,
  node-fill: gr1,
  edge-stroke: .06em + gr2,
  label-sep: 1pt,
  spacing: 3em,
  {
    node((0, 0), [0])
    node((1, 0), [1])
    node((2, 0), [2], extrude: (1, -1))

    edge((-1, 0), "r", "-|>")
    edge((0, 0), (0, 0), $b$, "-|>", ..nloop)
    edge((0, 0), (1, 0), $a$, "-|>")
    edge((1, 0), (1, 0), $a$, "-|>", ..nloop)
    edge((1, 0), (2, 0), $b$, "-|>")
    edge((2, 0), (2, 0), $a comma b$, "-|>", ..nloop)
  },
))

该 DFA 已经是最小化的状态。

= 2.

考虑有如下的文法 $G[S]$：

$
  S & -> a S b S \
  S & -> a S \
  S & -> c
$

(1) 请画出输入串 $a c b a c$ 对应的分析树。

(2) 请说明 $G$ 是一个二义文法。

== 解

=== (1)

#figure(
  canvas({
    import draw: *
    scale(60%)
    let tree_data = (
      $S$,
      [$a$],
      (
        $S$,
        [$c$],
      ),
      [$b$],
      (
        $S$,
        [$a$],
        (
          $S$,
          [$c$],
        ),
      ),
    )
    tree.tree(
      tree_data,
      grow: 1.1,
      spread: 1.0,
      draw-node: (node, ..) => {
        if node.content in ([$a$], [$b$], [$c$]) {
          rect(
            (-.5, -.5),
            (.5, .5),
            fill: aqua.lighten(50%),
            stroke: 0.8pt,
            anchor: "center",
          )
        } else {
          circle(
            (),
            radius: 0.6,
            fill: yellow.lighten(50%),
            stroke: 0.8pt,
          )
        }
        content((0, 0), node.content)
      },
      draw-edge: (from, to, ..) => {
        let (a, b) = (from + ".south", to + ".north")
        line((a, .0, b), (b, -.1, a), stroke: 0.8pt)
      },
    )
  }),
  caption: [推导：$S => a S b S => a c b S => a c b a S => a c b a c$],
)

=== (2) 证明 $G$ 是二义文法

对于输入串 $a a c b c$，存在两棵不同的分析树：

*分析树 1*：

#figure(
  canvas({
    import draw: *
    scale(60%)
    let tree_data = (
      $S$,
      [$a$],
      (
        $S$,
        [$a$],
        ($S$, [$c$]),
      ),
      [$b$],
      (
        $S$,
        [$c$],
      ),
    )
    tree.tree(
      tree_data,
      grow: 1.1,
      spread: 1.0,
      draw-node: (node, ..) => {
        if node.content in ([$a$], [$b$], [$c$]) {
          rect(
            (-.5, -.5),
            (.5, .5),
            fill: aqua.lighten(50%),
            stroke: 0.8pt,
            anchor: "center",
          )
        } else {
          circle(
            (),
            radius: 0.6,
            fill: yellow.lighten(50%),
            stroke: 0.8pt,
          )
        }
        content((0, 0), node.content)
      },

      draw-edge: (from, to, ..) => {
        let (a, b) = (from + ".south", to + ".north")
        line((a, .0, b), (b, -.1, a), stroke: 0.8pt)
      },
    )
  }),
  caption: [推导 1：$S => a S b S => a a S b S => a a c b S => a a c b c$],
)

*分析树 2*：

#figure(
  canvas({
    import draw: *
    scale(60%)
    let tree_data = (
      $S$,
      [$a$],
      (
        $S$,
        [$a$],
        ($S$, [$c$]),
        [$b$],
        ($S$, [$c$]),
      ),
    )
    tree.tree(
      tree_data,
      grow: 1.1,
      spread: 1.0,
      draw-node: (node, ..) => {
        if node.content in ([$a$], [$b$], [$c$]) {
          rect(
            (-.5, -.5),
            (.5, .5),
            fill: aqua.lighten(50%),
            stroke: 0.8pt,
            anchor: "center",
          )
        } else {
          circle(
            (),
            radius: 0.6,
            fill: yellow.lighten(50%),
            stroke: 0.8pt,
          )
        }
        content((0, 0), node.content)
      },

      draw-edge: (from, to, ..) => {
        let (a, b) = (from + ".south", to + ".north")
        line((a, .0, b), (b, -.1, a), stroke: 0.8pt)
      },
    )
  }),
  caption: [推导 2：$S => a S => a a S b S => a a c b S => a a c b c$],
)

因为同一个句子存在两棵不同的分析树，所以文法 $G$ 是二义的。

= 3.

考虑有如下的文法 $G[S]$：

$
  S & -> a B c | b A B \
  A & -> a B b | b \
  B & -> b | epsilon
$

(1) 请构造文法 $G$ 的 LL(1) 分析表。

(2) 请给出符号串 $b a a b b b$ 的分析过程，并说明它是否是一个合法的输入。

== 解

=== (1)

计算 first 和 follow 集合：

#columns(2)[
  - $"first"(S) = {a, b}$
  - $"first"(A) = {a, b}$
  - $"first"(B) = {b, epsilon}$

  #colbreak()

  - $"follow"(S) = {\$}$
  - $"follow"(A) = {b}$
  - $"follow"(B) = {c, b, \$}$
]

LL(1) 分析表：

#set table(
  align: (x, y) => (
    if x == 0 or y == 0 {
      center
    } else { left }
  ),
)

#figure(table(
  columns: 5,
  [], $a$, $b$, $c$, $\$$,
  $S$, $-> a B c$, $-> b A B$, [], [],
  $A$, $-> a B b$, $-> b$, [], [],
  $B$, [], [$-> b$ \ $-> epsilon$], $-> epsilon$, $-> epsilon$,
))

$M[B, b]$ 中存在冲突，因此文法 $G$ 不是 LL(1) 文法。

=== (2)

由于在状态 $[B, b]$ 存在冲突，我们需要做出选择。

#figure(table(
  columns: 4,
  [步骤], [分析栈], [输入串], [使用的产生式],
  [1], [$\$ S$], [$b a a b b b \$$], [],
  [2], [$\$ c B a$], [$b a a b b b \$$], [$S -> a B c$（错误）],
))

从步骤 2 可以看出，选择 $S -> a B c$ 后无法匹配输入的 $b$，因此应选择 $S -> b A B$。

重新分析：

#figure(table(
  columns: 4,
  [步骤], [分析栈], [输入串], [使用的产生式],
  [1], [$\$ S$], [$b a a b b b \$$], [],
  [2], [$\$ B A b$], [$b a a b b b \$$], [$S -> b A B$],
  [3], [$\$ B A$], [$a a b b b \$$], [匹配 $b$],
  [4], [$\$ B b B a$], [$a a b b b \$$], [$A -> a B b$],
  [5], [$\$ B b B$], [$a b b b \$$], [匹配 $a$],
  [6], [$\$ B b B b$], [$a b b b \$$], [$B -> b$（选择 1）],
  [7], [$\$ B b B$], [$b b b \$$], [匹配 $b$],
  [8], [$\$ B b B b$], [$b b b \$$], [$B -> b$（选择 1）],
  [9], [$\$ B b B$], [$b b \$$], [匹配 $b$],
))

此时无法继续分析。若在步骤 6 时选择 $B -> epsilon$：

#figure(table(
  columns: 4,
  [步骤], [分析栈], [输入串], [使用的产生式],
  [6], [$\$ B b$], [$a b b b \$$], [$B -> epsilon$],
  [7], [$\$ B$], [$b b b \$$], [匹配 $b$（错误）],
))

步骤 7 出错，因为栈顶是 $B$ 但已匹配了 $b$，输入还是 $a$。

经过多次尝试，该符号串不是该文法的合法输入。

= 4.

考虑由正则表达式 $r$ 所生成的语言 $L$，$L'$ 是将 $L$ 中每个符号串反转后得到的语言：

$ L' = {a_1 a_2 dots.c a_n | a_n dots.c a_2 a_1 in L, n >= 0} $

请证明，$L'$ 也是某个正则表达式 $r'$ 所生成的语言。

== 证明

我们通过对正则表达式 $r$ 的结构进行归纳来证明。

*基础情况*：

1. 若 $r = emptyset$，则 $L = emptyset$，$L' = emptyset$，$r' = emptyset$。
2. 若 $r = epsilon$，则 $L = {epsilon}$，$L' = {epsilon}$，$r' = epsilon$。
3. 若 $r = a$，则 $L = {a}$，$L' = {a}$，$r' = a$。

*归纳步骤*：

假设对于正则表达式 $r_1$ 和 $r_2$，其对应的语言为 $L_1$ 和 $L_2$，反转后的语言 $L_1'$ 和 $L_2'$ 分别由正则表达式 $r_1'$ 和 $r_2'$ 生成。

1. *并运算*：若 $r = r_1 | r_2$，则 $L = L_1 union L_2$。
  对于任意 $w in L'$，存在 $w^R in L$（其中 $w^R$ 表示 $w$ 的反转）。

  - 若 $w^R in L_1$，则 $w in L_1'$，由归纳假设知 $w$ 可由 $r_1'$ 生成。
  - 若 $w^R in L_2$，则 $w in L_2'$，由归纳假设知 $w$ 可由 $r_2'$ 生成。

  因此 $L' = L_1' union L_2'$，取 $r' = r_1' | r_2'$。

2. *连接运算*：若 $r = r_1 r_2$，则 $L = L_1 L_2 = {w_1 w_2 | w_1 in L_1, w_2 in L_2}$。
  对于任意 $w in L'$，存在 $w^R in L$，即 $w^R = w_1 w_2$，其中 $w_1 in L_1$，$w_2 in L_2$。
  则 $w = (w_1 w_2)^R = w_2^R w_1^R$。
  由归纳假设，$w_1^R in L_1'$ 可由 $r_1'$ 生成，$w_2^R in L_2'$ 可由 $r_2'$ 生成。
  因此 $L' = {w_2^R w_1^R | w_1 in L_1, w_2 in L_2} = L_2' L_1'$，取 $r' = r_2' r_1'$。

3. *Kleene 闭包*：若 $r = r_1^*$，则 $L = L_1^* = {w_1 w_2 dots.c w_k | k >= 0, w_i in L_1}$。
  对于任意 $w in L'$，存在 $w^R in L^*$，即 $w^R = w_1 w_2 dots.c w_k$，其中每个 $w_i in L_1$。
  则 $w = (w_1 w_2 dots.c w_k)^R = w_k^R dots.c w_2^R w_1^R$。
  由归纳假设，每个 $w_i^R in L_1'$ 可由 $r_1'$ 生成。
  因此 $L' = {w_k^R dots.c w_1^R | k >= 0, w_i in L_1} = (L_1')^*$，取 $r' = (r_1')^*$。

*结论*：

由数学归纳法，对于任意正则表达式 $r$ 生成的语言 $L$，其反转语言 $L'$ 也可以由某个正则表达式 $r'$ 生成。构造 $r'$ 的规则如下：

$(emptyset)^R = emptyset$

$(epsilon)^R = epsilon$

$(a)^R = a$

$(r_1 | r_2)^R = r_1^R | r_2^R$

$(r_1 r_2)^R = r_2^R r_1^R$

$(r_1^*)^R = (r_1^R)^*$

#pagebreak()

= 5.

考虑语言

$ L = {a^m b^n | 0 <= m <= 2n} $

即 $L$ 中的串由若干个 $a$ 和若干个 $b$ 组成，并且 $a$ 的个数不超过 $b$ 的个数的两倍。

请写出三个文法表示 $L$，并且分别是 LR(1) 文法、二义文法、非二义并且非 LR(1) 的文法。

== 解

=== (1) LR(1) 文法

$
  S & -> A B \
  A & -> a A b | a A b b | epsilon \
  B & -> b B | epsilon
$

该文法通过 $A$ 生成满足 $m <= 2n$ 的 $a^m b^n$ 部分，其中：
- $A -> a A b$ 生成 $a$ 和 $b$ 数量相等的部分
- $A -> a A b b$ 生成 $a$ 的数量为 $b$ 的一半的部分
- $B$ 生成额外的 $b$

该文法是 LR(1) 的，因为它没有冲突，可以通过 LR(1) 分析表进行分析。

实际上，更简洁的 LR(1) 文法如下：

$
  S & -> a S b | a S b b | epsilon
$

该文法可以递归地生成符合条件的串：
- $S -> a S b$：每次添加一个 $a$ 和一个 $b$
- $S -> a S b b$：每次添加一个 $a$ 和两个 $b$
- $S -> epsilon$：终止递归

=== (2) 二义文法

$
  S & -> a S b | S S | a S b b | epsilon
$

该文法是二义的，因为对于某些串，存在多种推导方式。例如，对于串 $a b a b$，有以下两种推导：

*推导 1*：$S => S S => a S b S => a b S => a b a S b => a b a b$

*推导 2*：$S => S S => a S b a S b => a b a S b => a b a b$

这两种推导对应不同的分析树，因此该文法是二义的。

=== (3) 非二义且非 LR(1) 的文法

$
  S & -> A \
  A & -> a A b | a A b b | B \
  B & -> a B b | a B b b | epsilon
$

该文法是非二义的，因为每个串只有唯一的推导。但是，由于 $A$ 和 $B$ 的产生式结构相似，在 LR 分析时会产生归约/归约冲突，因此不是 LR(1) 文法。


#pagebreak()

= 6.

某同学在使用自顶向下分析方法来处理正整数的四则运算时，写下了如下的文法：

$
  E & -> E + E \
  E & -> E - E \
  E & -> E * E \
  E & -> E \/ E \
  E & -> (E) \
  E & -> n
$

(1) 请问如果使用上述文法进行自顶向下分析，会存在哪些问题。

(2) 请将上述文法改写为可以进行自顶向下分析的语法，并且能满足先加减后乘除的要求。

(3) 请实现改写后文法的递归下降分析程序 `TreeNode* parse(char* exp)`，对于输入的表达式 `exp`，返回这个表达式对应的语法树。请自行定义语法树节点 `TreeNode` 的数据结构。为了简化代码，可以假设表达式中的数均为一位数字。

== 解

=== (1) 存在的问题

- *左递归*：文法中存在直接左递归（如 $E -> E + E$），这会导致递归下降分析器陷入无限循环。当尝试展开 $E$ 时，会立即再次遇到 $E$，无法终止。

- *二义性*：文法是二义的，对于同一个表达式（如 $n + n * n$）可以有多种不同的分析树，无法确定运算符的优先级和结合性。

- *无法确定优先级*：文法没有区分不同运算符的优先级，无法实现"先乘除后加减"的要求。

=== (2) 改写后的文法

为了支持自顶向下分析并满足先乘除后加减的要求，将文法改写如下：

$
   E & -> T E' \
  E' & -> + T E' | - T E' | epsilon \
   T & -> F T' \
  T' & -> * F T' | \/ F T' | epsilon \
   F & -> (E) | n
$

该文法的特点：
- 消除了左递归，改用右递归形式
- 通过层次结构实现了运算符优先级：$E$（加减）→ $T$（乘除）→ $F$（因子）
- $E'$ 和 $T'$ 用于处理同级运算符的右结合

=== (3) 递归下降分析程序


#codly(languages: codly-languages)
````rust
#[derive(Debug)]
struct Parser {
    input: Vec<char>,
    pos: usize,
}

impl Parser {
    fn new(s: &str) -> Self {
        Parser {
            input: s.chars().collect(),
            pos: 0,
        }
    }

    fn current(&self) -> Option<char> {
        self.input.get(self.pos).copied()
    }

    fn eat(&mut self, c: char) -> bool {
        if self.current() == Some(c) {
            self.pos += 1;
            true
        } else {
            false
        }
    }

    // E -> T E'
    fn parse_e(&mut self) -> bool {
        self.parse_t() && self.parse_e_prime()
    }

    // E' -> + T E' | - T E' | ε
    fn parse_e_prime(&mut self) -> bool {
        match self.current() {
            Some('+') => {
                self.pos += 1;
                self.parse_t() && self.parse_e_prime()
            }
            Some('-') => {
                self.pos += 1;
                self.parse_t() && self.parse_e_prime()
            }
            _ => true, // epsilon
        }
    }

    // T -> F T'
    fn parse_t(&mut self) -> bool {
        self.parse_f() && self.parse_t_prime()
    }

    // T' -> * F T' | / F T' | ε
    fn parse_t_prime(&mut self) -> bool {
        match self.current() {
            Some('*') => {
                self.pos += 1;
                self.parse_f() && self.parse_t_prime()
            }
            Some('/') => {
                self.pos += 1;
                self.parse_f() && self.parse_t_prime()
            }
            _ => true, // epsilon
        }
    }

    // F -> (E) | n
    fn parse_f(&mut self) -> bool {
        match self.current() {
            Some('(') => {
                self.pos += 1;
                if self.parse_e() && self.eat(')') {
                    true
                } else {
                    false
                }
            }
            Some(c) if c.is_ascii_digit() => {
                self.pos += 1;
                true
            }
            _ => false,
        }
    }
}
````

*说明*：

- `Parser` 结构体包含输入字符串和当前位置。
- `parse_e`、`parse_e_prime`、`parse_t`、`parse_t_prime` 和 `parse_f` 方法分别实现了文法的各个产生式。
- `eat` 方法用于匹配并消费当前字符。

