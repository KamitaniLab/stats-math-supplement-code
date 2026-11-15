# 第4章「分布という語彙」

cat("=== 正規分布の面積（数値積分）===\n")
print(integrate(dnorm, -1.96, 1.96))

cat("\n=== モンテカルロ法：乱数の平均で積分を近似する ===\n")
set.seed(1)
z <- rnorm(1e6)
print(mean(z^2))              # E[Z^2]（＝分散1）の近似
print(mean(abs(z) < 1.96))    # -1.96〜1.96 に入った乱数の割合

cat("\n=== 主成分分析（200人の2つの得点）===\n")
set.seed(42)
n <- 200
x1 <- rnorm(n); x2 <- 0.7 * x1 + sqrt(1 - 0.49) * rnorm(n)
X <- cbind(60 + 8 * x1, 65 + 10 * x2)
S <- cov(X)
print(eigen(S)$values)
print(eigen(S)$values / sum(eigen(S)$values))
print(summary(prcomp(X)))
