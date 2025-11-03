
#import "@local/hw-template:1.0.0": *

#show: project.with(
  title: "CP HW02",
  authors: (
    (
      name: "Aksel Shen",
      email: "20234001053@m.scnu.edu.cn",
      affiliation: "South China Normal University",
    ),
  ),
  date: "2025-10-20",
)
=

#set enum(numbering: "(1)")
#set align(left)

+ ${epsilon, a, b}$.
+ 任何 $b$ 不出现在任一 $a$ 之前的串的集合，即 \
  $
    {epsilon, a, b, a a, a b, b b, a a a, a a b, a b b, b b b, a a a a, a a a b, a a b b, a b b b, b b b b, ...}.
  $
+ 任何以 $a$ 开头的串的集合，即\
  $
    {a, a a, a b, a a a, a a b, a b a, a b b, a a a a, a a a b, a a b a, a a b b, a b a a, a b a b, a b b a, a b b b, ...}.
  $
+ 任何以 $a$ 或 $a b$ 结束的串的集合，即\
  $
    {a, a a, a b, a a a, a a b, b a, b a a, b a b, a a a a, a a a b, a b a, a b a a, a b a b, b a a, b a a a, b a a b, b b a, b b a a, b b a b, ...}.
  $
+ $
    {epsilon, a, b, a a, b a, b b, a a a, a a b, a b b, b a a, b b a, b b b, a a a a, a a b a, a a b b, b a a a, b a b b, b b a a, b b b a, b b b b, ...}.
  $

=

+ $[0-9]^*[0].$
+ $[1-9][0-9]^*.$
+ $[0-9]^*(0|2|4|6|8).$

=

_Proof._

- * 证明 $L(r^(**)) subset.eq L(r^(*))$ *

  设 $w in L(r^(**))$. 根据定义, $w$ 是由 0 个或多个 $r^(*)$ 串联而成的, 即 $w = w_1 w_2 ... w_k$, 其中 $k >= 0$ 且 $w_i in L(r^(*))$ 对所有 $1 <= i <= k$ 成立. 如果 $k = 0$, 则 $w = epsilon in L(r^(*))$. 如果 $k > 0$, 则由于 $w_i in L(r^(*))$ 对所有 $i$ 成立, 根据 $L(r^(*))$ 的闭包性质, 可知 $w = w_1 w_2 ... w_k in L(r^(*))$. 因此, 对任意 $w in L(r^(**))$, 都有 $w in L(r^(*))$, 即 $L(r^(**)) subset.eq L(r^(*))$.

- * 证明 $L(r^(*)) subset.eq L(r^(**))$ *

  设 $w in L(r^(*))$. 根据定义, $w$ 是由 0 个或多个 $r$ 串联而成的, 即 $w = w_1 w_2 ... w_k$, 其中 $k >= 0$ 且 $w_i in L(r)$ 对所有 $1 <= i <= k$ 成立. 注意到每个 $w_i in L(r)$ 也隐含地属于 $L(r^(*))$ (因为 $L(r) subset.eq L(r^(*))$). 因此, 可以将每个 $w_i$ 看作是一个单独的 $r^(*)$ 串联的结果. 这样, 我们可以将 $w$ 表示为 $w = w_1 w_2 ... w_k$, 其中每个 $w_i in L(r^(*))$. 根据 $L(r^(**))$ 的定义, 可知 $w in L(r^(**))$. 因此, 对任意 $w in L(r^(*))$, 都有 $w in L(r^(**))$, 即 $L(r^(*)) subset.eq L(r^(**))$.

综上, 由于 $L(r^(**)) subset.eq L(r^(*))$ 且 $L(r^(*)) subset.eq L(r^(**))$, 根据集合的双向包含性, 可得 $L(r^(**)) = L(r^(*))$. $qed$
