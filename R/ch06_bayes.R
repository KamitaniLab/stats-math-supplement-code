# 第6章「ベイズ統計の数理」：コイン投げ（10回中7回表）で周辺尤度とベイズファクターを計算する

n <- 10; k <- 7

cat("=== 事後分布 Beta(8, 4) の 95% の区間 ===\n")
print(qbeta(c(0.025, 0.975), 8, 4))             # 等裾区間（両端から 2.5% ずつ捨てる）
width <- function(lo) qbeta(pbeta(lo, 8, 4) + 0.95, 8, 4) - lo
lo <- optimize(width, c(0, qbeta(0.05, 8, 4)))$minimum
print(c(lo, lo + width(lo)))                    # 最高密度区間（95% が入るいちばん短い区間）

cat("\n=== 周辺尤度 ===\n")
print(dbinom(k, n, 0.5))                                    # p(D | M0)：公正なコイン（θ = 0.5）
print(integrate(function(th) dbinom(k, n, th), 0, 1)$value) # p(D | M1)：θ に一様な事前分布（= 1/(n+1)）

cat("\n=== ベイズファクター ===\n")
BF10 <- 0.09090909 / 0.1171875
print(BF10)        # M1 : M0
print(1 / BF10)    # M0 : M1

cat("\n=== 二項検定と，M1 の事後確率（事前オッズ 1:1）===\n")
print(binom.test(k, n)$p.value)
print(BF10 / (1 + BF10))

cat("\n=== 事前分布を変えると BF10 も変わる ===\n")
p0 <- dbinom(7, 10, 0.5)   # M0（θ=0.5）での出やすさ
for (a in c(1, 2, 5, 20)) {
  f  <- function(th) dbinom(7, 10, th) * dbeta(th, a, a)
  pm <- integrate(f, 0, 1)$value
  cat(sprintf("Beta(%2d,%2d)  p(D|M1) = %.5f   BF10 = %.3f\n",
              a, a, pm, pm / p0))
}

cat("\n=== BIC からベイズファクターを近似する ===\n")
print(dbinom(k, n, 0.7))                          # θ = 0.7（最尤推定値）での尤度
bic0 <- -2 * log(dbinom(k, n, 0.5))               # 合わせるパラメータは 0 本
bic1 <- -2 * log(dbinom(k, n, 0.7)) + 1 * log(n)  # θ の 1 本
print(c(bic0, bic1))
print(exp((bic0 - bic1) / 2))
