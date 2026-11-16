# 付録「R コードの文法」（NHANES を使う例）
# 付録の例のうち，NHANES（米国の健康・栄養調査）のデータを使うものを，
# 付録に出てくる順に集めました。前の例で作った表を後の例が使うので，
# 上から順に走らせてください。
# Rscript で走らせたときは，図は Rplots.pdf というファイルに出ます。

if (!requireNamespace("NHANES", quietly = TRUE)) {
  stop('NHANES パッケージが要ります。install.packages("NHANES") で入れてから走らせてください。')
}
library(NHANES)                     # 使うたびに毎回
cat("NHANES パッケージの版：", as.character(packageVersion("NHANES")), "\n")

cat("\n=== 位置引数と名前付き引数：年齢のヒストグラム ===\n")
hist(NHANES$Age, breaks = seq(-0.5, 80.5, by = 1),
     col = "lightblue")

cat("\n=== データフレーム：行が人，列が項目 ===\n")
print(nrow(NHANES))                 # 約1万行
print(length(unique(NHANES$ID)))    # 重複を除くと約6,800人

cat("\n=== $ で列を1本取り出す ===\n")
print(head(NHANES$Age))             # 表から Age（年齢）の列だけ取り出す

cat("\n=== 行を絞り込む：論理フィルタと subset() ===\n")
# 「年齢18以上」の行だけを残す。コンマの右が空 = 全列を残す
adults <- NHANES[NHANES$Age >= 18, ]
print(nrow(adults))
adults_subset <- subset(NHANES, Age >= 18)
print(nrow(adults_subset))
print(identical(adults, adults_subset))   # ここでは上と同じ結果（TRUE）

cat("\n=== !duplicated() で重複を消す ===\n")
# duplicated() は「すでに出てきた行」を TRUE にする
# ! で否定して「重複でない行」だけを残す
NHANES <- NHANES[!duplicated(NHANES$ID), ]
print(nrow(NHANES))                 # 約6,800人

cat("\n=== 条件を & でつなげる：重複除去 かつ 成人 ===\n")
nhanes_adult <-
  NHANES[!duplicated(NHANES$ID) & NHANES$Age >= 18, ]
print(nrow(nhanes_adult))
print(min(nhanes_adult$Age))        # 18以上だけが残っている
print(anyDuplicated(nhanes_adult$ID))   # 0（重複なし）

cat("\n=== 群ごとの箱ひげ図（チルダ ~）===\n")
boxplot(Height ~ Gender, data = nhanes_adult)   # Height を Gender で分ける

cat("\n=== sample()：標本を抜き出す ===\n")
set.seed(12345)                     # 乱数の出発点を固定する
idx <- sample(nrow(nhanes_adult), 250)   # 行番号250個を重複なしで
print(length(idx))                  # 250
print(anyDuplicated(idx))           # 0（重複なし）
# samp は手元の標本（数値のベクトル）。ここでは抜き出した人の身長（欠損を除く）
samp <- nhanes_adult$Height[idx]
samp <- samp[!is.na(samp)]
# 同じ個数を「復元抽出」→ ブートストラップ
bs <- sample(samp, size = length(samp), replace = TRUE)
print(length(bs) == length(samp))   # TRUE
print(anyDuplicated(bs) > 0)        # TRUE（復元抽出なので同じ値が何度も出る）

cat("\n=== replicate() と for ループ：同じことをしている ===\n")
# 方法A：replicate(回数, { やること })
set.seed(12345)
boot_means_a <- replicate(10000, {
  bs <- sample(samp, length(samp), replace = TRUE)  # 再標本
  mean(bs)                          # その平均を返す
})
# 方法B：for ループ
set.seed(12345)
boot_means <- numeric(10000)        # 長さ10000の空き箱を用意
for (i in 1:10000) {                # i を 1〜10000 まで動かす
  bs <- sample(samp, length(samp), replace = TRUE)
  boot_means[i] <- mean(bs)         # その平均を i 番目の箱に入れる
}
print(length(boot_means_a))         # 10000個の平均が入る
print(identical(boot_means_a, boot_means))   # TRUE（同じ種なら同じ結果）

cat("\n=== == で絞り込む，欠損は na.rm ===\n")
print(table(NHANES$Gender == "female"))
print(mean(nhanes_adult$Height))                # NA（欠損があると計算できない）
print(mean(nhanes_adult$Height, na.rm = TRUE))  # 欠損を除いて計算
