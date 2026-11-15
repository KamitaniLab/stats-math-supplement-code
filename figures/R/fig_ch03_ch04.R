# 第3章「公式の導き方」と第4章「分布という語彙」の図（4枚）
#   fig-min-slope.png               最小の点では傾きが0になる（第3章）
#   fig-uncorrelated-dependent.png  無相関だが独立でない例（第3章）
#   fig-int-mc.png                  積分は面積，面積は乱数で近似できる（第4章）
#   fig-mvnorm.png                  2次元正規分布と主成分（第4章）
source("fig_common.R")

## 最小の点（谷底）では傾きが0になる
x <- c(2, 4, 4, 6, 9)
E <- function(m) sapply(m, function(mi) sum((x - mi)^2))   # 二乗誤差
ms <- seq(1, 9, length = 300)
out("fig-min-slope.png", 1400, 900)
par_ja()
plot(ms, E(ms), type = "l", lwd = 2, xlab = "候補の値 m", ylab = "二乗誤差 Q(m)")
tang <- function(m0, len = 1.6) {      # m0 での接線を短く描く
  sl <- -2 * sum(x) + 2 * length(x) * m0
  lines(c(m0 - len/2, m0 + len/2), E(m0) + sl * c(-len/2, len/2), lwd = 2, lty = 2)
  points(m0, E(m0), pch = 19)
}
tang(2.6); tang(5); tang(7.4)
halo_text(2.35, E(2.6) + 9, "傾き 負", adj = 0, cex = 1.15)
halo_text(5, E(5) + 8, "傾き 0（谷底）", adj = c(0.5, 0), cex = 1.15)
halo_text(7.6, E(7.4) + 9, "傾き 正", adj = 1, cex = 1.15)
abline(v = 5, lty = 3, col = "grey50")
halo_text(5, 100, "m = 平均 = 5", cex = 1.1, col = "grey30")
dev.off()

## 無相関でも独立ではない ── Y = X^2
# 点は Y = X^2 の上にちょうど乗ります。標本を左右対称に取るので，
# 標本の相関係数はちょうど0になり，最小二乗法の直線は水平になります。
set.seed(7)
u <- sort(runif(120, 0.02, 1))
xu <- c(-rev(u), u)          # 左右対称
yu <- xu^2
out("fig-uncorrelated-dependent.png", 1400, 950)
par_ja()
plot(xu, yu, pch = 16, cex = 0.6, col = "grey45",
     xlab = "X（−1 から 1 の一様分布）", ylab = expression(Y == X^2),
     xlim = c(-1.05, 1.05), ylim = c(-0.05, 1.18))
fit <- lm(yu ~ xu)
abline(fit, lwd = 2, lty = 2)
# 対称な2点は同じ Y を与える
pts <- c(-0.7, 0.7)
points(pts, pts^2, pch = 21, bg = "white", col = "black", lwd = 2, cex = 1.4)
segments(pts[1], pts[1]^2, pts[2], pts[2]^2, lty = 3, col = "grey30")
# 相関係数は -1e-17 のような値になるので，0 に丸めてから書く（「-0.00」を避ける）
rr <- cor(xu, yu); if (abs(rr) < 5e-3) rr <- 0
halo_text(0, 1.10, paste0("相関係数 r = ", sprintf("%.2f", rr),
                          " ── それでも X が決まれば Y は決まる"), cex = 1.1)
halo_text(0, 0.62, "−0.7 と +0.7 は同じ Y を与える", cex = 1.05)
halo_text(0, 0.42, "最小二乗法の直線（破線）は水平になる", cex = 1.05)
dev.off()

## 積分＝面積（左）と，モンテカルロ法による近似（右）
out("fig-int-mc.png", 1600, 800)
par_ja(c(1, 2), cex.lab = 1.4, cex.axis = 1.35, cex.main = 1.4)
xx <- seq(-4, 4, length = 400)
plot(xx, dnorm(xx), type = "l", lwd = 2, xlab = "x", ylab = "密度 f(x)",
     main = "積分＝面積")
xs <- seq(-1.96, 1.96, length = 200)
polygon(c(xs, rev(xs)), c(dnorm(xs), rep(0, 200)), col = "grey80", border = NA)
lines(xx, dnorm(xx), lwd = 2)
text(0, 0.05, "面積 = 0.95", cex = 1.25, family = JA_FAMILY)
set.seed(2)
n <- 3000
px <- runif(n, -4, 4); py <- runif(n, 0, 0.42)
inside <- py < dnorm(px)                 # 曲線の下に落ちた点
hit <- inside & abs(px) < 1.96           # そのうち ±1.96 の内側
# 内側は濃い塗りの点，外側は白抜きの丸。境目 ±1.96 に点線を引く
plot(px[inside], py[inside], pch = ifelse(hit[inside], 16, 1),
     cex = ifelse(hit[inside], 0.4, 0.55),
     col = ifelse(hit[inside], "grey25", "grey40"), xlim = c(-4, 4),
     xlab = "x", ylab = "密度 f(x)", main = "乱数で面積を近似")
lines(xx, dnorm(xx), lwd = 2)
abline(v = c(-1.96, 1.96), lty = 3, col = "grey40")
dev.off()

## 2次元正規分布 ── 200人の点数の散布図，確率の等高線，主成分の向き
set.seed(42)
n <- 200
x1 <- rnorm(n); x2 <- 0.7 * x1 + sqrt(1 - 0.49) * rnorm(n)   # 相関 0.7
X <- cbind(60 + 8 * x1, 65 + 10 * x2)
out("fig-mvnorm.png", 1400, 1150)
par_ja()
# asp = 1（縦横の目盛りを同じ長さに）にしないと，主成分が直交して見えない
plot(X, pch = 16, cex = 0.65, col = "grey55", asp = 1,
     xlab = "数学の点数", ylab = "物理の点数")
mu <- colMeans(X); S <- cov(X)
e <- eigen(S)
th <- seq(0, 2 * pi, length = 200)
for (q in c(0.5, 0.9, 0.99)) {           # 50%・90%・99% の楕円
  r <- sqrt(qchisq(q, df = 2))
  ell <- t(mu + t((cbind(cos(th), sin(th)) %*% diag(sqrt(e$values) * r)) %*% t(e$vectors)))
  lines(ell, lwd = 1.6, lty = 1, col = "grey20")
}
# 主成分の方向（長さは標準偏差の2倍）
arrows(mu[1], mu[2], mu[1] + e$vectors[1,1]*sqrt(e$values[1])*2,
       mu[2] + e$vectors[2,1]*sqrt(e$values[1])*2, lwd = 2.4, length = 0.09)
arrows(mu[1], mu[2], mu[1] + e$vectors[1,2]*sqrt(e$values[2])*2,
       mu[2] + e$vectors[2,2]*sqrt(e$values[2])*2, lwd = 2.4, length = 0.09)
halo_text(mu[1] + e$vectors[1,1]*sqrt(e$values[1])*2,
     mu[2] + e$vectors[2,1]*sqrt(e$values[1])*2 + 4.0, "第1主成分",
     cex = 1.15, adj = c(0.5, 0))
halo_text(mu[1] + e$vectors[1,2]*sqrt(e$values[2])*3.2 - 1.2,
     mu[2] + e$vectors[2,2]*sqrt(e$values[2])*3.2, "第2主成分",
     cex = 1.15, adj = c(1, 0.5))
dev.off()
cat("第3章・第4章の図を4枚作りました:", normalizePath(OUT_DIR), "\n")
