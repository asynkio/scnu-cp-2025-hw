#import "@local/hw-template:1.0.0": *
#import "@preview/equate:0.3.2": equate
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/cetz:0.4.2" as cetz: canvas, draw, tree
#import "@preview/tdtr:0.4.3": *

#show: project.with(
  title: "CP HW07",
  authors: (
    (
      name: "Aksel Shen",
      email: "20234001053@m.scnu.edu.cn",
      affiliation: "South China Normal University",
    ),
  ),
  date: datetime.today().display(),
)

#show raw.where(block: true): set text(size: 8pt)



#let bl = math.class("normal", sym.bullet)

#let lexp = "lexp"
#let number = math.bold("number")
#let op = "op"
#let lexpseq = "lexp-seq"
#let val = "val"
#let getval = "getval"
#let apply = "apply"
#let type = "type"
#let vals = "vals"
#let append = "append"

= 1

考虑如下类似 LISP 语言的前缀表达式文法：

$
     lexp & -> number | (op lexpseq) \
       op & -> + | - | * \
  lexpseq & -> lexpseq lexp | lexp
$

定义一个语义属性 val 为表达式的值。例如，对于前缀表达式 `(* (-2) 3 4)`，即 $(-2) times 3 times 4$ 的值 $val = -24$。

1. 请为上述文法写出相应的语义规则。假设对于非终结符 $number$ 的属性值可由函数 $getval()$ 得到。
2. 请给出输入 `(* (-2) 3 4)` 所对应的包含属性计算的语法树，并标出计算的次序。

== 解

1. 语义规则如下：

#figure(table(
  columns: (13em, 21em),
  align: left,
  [Production], [Semantic Rule],
  $lexp -> number$, $lexp.#val = getval(number)$,
  $lexp -> (op lexpseq)$, $lexp.#val = apply(op.#type, lexpseq.#vals)$,
  $op -> +$, $op.#type = "Add"$,
  $op -> -$, $op.#type = "Sub"$,
  $op -> *$, $op.#type = "Mul"$,
  $lexpseq -> lexp$, $lexpseq.#vals = [lexp.#val]$,
  $lexpseq -> lexpseq_1 lexp$,
  $lexpseq.#val = "append"(lexpseq_1.#vals, lexp.#val)$,
))

其中 $vals$ 是一个综合属性，表示表达式序列的值列表；函数 $"append"(a, b)$
表示将值 $b$ 添加到列表 $a$ 的末尾；函数
$apply(op, a)$ 表示对列表 $a$ 中的值按操作符 $op$ 进行计算。

2. 计算顺序：

  1. $val = getval(2) = 2$.
  2. $lexpseq.#vals = [2]$.
  3. $op.#type = "Sub"$.
  4. $apply("Sub", [2]) = -2$.
  5. $lexpseq.#vals = [-2]$,
  6. $val = getval(3) = 3$.
  7. $lexpseq.#vals = append([-2], 3) = [-2, 3]$.
  8. $val = getval(4) = 4$.
  9. $lexpseq.#vals = append([-2, 3], 4) = [-2, 3, 4]$.
  10. $op.#type = "Mul"$.
  11. $apply("Mul", [-2, 3, 4]) = (-2) times 3 times 4 = -24$.

*语法树*：

#figure(
  canvas({
    import draw: *
    scale(54%)
    let tree_data = (
      lexp,
      [(],
      (op, [\*]),
      (
        lexpseq,
        (
          lexpseq,
          (
            lexpseq,
            (lexp, [(], (op, [-]), (lexpseq, (lexp, ($number$, [2]))), [)]),
          ),
          (lexp, ($number$, [3])),
        ),
        (lexp, ($number$, [4])),
      ),
      [)],
    )
    tree.tree(
      tree_data,
      grow: 1.2,
      spread: 1.4,
      draw-node: (node, ..) => {
        if node.content in ([(], [)], [\*], [-], [2], [3], [4]) {
          rect(
            (-.5, -.5),
            (.5, .5),
            fill: aqua.lighten(50%),
            stroke: 0.8pt,
            anchor: "center",
          )
        } else {
          let width = (measure(node.content).width * 2.1 + 0.2cm).cm()
          rect(
            (-width / 2, -.5),
            (rel: (width, 1)),
            radius: 0.5,
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
)

= 2

考虑如下的一段三地址中间代码：

```
01: dp = 0
02: i = 0
03: t1 = i * 8
04: t2 = A[t1]
05: t3 = i * 8
06: t4 = B[t3]
07: t5 = t2 * t4
08: dp = dp + t5
09: i = i + 1
10: if (i < n) goto (03)
```

1. 请将上述代码划分为基本块，并画出流图。
2. 请使用消除公共子表达式，对归纳变量进行强度消减，消除归纳变量等方法，尽可能优化上述代码。请写出优化的过程和依据。

== 解

#set enum(numbering: "(1)(a)")
1. *基本块划分*

由于代码在 `10: if (i < n) goto (03)` 处有条件跳转，且没有其他跳转指令，因此可以从
跳转目标 `03` 开始划分出一个新的基本块，如下：

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

- *$B_1$（入口块）*：
  #let B1 = ```
  01: dp = 0
  02: i = 0
  ```

#B1

#pagebreak()

- *$B_2$（循环体）*：
#let B2 = ```
03: t1 = i * 8
04: t2 = A[t1]
05: t3 = i * 8
06: t4 = B[t3]
07: t5 = t2 * t4
08: dp = dp + t5
09: i = i + 1
10: if (i < n) goto (03)
```
#B2

*流图*：
#{
  show raw: it => it.text
  figure(diagram(
    node-shape: rect,
    node-stroke: .07em + gr2,
    node-corner-radius: 4pt,
    node-fill: gr1,
    edge-stroke: .06em + gr2,
    label-sep: 0.5pt,
    spacing: 1.5em,
    debug: 0,
    {
      let block(index, pos, code) = node(
        pos,
        name: str(index),
        width: 130pt,
        align(left, code)
          + place(
            right + top,
          )[$B_#index$],
      )


      block(1, (0, 0), B1)
      edge("-|>")
      block(2, (0, 2), B2)
      edge("d,r,uu,l,d", shift: -15pt, "-|>")
    },
  ))
}

//
// #figure(diagram(
//   node-shape: rect,
//   node-stroke: .07em + gr2,
//   node-corner-radius: 4pt,
//   node-fill: gr1,
//   edge-stroke: .06em + gr2,
//   label-sep: 0.5pt,
//   spacing: 3em,
//   {
//     let block(name, pos, code) = node(
//       pos,
//       name: name,
//       pad(10pt, align(left, raw(code, lang: none)))
//         + place(
//           right + top,
//           dx: -5pt,
//           dy: 5pt,
//           text(10pt, black.transparentize(50%), name),
//         ),
//     )
//     let trans(a, b, label, ..args) = edge(
//       a,
//       b,
//       label,
//       "-|>",
//       label-side: center,
//       ..args,
//     )
//
//     block("B1", (0, 0), "01: dp = 0\n02: i = 0")
//     block(
//       "B2",
//       (0, 1),
//       "03: t1 = i * 8\n04: t2 = A[t1]\n05: t3 = i * 8\n06: t4 = B[t3]\n07: t5 = t2 * t4\n08: dp = dp + t5\n09: i = i + 1\n10: if (i < n) goto (03)",
//     )
//     block("Exit", (0, 2), "出口")
//
//     trans(<B1>, <B2>, "")
//     trans(<B2>, <B2>, "i < n", bend: -130deg, loop-angle: 0deg)
//     trans(<B2>, <Exit>, "i >= n")
//   },
// ))
//
2. *代码优化*：

  + *消除公共子表达式*

    在基本块 B2 中，语句 03 和 05 计算相同的表达式 `i * 8`：
    ```
    03: t1 = i * 8
    05: t3 = i * 8
    ```

    可以消除重复计算，将 `t3` 替换为 `t1`：
    ```
    03: t1 = i * 8
    04: t2 = A[t1]
    06: t4 = B[t1]    // Replace t3 with t1
    07: t5 = t2 * t4
    08: dp = dp + t5
    09: i = i + 1
    10: if (i < n) goto (03)
    ```

  + *Strength Reduction*

    归纳变量分析：
    - `i` 是基本归纳变量，在循环中每次加 1
    - `t1 = i * 8` 是派生归纳变量，依赖于 `i`

    可以将乘法操作 `i * 8` 替换为加法操作。引入新变量 `t1_new`：
    - 初始值：`t1_new = 0`（因为 `i` 初始为 0）
    - 每次迭代：`t1_new = t1_new + 8`

    优化后的代码：
    ```
    01: dp = 0
    02: i = 0
    02.5: t1 = 0        // Initialization
    03: t2 = A[t1]      // Delete t1 = i * 8
    04: t4 = B[t1]
    05: t5 = t2 * t4
    06: dp = dp + t5
    07: i = i + 1
    08: t1 = t1 + 8     // Strength Reduction
    09: if (i < n) goto (03)
    ```

+ *删除无用变量*

  变量 `i` 在循环体内只用于循环条件判断和递增。经过强度消减后，`i * 8` 已被 `t1` 的增量更新替代。但 `i` 仍需用于循环终止条件 `i < n`。

  如果可以将终止条件改为用 `t1` 表示（`t1 < n * 8`），则可以完全消除 `i`：

  ```
  01: dp = 0
  02: t1 = 0
  03: t2 = A[t1]
  04: t4 = B[t1]
  05: t5 = t2 * t4
  06: dp = dp + t5
  07: t1 = t1 + 8
  08: if (t1 < n * 8) goto (03)
  ```

  进一步优化，可以预先计算 `n * 8`：
  ```
  01: dp = 0
  02: t1 = 0
  02.5: limit = n * 8   // 预计算循环上界
  03: t2 = A[t1]
  04: t4 = B[t1]
  05: t5 = t2 * t4
  06: dp = dp + t5
  07: t1 = t1 + 8
  08: if (t1 < limit) goto (03)
  ```

*最终优化结果*：

```
01: dp = 0
02: t1 = 0
03: limit = n * 8
04: t2 = A[t1]
05: t4 = B[t1]
06: t5 = t2 * t4
07: dp = dp + t5
08: t1 = t1 + 8
09: if (t1 < limit) goto (04)
```
