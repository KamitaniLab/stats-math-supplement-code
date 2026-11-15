# 第9章「あなたの出力を読む」
# 30人の架空データ students で，summary() の出力を部品ごとに読みます。
# 最後のベイズファクターには BayesFactor パッケージが要ります（install.packages("BayesFactor")）。

set.seed(123)
n <- 30
studyTime <- round(runif(n, 1, 10), 1)
method <- factor(rep(c("lecture", "online", "textbook"), each = 10))
grade <- 60 + 4 * studyTime +
  c(lecture = 0, online = 5, textbook = -3)[method] + rnorm(n, 0, 6)
grade <- round(grade, 1)
students <- data.frame(grade, studyTime, method)

cat("=== 単回帰の summary ===\n")
model <- lm(grade ~ studyTime, data = students)
print(summary(model))

cat("=== 学習法（3水準の factor）を足す ===\n")
print(summary(lm(grade ~ studyTime + method, data = students)))

cat("=== 基準のカテゴリを online に変える ===\n")
students$method <- relevel(students$method, ref = "online")
print(coef(lm(grade ~ studyTime + method, data = students)))

cat("=== 欠損のある行は黙って除かれる ===\n")
students_na <- students
students_na$grade[c(3, 17)] <- NA
print(summary(lm(grade ~ studyTime, data = students_na)))

cat("=== predict()：信頼区間と予測区間 ===\n")
new <- data.frame(studyTime = 5)
print(predict(model, newdata = new, interval = "confidence"))
print(predict(model, newdata = new, interval = "prediction"))

cat("=== 診断プロット（4枚）===\n")
par(mfrow = c(2, 2))
plot(model)

cat("=== ベイズファクター（片側）：第1・2章の24人で「オンラインのほうが高い」を調べる ===\n")
if (requireNamespace("BayesFactor", quietly = TRUE)) {
  source("data_students24.R")
  scores <- data.frame(grade, method = relevel(method, ref = "online"))
  bf <- BayesFactor::ttestBF(formula = grade ~ method, data = scores, nullInterval = c(0, Inf))
  print(bf)
  print(bf[1] / bf[2])
} else {
  cat("BayesFactor パッケージが入っていないので，この部分は飛ばしました。\n")
}
