# 第5章「推測のしくみ」の図
#   fig-alpha-beta.png  α と β ── 検定に出てくる2つの世界
# 片側検定で描きます（両側だと棄却域が2つになり，β の面積が見にくくなるため）。
source("fig_common.R")

d  <- 3                      # 本当の差（標準誤差を単位にした値）
cc <- qnorm(0.95)            # 棄却の境界（片側 α = 0.05）
xs <- seq(-3.6, 6.6, length = 700)
f0 <- dnorm(xs, 0, 1)        # 差がない世界（H0）
f1 <- dnorm(xs, d, 1)        # 差がある世界（H1）

out("fig-alpha-beta.png", 1500, 950)
par_ja(mar = c(4, 3.2, 2.2, 1))
plot(xs, f0, type = "n", ylim = c(0, 0.52), yaxt = "n",
     xlab = "検定統計量（差 ÷ 標準誤差）", ylab = "")
mtext("確率密度", side = 2, line = 1.2, cex = 1.2, family = JA_FAMILY)

poly <- function(x, y, ...) polygon(c(x, rev(x)), c(y, rep(0, length(y))), ...)

# 面積を重ねる順：検出力（薄い灰色）→ β（斜線）→ α（濃い灰色）→ 曲線
r1 <- xs >= cc
poly(xs[r1], f1[r1], col = "grey85", border = NA)            # 検出力 1-β：H1 のうち境界より右
l1 <- xs <= cc
poly(xs[l1], f1[l1], col = NA, border = "grey35", density = 16, angle = 45, lwd = 1)  # β：H1 のうち境界より左
poly(xs[r1], f0[r1], col = "grey35", border = NA)            # α：H0 のうち境界より右

lines(xs, f0, lwd = 2.2)
lines(xs, f1, lwd = 2.2, lty = 1, col = "grey30")
abline(v = cc, lty = 2, lwd = 1.6)

# 分布の名前と，面積のラベル
tx <- function(x, y, labels, ...) text(x, y, labels, family = JA_FAMILY, ...)
tx(-0.15, 0.44, expression(paste(H[0], "：差がない世界")), cex = 1.1, adj = 1)
tx(4.6, 0.44, expression(paste(H[1], "：差がある世界")), cex = 1.1, adj = 0.5)
tx(cc + 0.12, 0.495, "棄却の境界", cex = 1.1, adj = 0)

# α と β は面積が小さいので，引き出し線で指す
arrows(1.92, 0.095, 2.1, 0.025, length = 0.07, lwd = 1.5)
tx(1.78, 0.112, expression(paste(alpha, "（第1種の誤り）")), cex = 1.1, adj = 0)
arrows(-1.45, 0.180, 1.15, 0.035, length = 0.07, lwd = 1.5)
tx(-3.75, 0.205, expression(paste(beta, "（第2種の誤り")), cex = 1.1, adj = 0)
tx(-3.75, 0.163, "＝見逃し）", cex = 1.1, adj = 0)
# 検出力は広い塗りの中に直接書く
tx(3.6, 0.20, expression(paste("検出力 ", 1 - beta)), cex = 1.15)
dev.off()
cat("第5章の図を作りました:", normalizePath(OUT_DIR), "\n")
