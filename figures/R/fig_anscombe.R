# 第2章「モデルの着せ替え」の図
#   fig-desc-anscombe.png  アンスコムの四重奏
# 相関係数も回帰直線もほぼ同じなのに，散布図の形はまるで違う4組のデータです
# （R に付属するデータ anscombe を使います）。
source("fig_common.R")

out("fig-desc-anscombe.png", 1500, 1400)
par_ja(c(2, 2), cex.lab = 1.7, cex.axis = 1.6, cex.main = 1.6,
       mar = c(4.2, 4.2, 2.8, 1))
for (i in 1:4) {
  x <- anscombe[[i]]; y <- anscombe[[i + 4]]
  plot(x, y, pch = 19, col = "grey30", cex = 1.3, xlim = c(3, 20), ylim = c(2, 14), las = 1,
       xlab = "x", ylab = "y", main = paste0("データセット", i,
       "（r = ", sprintf("%.2f", cor(x, y)), "）"))
  abline(lm(y ~ x), lwd = 2)
}
dev.off()
cat("アンスコムの四重奏の図を作りました:", normalizePath(OUT_DIR), "\n")
