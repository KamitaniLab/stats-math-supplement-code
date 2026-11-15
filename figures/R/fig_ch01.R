# 第1章「モデルの育て方」の図（4枚）
#   fig-ch1-hist.png   24人の成績のヒストグラム
#   fig-ch1-noint.png  切片のない直線（わざと失敗するモデル）
#   fig-ch1-line.png   切片と傾きを持つ直線
#   fig-ch1-ladder.png RMSE の階段
source("fig_common.R")

students24()      # 24人のデータ（grade・method・studyTime）
rmse <- function(y, yh) sqrt(mean((y - yh)^2))

## 成績のヒストグラム ── 1つの数で代表するとは
out("fig-ch1-hist.png", 1500, 820)
par_ja()
h <- hist(grade, breaks = seq(50, 95, 5), col = "grey80", border = "white",
          main = "", xlab = "成績（点）", ylab = "人数", ylim = c(0, 10))
abline(v = mean(grade), lwd = 3, lty = 1)
abline(v = 57.5,        lwd = 2.5, lty = 3)
text(mean(grade), 9.4, sprintf("平均 %.2f", round(mean(grade) + 1e-9, 2)), pos = 4, cex = 1.05)
text(57.5, 6.2, "最頻値 57.5", pos = 2, cex = 1.05)
dev.off()

## 切片のない直線
out("fig-ch1-noint.png", 1500, 900)
par_ja()
plot(studyTime, grade, pch = 19, col = "grey30", cex = 1.1, xlim = c(0, 11), ylim = c(0, 100),
     xlab = "勉強時間（時間／週）", ylab = "成績（点）", main = "")
m3 <- lm(grade ~ studyTime - 1)
abline(0, coef(m3)[1], lwd = 3, lty = 2)
abline(h = mean(grade), lwd = 2, lty = 3, col = "grey45")
points(0, 0, pch = 4, cex = 2, lwd = 3)
halo_text(2.6, 8, "原点を通ることを強制されている", pos = 4, cex = 1.1)
arrows(2.5, 8, 0.35, 1.5, length = 0.08, lwd = 1.4)
# 凡例は，点も線も無い右下に置く
legend(11.35, 47, xjust = 1, yjust = 1,
       legend = c(sprintf("切片なしの直線  RMSE %.2f", rmse(grade, fitted(m3))),
                  sprintf("平均だけのモデル  RMSE %.2f", rmse(grade, mean(grade)))),
       lty = c(2, 3), lwd = c(3, 2), col = c("black", "grey45"),
       text.col = c("black", "grey35"), bty = "n", cex = 1.1,
       seg.len = 2.6, x.intersp = 0.6, y.intersp = 1.25)
dev.off()

## 切片と傾きを持つ直線（縦の細い線が残差）
out("fig-ch1-line.png", 1500, 900)
par_ja()
plot(studyTime, grade, pch = 19, col = "grey30", cex = 1.1, xlim = c(0, 11), ylim = c(40, 100),
     xlab = "勉強時間（時間／週）", ylab = "成績（点）", main = "")
m4 <- lm(grade ~ studyTime)
abline(m4, lwd = 3)
abline(h = mean(grade), lwd = 2, lty = 3, col = "grey45")
segments(studyTime, grade, studyTime, fitted(m4), col = "grey55", lty = 1)
halo_text(9.3, 47, sprintf("切片 %.2f\n傾き %.3f\nRMSE %.2f",
     coef(m4)[1], coef(m4)[2], rmse(grade, fitted(m4))), cex = 1.1)
dev.off()

## RMSE の階段
out("fig-ch1-ladder.png", 1500, 880)
par_ja(mar = c(6.5, 4.2, 1.5, 1))
m5 <- lm(grade ~ studyTime + method)
v <- c(rmse(grade, 57.5), rmse(grade, mean(grade)), rmse(grade, fitted(m3)),
       rmse(grade, fitted(m4)), rmse(grade, fitted(m5)))
lab <- c("最頻値\nだけ", "平均\nだけ", "時間のみ\n（切片なし）", "切片＋\n時間", "＋ダミー\n（対面／オンライン）")
b <- barplot(v, names.arg = lab, col = c("grey80","grey80","grey45","grey80","grey80"),
             border = "white", ylab = "RMSE（点）", ylim = c(0, 23), las = 1,
             axisnames = FALSE)
# 棒の下のラベルは別に描いて，棒との間を空ける
axis(1, at = b, labels = lab, tick = FALSE, lwd = 0, mgp = c(0, 1.7, 0), cex.axis = 0.98)
text(b, v + 1.1, sprintf("%.2f", v), cex = 1.05)
dev.off()
cat("第1章の図を4枚作りました:", normalizePath(OUT_DIR), "\n")
