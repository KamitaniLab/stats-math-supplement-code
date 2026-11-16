# 付録「R コードの文法」
# 付録の例のうち，データ（NHANES）が無くても走るものを集めました。
# 本文がコメントに書いた結果を，実際に走らせて確かめます。

cat("=== ベクトルを作る ===\n")
x <- c(1, 2, 3, 4, 5)
print(mean(x))                      # 結果は 3
scores <- c(60, 75, 80, 95)
print(seq(1.5, 12.5, by = 1))       # 1.5〜12.5 を「1きざみ」で並べる
print(rep(0, 5))                    # 0 0 0 0 0

cat("\n=== 一部を取り出す ===\n")
print(scores[1])                    # 60
print(scores[c(1, 3)])              # 60, 80
print(scores[scores >= 80])         # 80, 95

cat("\n=== 分布の関数（d・p・q・r）===\n")
print(dbinom(3, 10, 0.5))           # 10回中ちょうど3回，表が出る確率
print(pnorm(1.96))                  # ≒ 0.975
print(qnorm(0.975))                 # ≒ 1.96
print(qbeta(c(0.025, 0.975), 8, 4)) # 95%信用区間

cat("\n=== 乱数の種：同じ種なら同じ乱数 ===\n")
set.seed(12345)
print(rnorm(3))
set.seed(12345)
print(rnorm(3))

cat("\n=== 代入（<-）と判定（==），欠損（NA）===\n")
x <- 5
print(x == 5)                               # TRUE
print(mean(c(1, 2, NA)))                    # NA
print(mean(c(1, 2, NA), na.rm = TRUE))      # 1.5

cat("\n=== 曲線を描く ===\n")
# Rscript で走らせたときは，図は Rplots.pdf というファイルに出ます。
x <- seq(140, 200, length.out = 100)
plot(x, dnorm(x, 170, 5), type = "l", col = "blue", lwd = 2, ylab = "f(x)")
lines(x, dnorm(x, 170, 10), col = "red", lwd = 2)
abline(h = 0.04, col = "grey40", lty = 2)
legend("topright", legend = c("σ=5", "σ=10"), col = c("blue", "red"), lwd = 2)

cat("\n=== ~ を渡す関数（第2章の24人のデータ）===\n")
source("data_students24.R")              # grade・method・studyTime を作る
pass <- as.integer(grade >= 70)          # 70点以上なら1（第2章 第9節）
print(t.test(grade ~ method, var.equal = TRUE))         # 2群の t検定
print(coef(lm(grade ~ method)))                         # 群平均の差 9.467
print(coef(lm(grade ~ studyTime + method)))             # 勉強時間をそろえた差 8.471
print(coef(lm(grade ~ studyTime * method)))             # 交互作用も入れる
print(summary(aov(grade ~ method)))                     # 分散分析の表
print(coef(glm(pass ~ studyTime, family = binomial)))   # 結果が0か1のとき

cat("\n=== $ で結果の一部を取り出す ===\n")
result <- t.test(grade ~ method, var.equal = TRUE)     # 結果を result に保存してから
print(result$p.value)                                   # p値だけ取り出す（0.023）
print(t.test(grade ~ method, var.equal = TRUE)$p.value) # 保存せずに直接
