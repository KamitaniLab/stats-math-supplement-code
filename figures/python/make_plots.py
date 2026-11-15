# -*- coding: utf-8 -*-
"""『統計のための数理サプリメント』の図のうち，matplotlib で描く5枚を作ります。

    fig-interaction      交互作用プロット（第2章 モデルの着せ替え）
    heavy-tails          正規・t・コーシーの確率密度（第4章 分布という語彙）
    fig-errorbar-ladder  同じ24人のデータに描いた5種類の棒（第5章 推測のしくみ）
    bayes-update         コイン投げのベイズ更新（第6章 ベイズ統計の数理）
    roc-auc              点数の分布としきい値，ROC曲線と AUC（第7章 機械学習の初歩）

走らせ方:  python3 make_plots.py
出力:      このファイルから見て ../out/ に，各図の PNG と PDF（無ければ作ります）
必要なもの: numpy, scipy, matplotlib（requirements.txt）
"""

from pathlib import Path

import matplotlib

matplotlib.use("Agg")            # 画面の無い環境でも走るようにする

import matplotlib.patheffects as pe
import matplotlib.pyplot as plt
import numpy as np
from matplotlib import font_manager
from scipy import stats

OUT = Path(__file__).resolve().parent.parent / "out"

# 色はグレースケールだけを使う（本は1色刷り）
INK = "#1a1a1a"    # 墨（主線・軸ラベル）
DARK = "#555555"   # 濃いグレー（第2の線）
MID = "#999999"    # 中くらいのグレー（第3の線）
GRAY = "#888888"   # 補助の文字
LIGHT = "#bbbbbb"  # 罫線

# 曲線の近くに置くラベルに付ける白いフチ（線がラベルを貫くのを防ぐ）
HALO = [pe.withStroke(linewidth=3.6, foreground="white")]

# 日本語のフォント：入っているものを順に探し，無ければ matplotlib の既定を使う
# （その場合も止まらないが，日本語のラベルは欠ける）
_JA_CANDIDATES = [
    "Hiragino Sans", "Hiragino Maru Gothic Pro", "Yu Gothic", "Meiryo",
    "Noto Sans CJK JP", "Noto Sans JP", "IPAexGothic", "IPAGothic", "TakaoGothic",
]
_installed = {f.name for f in font_manager.fontManager.ttflist}
_ja_fonts = [name for name in _JA_CANDIDATES if name in _installed]
if not _ja_fonts:
    print("注意: 日本語のフォントが見つかりません。日本語のラベルは正しく表示されません。")

matplotlib.rcParams.update({
    "font.family": _ja_fonts + ["sans-serif"],
    "pdf.fonttype": 42,              # PDF に日本語のフォントを埋め込める形式
    "axes.edgecolor": INK,
    "axes.linewidth": 0.8,
    "xtick.color": INK,
    "ytick.color": INK,
    "axes.labelcolor": INK,
    "font.size": 11,
    "mathtext.fontset": "stix",
})


def save(fig, name, **kwargs):
    """図を ../out/ に PNG と PDF で保存する。"""
    OUT.mkdir(parents=True, exist_ok=True)
    fig.savefig(OUT / f"{name}.png", dpi=300, **kwargs)
    try:
        fig.savefig(OUT / f"{name}.pdf", **kwargs)
    except Exception as err:     # フォントによっては PDF に埋め込めないことがある
        print(f"注意: {name}.pdf は作れませんでした（{type(err).__name__}）。PNG はできています。")
    plt.close(fig)


def bayes_update():
    """コイン投げのベイズ更新：一様な事前分布 Beta(1,1) から，
    10回中7回表というデータで事後分布 Beta(8,4) へ。"""
    th = np.linspace(0, 1, 400)
    prior = stats.beta.pdf(th, 1, 1)
    post = stats.beta.pdf(th, 8, 4)

    with matplotlib.rc_context({"font.size": 12}):
        fig, ax = plt.subplots(figsize=(5.44, 3.06))
        ax.plot(th, prior, color=GRAY, lw=1.6, ls="--")
        ax.plot(th, post, color=INK, lw=2.2)

        # 95% 信用区間 [0.390, 0.891] を塗り，ラベルはその中に置く
        lo, hi = stats.beta.ppf([0.025, 0.975], 8, 4)
        mask = (th >= lo) & (th <= hi)
        ax.fill_between(th[mask], post[mask], color="#bbbbbb", alpha=0.35)
        ax.annotate("95%信用区間\n[0.390, 0.891]", xy=(0.43, 0.06), xycoords="data",
                    fontsize=10.5, color="#333333", ha="left", va="bottom")

        # 曲線に直接ラベルを付ける（凡例は使わない）
        ax.text(0.06, 1.12, "事前 Beta(1,1)（一様）", color=GRAY, fontsize=11.5)
        ax.text(0.435, 2.95, "事後 Beta(8,4)", color=INK, fontsize=12.5,
                fontweight="bold", ha="right")

        # 事前 → 事後 の更新を，上向きの矢印で示す
        ax.annotate("", xy=(0.235, 2.80), xytext=(0.16, 1.36),
                    arrowprops=dict(arrowstyle="->", color=INK, lw=1.1))
        ax.text(0.245, 1.62, "データ\n（10回中7回表）\nで更新", fontsize=10.5, color=INK,
                ha="left", va="bottom")

        # 事後分布の平均と最頻値
        for v in (8 / 12, 7 / 10):
            ax.axvline(v, ymax=stats.beta.pdf(v, 8, 4) / 3.4 * 0.94,
                       color="#555555", lw=0.9, ls=":")
        ax.annotate("平均 0.667", xy=(8 / 12, 1.10), fontsize=10.5,
                    color="#555555", rotation=90, ha="right", va="bottom",
                    xytext=(8 / 12 - 0.012, 1.10))
        ax.annotate("最頻値 0.700", xy=(7 / 10, 1.10), fontsize=10.5,
                    color="#555555", rotation=90, ha="left", va="bottom",
                    xytext=(7 / 10 + 0.012, 1.10))

        ax.set_xlim(0, 1)
        ax.set_ylim(0, 3.4)
        ax.set_xlabel("表の確率 $\\theta$")
        ax.set_ylabel("確率密度")
        ax.spines[["top", "right"]].set_visible(False)
        fig.tight_layout()
        save(fig, "bayes-update")


def heavy_tails():
    """標準正規・t（自由度3）・標準コーシーの形と，裾の重さ。
    左はふつうの軸，右は縦軸を対数にしたもの。"""
    x = np.linspace(-6, 6, 600)

    with matplotlib.rc_context({"font.size": 16}):
        fig, axes = plt.subplots(1, 2, figsize=(6.46, 2.72))

        for ax, log in zip(axes, [False, True]):
            n = stats.norm.pdf(x)
            t3 = stats.t.pdf(x, df=3)
            ca = stats.cauchy.pdf(x)
            ax.plot(x, n, color=INK, lw=2.0)
            ax.plot(x, t3, color=DARK, lw=1.7, ls=(0, (5, 3)))
            ax.plot(x, ca, color=MID, lw=1.7, ls=(0, (1, 1.6)))
            ax.spines[["top", "right"]].set_visible(False)
            if log:
                ax.set_yscale("log")
                ax.set_ylim(1e-8, 1)
                ax.set_title("対数軸だと裾の差は歴然", fontsize=14, loc="left", pad=16)
                ax.text(4.6, stats.cauchy.pdf(4.6) * 13, "コーシー",
                        color=MID, fontsize=15, ha="center", path_effects=HALO)
                # t のラベルは正規と t の間に置き，右は軸の外の余白へ伸ばす
                # （レイアウトの計算からは外して，パネルが縮まないようにする）
                tl = ax.text(4.3, 2e-4, "$t\\ (\\nu=3)$",
                             color=DARK, fontsize=15, ha="left", path_effects=HALO)
                tl.set_in_layout(False)
                ax.text(0, 2e-5, "正規 $N(0,1)$", color=INK, fontsize=15,
                        ha="center", path_effects=HALO)
            else:
                ax.set_ylim(0, 0.50)
                ax.set_title("中心付近はどれも釣鐘型", fontsize=14, loc="left", pad=8)
                ax.text(0, 0.435, "正規 $N(0,1)$", color=INK, fontsize=15,
                        ha="center", path_effects=HALO)
                ax.text(1.95, 0.285, "$t\\ (\\nu=3)$", color=DARK, fontsize=15,
                        path_effects=HALO)
                ax.text(3.05, 0.095, "コーシー\n$(=t,\\ \\nu=1)$", color=MID,
                        fontsize=15, path_effects=HALO)
            ax.set_xlabel("$x$")
            ax.set_xlim(-6, 6)

        axes[0].set_ylabel("確率密度")
        fig.tight_layout()
        save(fig, "heavy-tails")


def errorbar_ladder():
    """同じ24人のデータに，標本平均 ± SD，± SE，80・95・99% 信頼区間を並べて描く。
    棒の長さの違いは，意味の違いである。"""
    rng = np.random.default_rng(20260828)     # 点を上下に散らす乱数の種（毎回同じ図になる）
    # 第1章の24人の成績。リポジトリの R/data_students24.R が作る grade と同じ値
    x = np.array([58.2, 82.7, 59.9, 58.4, 64.7, 59.4, 63.0, 59.3,
                  57.6, 65.7, 59.5, 64.5, 60.7, 64.0, 69.6, 68.3,
                  80.5, 85.5, 92.7, 76.0, 59.4, 82.4, 72.2, 55.2])
    n = x.size
    m = x.mean()
    sd = x.std(ddof=1)
    se = sd / np.sqrt(n)
    t80, t95, t99 = (stats.t.ppf(1 - a / 2, df=n - 1) for a in (0.20, 0.05, 0.01))

    # （ラベル，棒の半分の長さ，色，添え書き）
    rows = [
        ("標本平均 ± SD",          sd,        INK,   "個々のデータのばらつき"),
        ("標本平均 ± SE",          se,        INK,   "平均という要約の頼りなさ"),
        ("80%信頼区間",           t80 * se,  DARK,  ""),
        ("95%信頼区間",           t95 * se,  DARK,  "ふつう報告するのはこれ"),
        ("99%信頼区間",           t99 * se,  MID,   ""),
    ]

    with matplotlib.rc_context({"font.size": 13}):
        fig, ax = plt.subplots(figsize=(5.6, 3.5))

        # いちばん上：個々の点（上下に少し散らして重なりを避ける）
        y_dots = 0.0
        jitter = rng.uniform(-0.22, 0.22, n)
        ax.plot(x, np.full(n, y_dots) + jitter, "o", ms=4.2, mfc="none",
                mec=DARK, mew=0.9, zorder=3)
        ax.text(m, y_dots + 0.46, "データ（$n$ = 24）", ha="center", va="bottom",
                fontsize=12.5, color=GRAY)

        # その下：平均と，幅の違う5本の棒。ラベルは左の同じ位置にそろえる
        gap = 0.27 * sd
        label_x = m - max(h for _, h, _, _ in rows) - gap
        for i, (label, half, color, note) in enumerate(rows, start=1):
            y = -i
            ax.plot([m - half, m + half], [y, y], "-", color=color, lw=2.0, zorder=2,
                    solid_capstyle="butt")
            for xx in (m - half, m + half):      # 棒の両端の短い縦線
                ax.plot([xx, xx], [y - 0.16, y + 0.16], "-", color=color, lw=2.0, zorder=2)
            ax.plot([m], [y], "o", ms=5.2, color=INK, zorder=4)
            ax.text(label_x, y, label, ha="right", va="center",
                    fontsize=13, color=INK)
            if note:
                ax.text(m + half + 0.17 * sd, y, note, ha="left", va="center",
                        fontsize=11.5, color=GRAY)

        # 平均を貫く縦の補助線
        ax.axvline(m, color=LIGHT, lw=0.8, zorder=1)

        ax.set_ylim(-len(rows) - 0.9, 1.15)
        ax.set_yticks([])
        ax.set_xlabel("成績（点）")
        for side in ("left", "right", "top"):
            ax.spines[side].set_visible(False)
        ax.tick_params(axis="y", length=0)
        fig.tight_layout()
        save(fig, "fig-errorbar-ladder")


def interaction_plot():
    """交互作用プロット（薬 × 年齢層，2水準 × 2水準の架空データ）。
    左：交互作用なし（2本は平行。足し算のモデルで書ける）
    右：交互作用あり（2本は交差。薬の効き目が年齢層で裏返る）
    右の値は，若年層 6→16・高齢層 16→6 mmHg。左は対照として，高齢層を一律 +5 したもの。"""
    drugs = ["A", "B"]
    xs = np.arange(2)

    # （題，若年層の値，高齢層の値，下に添える説明）
    panels = [
        ("交互作用なし ── 2本は平行",
         [6, 16], [11, 21],
         "年齢層による差は薬によらず一定\n足し算のモデルで書ける"),
        ("交互作用あり ── 2本は交差",
         [6, 16], [16, 6],
         "薬の効き目が年齢層で裏返る\n足し算では書けない"),
    ]

    with matplotlib.rc_context({"font.size": 12}):
        fig, axes = plt.subplots(1, 2, figsize=(5.9, 3.2), sharey=True)

        for ax, (title, young, old, note) in zip(axes, panels):
            ax.plot(xs, young, "-o", color=INK, lw=2.0, ms=6.0,
                    mfc="white", mec=INK, mew=1.6, zorder=3)
            ax.plot(xs, old, "--s", color=DARK, lw=2.0, ms=5.6,
                    mfc=DARK, mec=DARK, zorder=3)

            # 線に直接ラベルを付ける。右端で上にある方を上側に，下にある方を下側に置く
            upper, lower = (("若年層", young[-1], INK), ("高齢層", old[-1], DARK)) \
                if young[-1] > old[-1] else \
                (("高齢層", old[-1], DARK), ("若年層", young[-1], INK))
            for (name, yv, col), dy, va in ((upper, 5, "bottom"), (lower, -5, "top")):
                ax.annotate(name, xy=(xs[-1], yv), xytext=(7, dy),
                            textcoords="offset points", fontsize=12.5, color=col,
                            ha="left", va=va)

            ax.set_title(title, fontsize=12, color=INK, pad=9)
            ax.set_xticks(xs)
            ax.set_xticklabels([f"薬{d}" for d in drugs], fontsize=12.5)
            ax.set_xlim(-0.32, 1.72)
            ax.set_xlabel(note, fontsize=10, color=GRAY, labelpad=8)
            ax.spines[["top", "right"]].set_visible(False)
            ax.grid(axis="y", color=LIGHT, lw=0.6, ls=":", zorder=0)
            ax.set_axisbelow(True)

        axes[0].set_ylim(2, 25)
        axes[0].set_yticks([5, 10, 15, 20, 25])
        axes[0].set_ylabel("血圧の下がり幅（mmHg）", fontsize=12.5)

        fig.tight_layout()
        save(fig, "fig-interaction")


def roc_auc():
    """点数の分布としきい値（左）と，ROC曲線・AUC（右）。
    病気でない人の点数は N(0,1)，病気の人の点数は N(2,1)。AUC = Φ(2/√2) ≈ 0.92。
    しきい値 A・B・C は，右の曲線の上の3点に対応する。左の塗りは B のしきい値のもの。"""
    d = 2.0
    th = {"A": 2.3, "B": 1.3, "C": 0.2}
    auc = stats.norm.cdf(d / np.sqrt(2))
    x = np.linspace(-3.5, 5.5, 900)
    with matplotlib.rc_context({"font.size": 12.5, "hatch.color": "#333333", "hatch.linewidth": 0.8}):
        fig, (a1, a2) = plt.subplots(1, 2, figsize=(6.46, 3.55),
                                     gridspec_kw={"width_ratios": [1.25, 1]})
        # 左：2つの分布としきい値
        n0, n1 = stats.norm.pdf(x), stats.norm.pdf(x, loc=d)
        r = x >= th["B"]
        a1.fill_between(x[r], n1[r], color="#d0d0d0", lw=0, label="感度")
        a1.fill_between(x[r], n0[r], color="#4a4a4a", lw=0, label="偽陽性率")
        a1.plot(x, n0, color=DARK, lw=1.7, ls=(0, (5, 3)))
        a1.plot(x, n1, color=INK, lw=2.0)
        for k, t in th.items():
            a1.plot([t, t], [0, 0.50], color=INK if k == "B" else GRAY,
                    lw=1.4 if k == "B" else 1.0, ls="-" if k == "B" else (0, (3, 2)))
            a1.text(t, 0.515, k, ha="center", va="bottom", fontsize=12.5,
                    fontweight="bold" if k == "B" else "normal")
        a1.annotate("", xy=(th["C"], 0.625), xytext=(th["A"], 0.625), annotation_clip=False,
                    arrowprops=dict(arrowstyle="-|>", color=INK, lw=1.1, mutation_scale=12))
        a1.text((th["A"] + th["C"]) / 2, 0.645, "しきい値を下げる", ha="center", va="bottom",
                fontsize=12.5)
        a1.text(-3.4, 0.43, "病気でない人", ha="left", color=DARK, fontsize=11.5, path_effects=HALO)
        a1.text(3.15, 0.36, "病気の人", ha="left", color=INK, fontsize=11.5, path_effects=HALO)
        a1.set_ylim(0, 0.58)
        a1.set_xlim(-3.5, 5.5)
        a1.set_yticks([])
        a1.set_xticks([])
        a1.spines[["top", "right", "left"]].set_visible(False)
        a1.set_xlabel("陽性らしさの点数", labelpad=6)
        a1.legend(loc="upper center", bbox_to_anchor=(0.5, -0.17), ncol=2, frameon=False,
                  fontsize=12.5, handlelength=1.4, columnspacing=1.2,
                  title="（B より右を陽性と判定したとき）", title_fontsize=11.5)
        # 右：ROC曲線
        t = np.linspace(-6, 8, 400)
        fx, ty = stats.norm.sf(t), stats.norm.sf(t - d)
        a2.fill_between(fx, ty, color="#e4e4e4", lw=0)
        a2.plot(fx, ty, color=INK, lw=2.0)
        a2.plot([0, 1], [0, 1], color=MID, lw=1.3, ls=(0, (1, 1.6)))
        for k, tt in th.items():
            px, py = stats.norm.sf(tt), stats.norm.sf(tt - d)
            a2.plot([px], [py], "o", ms=7 if k == "B" else 6, mfc=INK if k == "B" else "white",
                    mec=INK, mew=1.5, zorder=5)
            a2.text(px + 0.045, py - 0.035, k, ha="left", va="top", fontsize=12.5,
                    fontweight="bold" if k == "B" else "normal", path_effects=HALO, zorder=6)
        a2.annotate("でたらめな判定\n（AUC = 0.5）", xy=(0.50, 0.50), xytext=(0.56, 0.46),
                    fontsize=11.5, color=DARK, ha="left", va="top", path_effects=HALO,
                    arrowprops=dict(arrowstyle="-", color=GRAY, lw=0.9, shrinkA=0, shrinkB=2))
        a2.text(0.96, 0.06, f"AUC = {auc:.2f}", ha="right", va="bottom", fontsize=13,
                path_effects=HALO)
        a2.set_xlim(0, 1)
        a2.set_ylim(0, 1)
        a2.set_xticks([0, 0.5, 1])
        a2.set_yticks([0, 0.5, 1])
        a2.set_xticklabels(["0", "0.5", "1"])
        a2.set_yticklabels(["0", "0.5", "1"])
        a2.set_aspect("equal")
        a2.set_xlabel("偽陽性率")
        a2.set_ylabel("感度")
        a2.spines[["top", "right"]].set_visible(False)
        fig.tight_layout(w_pad=2.0)
        save(fig, "roc-auc", bbox_inches="tight", pad_inches=0.04)
    # しきい値ごとの偽陽性率と感度，AUC の値
    for k, tt in th.items():
        print(f"roc-auc {k}: しきい値={tt} 偽陽性率={stats.norm.sf(tt):.3f} 感度={stats.norm.sf(tt - d):.3f}")
    print(f"AUC={auc:.3f}")


if __name__ == "__main__":
    interaction_plot()
    heavy_tails()
    errorbar_ladder()
    bayes_update()
    roc_auc()
    print("図を5枚（PNG と PDF）作りました:", OUT)
