# 第9章「あなたの出力を読む」
# 30人の架空データ students で，summary() の出力を部品ごとに読みます。
# 最後のベイズファクターには BayesFactor パッケージが要ります（install.packages("BayesFactor")）。

# --- ここから students を作るところまでは，本文には載せていない「データの準備」です ---
# 30人の架空データ students を作ります（乱数の種を固定しているので，毎回同じ値になります）。
set.seed(123)
n <- 30
studyTime <- round(runif(n, 1, 10), 1)                                # 勉強時間：1〜10時間
method <- factor(rep(c("lecture", "online", "textbook"), each = 10))  # 学習法：10人ずつ
# 成績 ＝ 60 ＋ 4×勉強時間 ＋ 学習法ごとの上乗せ（対面 0，オンライン +5，教科書 −3）＋ 誤差
grade <- 60 + 4 * studyTime +
  c(lecture = 0, online = 5, textbook = -3)[method] + rnorm(n, 0, 6)
grade <- round(grade, 1)
students <- data.frame(grade, studyTime, method)

cat("=== 単回帰の summary ===\n")
model <- lm(grade ~ studyTime, data = students)
print(summary(model))

cat("=== 学習法（3水準の factor）を足す ===\n")
model2 <- lm(grade ~ studyTime + method, data = students)
print(summary(model2))

cat("=== 基準のカテゴリを online に変える ===\n")
students$method <- relevel(students$method, ref = "online")
print(coef(lm(grade ~ studyTime + method, data = students)))

cat("=== 欠損のある行は黙って除かれる ===\n")
students_na <- students
students_na$grade[c(3, 17)] <- NA       # 成績を2人ぶん欠損にする
model_na <- lm(grade ~ studyTime, data = students_na)
print(summary(model_na))
# 出力の「(2 個の観測値が欠損のため削除されました)」の行は，R の表示が英語のときは
# "(2 observations deleted due to missingness)" と出ます。数値は同じです。

cat("=== predict()：信頼区間と予測区間 ===\n")
new <- data.frame(studyTime = 5)
print(predict(model, newdata = new, interval = "confidence"))
print(predict(model, newdata = new, interval = "prediction"))

cat("=== 診断プロット（4枚）===\n")
# Rscript で走らせたときは，図は Rplots.pdf というファイルに出ます。
op <- par(mfrow = c(2, 2))   # 画面を 2×2 に分ける
plot(model)
par(op)                      # 分け方を元に戻す

cat("=== 曲がりを許したモデル（勉強時間の二乗を足す）===\n")
print(summary(lm(grade ~ studyTime + I(studyTime^2), data = students))$coefficients)

cat("=== ベイズファクター（片側）：第1・2章の24人で「オンラインのほうが高い」を調べる ===\n")
if (requireNamespace("BayesFactor", quietly = TRUE)) {
  library(BayesFactor)
  # ここから先の grade・method は，第1・2章の24人のデータです
  # （上で作った30人の grade・method を上書きします。30人のほうは students に残っています）。
  source("data_students24.R")
  print(t.test(grade ~ method, var.equal = TRUE, alternative = "less")$p.value)  # 片側の p 値
  # 差を「オンライン − 対面」の向きにする
  scores <- data.frame(grade, method = relevel(method, ref = "online"))
  bf <- ttestBF(formula = grade ~ method, data = scores, nullInterval = c(0, Inf))
  print(bf)
  print(bf[1] / bf[2])
} else {
  cat("BayesFactor パッケージが入っていないので，この部分は飛ばしました。\n")
}
