# 本書で何度も使う「24人の成績データ」を作ります（第1章・第2章・第4章・第9章）。
# 乱数の種（set.seed）を固定しているので，誰が走らせても同じ値になります。
#   grade     : 成績（点）
#   method    : 学習法（lecture = 対面，online = オンライン）
#   studyTime : 1週間の勉強時間（時間）
# 使い方: 他のスクリプトの中で source("data_students24.R") と読み込みます。

set.seed(20260828)        # 成績の乱数の種
n <- 12                   # 1つの学習法あたりの人数
lecture <- round(rnorm(n, mean = 68, sd = 8), 1)   # 対面の12人
online  <- round(rnorm(n, mean = 75, sd = 8), 1)   # オンラインの12人
grade   <- c(lecture, online)
method  <- factor(rep(c("lecture", "online"), each = n))

# 勉強時間：成績が高い人ほど長くなるように作る（0.5時間より短くはしない）
set.seed(42)              # 勉強時間の乱数の種
studyTime <- round(pmax(0.5, 5.5 + 0.28 * (grade - mean(grade)) + rnorm(24, 0, 1.8)), 1)
