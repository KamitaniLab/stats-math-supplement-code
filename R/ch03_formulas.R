# 第3章「公式の導き方」

cat("=== 二乗誤差をいちばん小さくする m は平均 ===\n")
x <- c(2, 4, 4, 6, 9)
S <- function(m) sum((x - m)^2)
print(optimize(S, interval = c(0, 10))$minimum)
print(mean(x))

cat("\n=== 内積から相関係数 ===\n")
y <- c(3, 5, 4, 8, 10)
xc <- x - mean(x); yc <- y - mean(y)
print(sum(xc * yc) / sqrt(sum(xc^2) * sum(yc^2)))
print(cor(x, y))
