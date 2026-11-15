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
cat("t検定の p 値   :", sprintf("%.8f", tt$p.value), "\n")
cat("lm の p 値     :", sprintf("%.8f", summary(m)$coefficients[2, "Pr(>|t|)"]), "\n")
cat("F 統計量       :", sprintf("%.6f", summary(m)$fstatistic[1]), "\n")
cat("t の二乗       :", sprintf("%.6f", summary(m)$coefficients[2, "t value"]^2), "\n\n")

cat("=== t.test() のデフォルトは Welch（分散を群ごとに見積もる）===\n")
print(t.test(grade ~ method))

cat("\n=== 分散分析（一元配置）：3群・各5人 ===\n")
dev <- c(-2, -1, 0, 1, 2)                       # 群の中でのずれ
y <- c(dev + 60, dev + 65, dev + 70)            # 群平均 60・65・70
g <- factor(rep(c("A", "B", "C"), each = 5))
print(summary(aov(y ~ g)))

cat("\n=== 分散分析（二元配置）：薬 × 年齢層，各セル5人 ===\n")
# drug: 薬（0 = 薬A，1 = 薬B）／age: 年齢層（0 = 若年層，1 = 高齢層）
cellmean <- c(6, 16, 16, 6)                     # (A・若年), (B・若年), (A・高齢), (B・高齢)
y2 <- c(dev + cellmean[1], dev + cellmean[2], dev + cellmean[3], dev + cellmean[4])
drug <- factor(rep(c(0, 1, 0, 1), each = 5))
age  <- factor(rep(c(0, 0, 1, 1), each = 5))
# 本文では y と書いています（ここでは一元配置の y と区別するため y2）
print(summary(aov(y2 ~ drug * age)))

cat("\n=== ロジスティック回帰：勉強時間から合否（70点以上）を予測 ===\n")
pass <- as.integer(grade >= 70)
print(summary(glm(pass ~ studyTime, family = binomial)))

cat("\n=== 正規方程式を解いた係数と lm() の係数 ===\n")
x <- c(2, 4, 4, 6, 9)
y <- c(3, 5, 4, 8, 10)
X <- cbind(1, x)                        # 切片の列1と説明変数
beta <- solve(t(X) %*% X, t(X) %*% y)   # 正規方程式を解く
print(drop(beta))
print(coef(lm(y ~ x)))                  # lm() と一致

cat("\n=== 説明変数が重複するとき（x3 は x1 の2倍）===\n")
set.seed(20260828)
n12 <- 12
x1 <- round(rnorm(n12, 5, 2), 2); x2 <- round(rnorm(n12, 3, 1), 2)
yd <- round(2 + 1.5 * x1 - 0.8 * x2 + rnorm(n12), 3)
x3 <- 2 * x1                            # x1 の定数倍。情報が重複している
print(coef(lm(yd ~ x1 + x3)))           # lm() は片方を NA と表示する

cat("\n=== デザイン行列 ===\n")
# 本文と同じく，列の名前に日本語を使います。
# R が UTF-8 で動いていないと（Windows の R 4.1 以前など），日本語の変数名は読めないので飛ばします。
if (isTRUE(l10n_info()[["UTF-8"]])) {
  eval(parse(text = '
d <- data.frame(勉強時間 = c(2, 5, 8),
                学習法 = factor(c("対面", "オンライン", "対面"),
                              levels = c("対面", "オンライン")))
print(model.matrix(~ 勉強時間 + 学習法, data = d))
', encoding = "UTF-8"))
} else {
  cat("R が UTF-8 で動いていないので，この部分は飛ばしました（R 4.2 以降で試してください）。\n")
}
