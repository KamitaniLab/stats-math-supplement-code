# 第6章「ベイズ統計の数理」：コイン投げ（10回中7回表）で周辺尤度とベイズファクターを計算する

n <- 10; k <- 7

cat("=== 周辺尤度 ===\n")
p0 <- dbinom(k, n, 0.5)                                    # M0：公正なコイン（θ = 0.5）
p1 <- integrate(function(th) dbinom(k, n, th), 0, 1)$value  # M1：θ に一様な事前分布
print(p0)                                                  # p(D | M0)
print(p1)                                                  # p(D | M1)（= 1/(n+1)）

cat("\n=== ベイズファクター ===\n")
BF10 <- p1 / p0
cat(sprintf("BF10 = %.4f\nBF01 = %.4f\n", BF10, 1 / BF10))

cat("\n=== 事前分布を変えると BF10 も変わる ===\n")
for (a in c(1, 2, 5, 20)) {
  pm <- integrate(function(th) dbinom(k, n, th) * dbeta(th, a, a), 0, 1)$value
  cat(sprintf("Beta(%2d,%2d)  p(D|M1) = %.5f   BF10 = %.3f\n", a, a, pm, pm / p0))
}

cat("\n=== BIC の計算で使う：θ = 0.7（最尤推定値）での尤度 ===\n")
print(dbinom(k, n, 0.7))
