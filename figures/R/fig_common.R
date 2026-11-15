# 図を描く R スクリプトの共通設定です。
# 各スクリプトの先頭で source("fig_common.R") と読み込みます
# （figures/R/ を作業ディレクトリにして走らせます）。
#
#   out()        : PNG の出力を開く（figures/out/ に書く。無ければ作る）
#   par_ja()     : 余白と文字の大きさをそろえる
#   halo_text()  : 白いフチのついた文字（線や点の近くに置くラベル用）
#   JA_FAMILY    : 日本語のラベルに使うフォント
#   students24() : 本書で何度も使う24人のデータを読み込む

# --- このファイルの場所と出力先 ----------------------------------------------
FIG_R_DIR <- tryCatch(dirname(normalizePath(sys.frame(1)$ofile)),
                      error = function(e) getwd())
OUT_DIR <- file.path(FIG_R_DIR, "..", "out")
dir.create(OUT_DIR, showWarnings = FALSE, recursive = TRUE)

# --- 日本語のフォント ----------------------------------------------------------
# 環境変数 FIG_FONT にフォント名を入れると，それを使います
# （例: FIG_FONT="Noto Sans CJK JP" Rscript fig_ch01.R）。
# 指定が無いとき，macOS ではヒラギノを使い，それ以外では R の既定に任せます。
# 日本語のフォントが無い環境でも止まりませんが，ラベルの字が欠けることがあります。
JA_FAMILY <- local({
  f <- Sys.getenv("FIG_FONT", "")
  if (nzchar(f)) f
  else if (Sys.info()[["sysname"]] == "Darwin") "Hiragino Sans"
  else ""
})

# --- 出力 ----------------------------------------------------------------------
# 図はグレースケールで作ります（本は1色刷り）。
dev_type <- function() {
  if (capabilities("aqua")) "quartz"
  else if (capabilities("cairo")) "cairo"
  else "Xlib"
}

out <- function(name, w = 1500, h = 950, res = 200) {
  png(file.path(OUT_DIR, name), width = w, height = h, res = res,
      type = dev_type(), bg = "white")
}

# --- 余白と文字の大きさ --------------------------------------------------------
par_ja <- function(mfrow = c(1, 1), cex.lab = 1.2, cex.axis = 1.15,
                   cex.main = 1.2, mar = c(4, 4, 2.5, 1)) {
  par(mfrow = mfrow, family = JA_FAMILY, mar = mar, mgp = c(2.6, .8, 0),
      cex.lab = cex.lab, cex.axis = cex.axis, cex.main = cex.main)
}

# --- 白いフチのついた文字 ------------------------------------------------------
# まわりの8方向に白で描いてから，上に本体を重ねます。
halo_text <- function(x, y, labels, col = "black", halo = "white",
                      lwd = 6, ...) {
  d <- lwd / 400
  for (dx in c(-d, 0, d)) for (dy in c(-d, 0, d)) {
    if (dx == 0 && dy == 0) next
    text(x + dx * diff(par("usr")[1:2]), y + dy * diff(par("usr")[3:4]),
         labels, col = halo, ...)
  }
  text(x, y, labels, col = col, ...)
}

# --- 24人のデータ --------------------------------------------------------------
# リポジトリの R/data_students24.R を読み込み，grade・method・studyTime などを
# 呼び出した側に作ります。
students24 <- function() {
  source(file.path(FIG_R_DIR, "..", "..", "R", "data_students24.R"),
         local = parent.frame())
}
