# 本書で何度も使う「24人の成績データ」を作ります（第1章・第2章・第9章）。
# 乱数の種（set.seed）を固定しているので，誰が走らせても同じ値になります。
#   grade     : 成績（点）
#   method    : 学習法（lecture = 対面，online = オンライン）
#   studyTime : 1週間の勉強時間（時間）
# 使い方: 他のスクリプトの冒頭で source("data_students24.R") と読み込みます。

set.seed(20260828)
n <- 12
lecture <- round(rnorm(n, mean = 68, sd = 8), 1)
online  <- round(rnorm(n, mean = 75, sd = 8), 1)
grade   <- c(lecture, online)
method  <- factor(rep(c("lecture", "online"), each = n))

set.seed(42)
studyTime <- round(pmax(0.5, 5.5 + 0.28 * (grade - mean(grade)) + rnorm(24, 0, 1.8)), 1)
