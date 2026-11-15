# 第1章「モデルの育て方」
# 24人の成績を，いちばん単純なモデル（1つの数）から順に育て，
# 当てはまり（RMSE）がどう変わるかを確かめます。

source("data_students24.R")

rmse <- function(y, yhat) sqrt(mean((y - yhat)^2))
# 小数 d 桁に四捨五入して表示（67.475 → 67.48。本文の書き方に合わせる）
f <- function(x, d = 2) formatC(round(x + sign(x) * 1e-9, d), format = "f", digits = d)

cat("=== 24人のデータ ===\n")
cat("成績    :", grade, "\n")
cat("勉強時間:", studyTime, "\n")
cat("学習法  :", as.character(method), "\n\n")
cat("成績   平均", f(mean(grade)), " SD", f(sd(grade)), " 中央値", f(median(grade)),
    " 範囲", min(grade), "-", max(grade), "\n")
cat("勉強時間と成績の相関 r :", f(cor(studyTime, grade), 3), "\n\n")

# はじめに・第1章が示す値（R の印字そのまま）
print(mean(grade))
print(sd(grade))
cat("\n")

# 最頻値（5点刻みのヒストグラムで，いちばん人数の多い区間の中心）
br <- seq(50, 95, by = 5)
h  <- hist(grade, breaks = br, plot = FALSE)
mo <- h$mids[which.max(h$counts)]
cat("=== ヒストグラム（5点刻み）===\n")
for (i in seq_along(h$counts)) cat(sprintf("  %2.0f-%2.0f : %d\n", br[i], br[i + 1], h$counts[i]))
cat("最頻値（いちばん多い区間の中心）=", mo, "\n\n")

m3 <- lm(grade ~ studyTime - 1)           # 勉強時間だけ（切片なし）
m4 <- lm(grade ~ studyTime)               # 切片＋勉強時間
m5 <- lm(grade ~ studyTime + method)      # ＋学習法（ダミー変数）
cat("=== RMSE の階段 ===\n")
cat("1 最頻値だけ           予測 =", f(mo, 1), "   RMSE =", f(rmse(grade, mo)), "\n")
cat("2 平均だけ             予測 =", f(mean(grade)), "  RMSE =", f(rmse(grade, mean(grade))), "\n")
cat("3 勉強時間（切片なし） 傾き =", f(coef(m3)[1], 3), "  RMSE =", f(rmse(grade, fitted(m3))), "（悪化）\n")
cat("4 切片＋勉強時間       切片 =", f(coef(m4)[1]), " 傾き =", f(coef(m4)[2], 3),
    " RMSE =", f(rmse(grade, fitted(m4))), "\n")
cat("5 ＋学習法             切片 =", f(coef(m5)[1]), " 傾き =", f(coef(m5)[2], 3),
    " ダミー =", f(coef(m5)[3], 3), " RMSE =", f(rmse(grade, fitted(m5))), "\n\n")

cat("=== 平均だけのモデルの RMSE と標準偏差 ===\n")
cat("RMSE（n で割る）       =", f(rmse(grade, mean(grade))), "\n")
cat("標準偏差 sd()（n-1 で割る）=", f(sd(grade)), "\n\n")

cat("=== 学習法ごとの平均 ===\n")
print(round(tapply(grade, method, mean), 4))
