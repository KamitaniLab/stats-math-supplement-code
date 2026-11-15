# 第5章「推測のしくみ」
# 第5章には R の枠がありませんが，地の文に出てくる計算値をここで確かめられます。
# 各行の右のコメントが「本文の値」です。

source("data_students24.R")

cat("=== 冒頭の出力：summary(lm(grade ~ method)) の係数の表 ===\n")
m <- lm(grade ~ method)
co <- summary(m)$coefficients
print(round(co, 3))
# (Intercept)   62.742  2.739  22.908  <2e-16
# methodonline   9.467  3.873   2.444   0.023
est <- co["methodonline", "Estimate"]              # 2群の差
se  <- co["methodonline", "Std. Error"]            # 差の標準誤差
cat("差 ÷ 標準誤差 =", round(est / se, 3), "\n")   # 2.444（t value の列）

cat("\n=== 標準誤差と √n の法則 ===\n")
sigma <- 20                                        # 確認問題の母標準偏差
print(sigma / sqrt(c(25, 100, 400)))               # 4  2  1（n を4倍にすると半分）
print(3^2)                                         # 9（標準誤差を 1/3 にするには9倍）

cat("\n=== エラーバーの重なりを検定として読むと ===\n")
# 独立な2群，正規近似，標準誤差が等しい場合。差の標準誤差は √2 × SE
print(2 * pnorm(1) - 1)                            # 約0.68（±1SE はおよそ68%信頼区間）
a1 <- 2 * pnorm(-sqrt(2))                          # ±1SE の棒が重ならない確率
print(a1)                                          # 約0.15〜0.16
print(a1 / 0.05)                                   # 約3（5%のつもりが3倍甘い）
print(1 - 2 * pnorm(-qnorm(0.975) * sqrt(2)))      # 0.99以上（95%信頼区間が重なる確率）
print(2 * pnorm(qnorm(0.975) / sqrt(2)) - 1)       # 約0.83〜0.84（5%検定にあたる信頼区間）
print(qnorm(0.975))                                # 1.96

cat("\n=== 検定統計量と信頼区間：x の平均 165，SEM 3 ===\n")
xbar <- 165
sem  <- 3
print((xbar - 160) / sem)                          # 1.67（1.96 より小さいので棄却されない）
ci <- xbar + c(-1, 1) * 1.96 * sem
print(ci)                                          # 159.12  170.88
print((xbar - ci) / sem)                           # 1.96  -1.96（区間の端はちょうど境界）

cat("\n=== 冒頭の出力の差の信頼区間と p 値 ===\n")
print(df.residual(m))                              # 22（24 - 2）
tcrit <- qt(0.975, df = 22)
print(tcrit)                                       # 2.07
print(est + c(-1, 1) * tcrit * se)                 # 1.4  17.5
print(confint(m)["methodonline", ])                # 同じ値
tval <- co["methodonline", "t value"]
print(2 * pt(-abs(tval), df = 22))                 # 0.023（両側）
print(pt(tval, df = 22, lower.tail = FALSE))       # 0.012（片側。両側の半分）

cat("\n=== ブートストラップ：1つの観測値が再標本に入らない確率 ===\n")
n <- c(10, 24, 100, 1000)
print((1 - 1 / n)^n)                               # n が大きいと約0.37
print(exp(-1))                                     # 0.37（n を大きくした極限）
# 24人の成績で試す（乱数なので，走らせるたびに細部は違います）
idx <- sample(24, replace = TRUE)                  # 復元抽出
print(mean(!(1:24 %in% idx)))                      # 入らなかった人の割合。およそ 1/3

cat("\n=== 「有意差なし」の2つの研究（架空の例）===\n")
# 研究A：差 1.0，標準誤差 0.714／研究B：差 0.1，標準誤差 0.204
d_ab  <- c(A = 1.0, B = 0.1)
se_ab <- c(A = 0.714, B = 0.204)
lower <- d_ab - 1.96 * se_ab
upper <- d_ab + 1.96 * se_ab
print(round(rbind(lower, upper), 1))               # A: -0.4〜2.4  B: -0.3〜0.5
print(round(upper - lower, 1))                     # 幅  A: 2.8  B: 0.8
print(round(2 * pnorm(-abs(d_ab / se_ab)), 2))     # p   A: 0.16  B: 0.62

cat("\n=== サンプルサイズ設計 ===\n")
n06 <- power.t.test(delta = 0.6, sd = 1, sig.level = 0.05, power = 0.80)$n
n03 <- power.t.test(delta = 0.3, sd = 1, sig.level = 0.05, power = 0.80)$n
print(c(n06, n03))                                 # 1群あたり約45人，約176人
print(n03 / n06)                                   # 約4倍（n はおよそ 1/d^2 に比例）

cat("\n=== 効果量を「実感」に翻訳する ===\n")
d <- 0.8
print(2 * pnorm(-d / 2))                           # 約0.7（2群の分布の重なり）
print(pnorm(d / sqrt(2)))                          # 0.71（優越確率）
print(0.5 * (1 - 0.5))                             # 0.25（群が半々のときの Var(X) = 1/4）
print(d / sqrt(d^2 + 4))                           # 0.37（d = 0.8 を r に）
r <- 0.11
print(2 * r / sqrt(1 - r^2))                       # 0.22（r = 0.11 を d に）

cat("\n=== 多重比較：少なくとも1回「有意」が出る確率 ===\n")
k <- c(5, 10, 20, 100)                             # 検定の回数
print(1 - 0.95^k)                                  # 0.226  0.40  0.64  0.994
print(0.05 / c(5, 20))                             # ボンフェローニ補正  0.01  0.0025
print(40 / 50)                                     # 0.8（50の食材のうち40）

cat("\n=== 確認問題：x の平均 50，SEM 2 の95%信頼区間 ===\n")
print(50 + c(-1, 1) * 1.96 * 2)                    # 46.08  53.92
