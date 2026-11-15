# 第3章「公式の導き方」

cat("=== 二乗誤差をいちばん小さくする m は平均 ===\n")
x <- c(2, 4, 4, 6, 9)
Q <- function(m) sum((x - m)^2)                  # 二乗誤差
print(optimize(Q, interval = c(0, 10))$minimum)  # 最小にする m を探す
print(mean(x))

cat("\n=== 内積から相関係数 ===\n")
y <- c(3, 5, 4, 8, 10)
xc <- x - mean(x); yc <- y - mean(y)             # 平均を引く（中心化）
print(sum(xc * yc) / sqrt(sum(xc^2) * sum(yc^2)))
print(cor(x, y))
