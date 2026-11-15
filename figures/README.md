# 本の図を描くコード

『統計のための数理サプリメント』に載っている図のうち，R と Python（matplotlib）で描いているものの生成コードです。走らせると，本と同じデータ・同じ式から同じ絵が描けます。

ただし，**フォントや細部は環境で変わります**。本の図は macOS のヒラギノで組んであるので，ほかの OS やフォントでは字の形・幅・ラベルの位置が少し違って見えます。データ，曲線，軸の範囲は同じです。

手で描いた概念図（本書の見取り図，分布の地図，因果グラフなど）は，ここには入っていません。

## 走らせ方

### R の図

R（4.x）だけで走ります（追加のパッケージは要りません）。`figures/R/` を作業ディレクトリにして走らせます。

```sh
cd figures/R
Rscript fig_ch01.R
Rscript fig_anscombe.R
Rscript fig_ch03_ch04.R
Rscript fig_ch05.R
Rscript fig_ch09.R
```

R の中からなら，`setwd("figures/R")` のあと `source("fig_ch01.R")` です。

日本語のラベルに使うフォントは，macOS ではヒラギノ，それ以外では R の既定です。別のフォントを使うときは，環境変数 `FIG_FONT` に名前を入れます。

```sh
FIG_FONT="Noto Sans CJK JP" Rscript fig_ch01.R
```

日本語のフォントが無い環境でも止まりませんが，日本語のラベルの字が欠けることがあります。

### Python の図

Python 3 と numpy・scipy・matplotlib が要ります。

```sh
cd figures/python
pip install -r requirements.txt
python3 make_plots.py
```

日本語のフォントは，入っているもの（ヒラギノ，游ゴシック，メイリオ，Noto Sans CJK JP，IPAex ゴシックなど）を自動で探します。見つからないときは注意を表示して，matplotlib の既定のフォントで描きます。

## 出力先

図は `figures/out/` にできます（無ければ作ります）。R の図は PNG，Python の図は PNG と PDF です。

`out/` は生成物なので，git には入れません（`figures/.gitignore` に `out/` と書いてあります）。

## どの図がどのファイルから出るか

### R（`figures/R/`）

| ファイル | 章 | 図 | 出力 |
|---|---|---|---|
| `fig_ch01.R` | 第1章 モデルの育て方 | 24人の成績のヒストグラム | `fig-ch1-hist.png` |
| | | 切片を持たないモデル | `fig-ch1-noint.png` |
| | | 切片と傾きを持つ直線のモデル | `fig-ch1-line.png` |
| | | RMSE の階段 | `fig-ch1-ladder.png` |
| `fig_anscombe.R` | 第2章 モデルの着せ替え | アンスコムの四重奏 | `fig-desc-anscombe.png` |
| `fig_ch03_ch04.R` | 第3章 公式の導き方 | 最小の点では傾きが0になる | `fig-min-slope.png` |
| | | 無相関だが独立でない例 | `fig-uncorrelated-dependent.png` |
| | 第4章 分布という語彙 | 積分は面積であり，面積は乱数で近似できる | `fig-int-mc.png` |
| | | 2次元正規分布 | `fig-mvnorm.png` |
| `fig_ch05.R` | 第5章 推測のしくみ | α と β ── 検定に出てくる2つの世界 | `fig-alpha-beta.png` |
| `fig_ch09.R` | 第9章 あなたの出力を読む | 信頼区間と予測区間 | `fig-ci-pi.png` |
| | | `plot(model)` が出す4枚の診断図 | `fig-lm-diag.png` |

`fig_common.R` は共通の設定（出力先，余白と文字の大きさ，フォント，白いフチのついた文字）で，各スクリプトが読み込みます。

第1章の図は，リポジトリの `R/data_students24.R` が作る24人のデータを使います。第9章の図は，`R/ch09_reading_output.R` と同じ30人のデータを，同じ乱数の種と式で作ります。

### Python（`figures/python/make_plots.py`）

| 章 | 図 | 出力 |
|---|---|---|
| 第2章 モデルの着せ替え | 交互作用プロット（2つの要因のセル平均を折れ線で結んだ図） | `fig-interaction.png`・`.pdf` |
| 第4章 分布という語彙 | 正規・t・コーシーの確率密度 | `heavy-tails.png`・`.pdf` |
| 第5章 推測のしくみ | 同じ24人のデータに並べて描いた5種類の棒（SD・SE・信頼区間） | `fig-errorbar-ladder.png`・`.pdf` |
| 第6章 ベイズ統計の数理 | ベイズ更新の通し例（コイン投げ） | `bayes-update.png`・`.pdf` |
| 第7章 機械学習の初歩 | 点数の分布としきい値，ROC曲線と AUC | `roc-auc.png`・`.pdf` |

## ライセンス

MIT License（リポジトリの `LICENSE` を見てください）。
