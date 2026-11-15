# 第4章「分布という語彙」

cat("=== 正規分布の面積（数値積分）===\n")
print(integrate(dnorm, -1.96, 1.96))

cat("\n=== モンテカルロ法：乱数の平均で積分を近似する ===\n")
set.seed(1)
x <- rnorm(1e6)               # 標準正規分布から100万個
print(mean(x^2))              # E[X^2]（＝分散1）のモンテカルロ近似
print(mean(abs(x) < 1.96))    # -1.96〜1.96 に入った乱数の割合

cat("\n=== z スコア（24人の成績の最高点と最低点）===\n")
source("data_students24.R")
print((max(grade) - mean(grade)) / sd(grade))   # 2.41
print((min(grade) - mean(grade)) / sd(grade))   # -1.17

cat("\n=== 主成分分析（200人の2つの得点）===\n")
# 次の4行は本文には載せていない「データの準備」です（2つの得点の架空データ）。
set.seed(42)
n <- 200
x1 <- rnorm(n); x2 <- 0.7 * x1 + sqrt(1 - 0.49) * rnorm(n)
X <- cbind(60 + 8 * x1, 65 + 10 * x2)
S <- cov(X)                                      # 共分散行列
print(eigen(S)$values)                           # 固有値（各方向のばらつき）
print(eigen(S)$values / sum(eigen(S)$values))    # 寄与率
print(summary(prcomp(X)))
