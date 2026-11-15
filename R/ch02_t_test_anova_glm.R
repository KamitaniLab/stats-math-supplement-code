# 第2章「モデルの着せ替え」
# t検定・分散分析・ロジスティック回帰が，同じ線形モデルの着せ替えであることを確かめます。

source("data_students24.R")

cat("=== t検定（等分散を仮定）と線形モデル ===\n")
tt <- t.test(grade ~ method, var.equal = TRUE)
print(tt)
m <- lm(grade ~ method)
print(summary(m))
cat("t検定の t      :", sprintf("%.6f", tt$statistic), "\n")
cat("lm の t        :", sprintf("%.6f", summary(m)$coefficients[2, "t value"]), "\n")
cat("F 統計量       :", sprintf("%.6f", summary(m)$fstatistic[1]), "\n")
cat("t の二乗       :", sprintf("%.6f", summary(m)$coefficients[2, "t value"]^2), "\n\n")

cat("=== t.test() のデフォルトは Welch（分散を群ごとに見積もる）===\n")
print(t.test(grade ~ method))

cat("\n=== 分散分析（一元配置）：3群・各5人 ===\n")
dev <- c(-2, -1, 0, 1, 2)                       # 群の中でのずれ
y <- c(dev + 60, dev + 65, dev + 70)
g <- factor(rep(c("A", "B", "C"), each = 5))
print(summary(aov(y ~ g)))

cat("\n=== 分散分析（二元配置）：薬 × 年齢層，各セル5人 ===\n")
# drug: 薬（0 = 薬A，1 = 薬B）／age: 年齢層（0 = 若年層，1 = 高齢層）
cellmean <- c(6, 16, 16, 6)                     # (A・若年), (B・若年), (A・高齢), (B・高齢)
y2 <- c(dev + cellmean[1], dev + cellmean[2], dev + cellmean[3], dev + cellmean[4])
drug <- factor(rep(c(0, 1, 0, 1), each = 5))
age  <- factor(rep(c(0, 0, 1, 1), each = 5))
print(summary(aov(y2 ~ drug * age)))

cat("\n=== ロジスティック回帰：勉強時間から合否（70点以上）を予測 ===\n")
pass <- as.integer(grade >= 70)
print(summary(glm(pass ~ studyTime, family = binomial)))

cat("\n=== デザイン行列 ===\n")
d <- data.frame(勉強時間 = c(2, 5, 8),
                学習法 = factor(c("対面", "オンライン", "対面"),
                             levels = c("対面", "オンライン")))
print(model.matrix(~ 勉強時間 + 学習法, data = d))

cat("\n=== 正規方程式を解いた係数と lm() の係数 ===\n")
x <- c(2, 4, 4, 6, 9); yy <- c(3, 5, 4, 8, 10)
X <- cbind(1, x)
print(drop(solve(t(X) %*% X, t(X) %*% yy)))
print(coef(lm(yy ~ x)))
