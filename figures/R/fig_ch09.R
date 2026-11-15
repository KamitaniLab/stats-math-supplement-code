# 第9章「あなたの出力を読む」の図（2枚）
#   fig-ci-pi.png    信頼区間と予測区間
#   fig-lm-diag.png  plot(model) が出す4枚の診断図
source("fig_common.R")

# 30人の架空データ（R/ch09_reading_output.R と同じ種・同じ式）
set.seed(123)
n <- 30
studyTime <- round(runif(n, 1, 10), 1)
method <- factor(rep(c("lecture", "online", "textbook"), each = 10))
grade <- 60 + 4 * studyTime +
  c(lecture = 0, online = 5, textbook = -3)[method] +
  rnorm(n, 0, 6)
grade <- round(grade, 1)
students <- data.frame(grade, studyTime, method)
model <- lm(grade ~ studyTime, data = students)

## 信頼区間と予測区間
nd <- data.frame(studyTime = seq(1, 10, length = 100))
ci <- predict(model, nd, interval = "confidence")
pint <- predict(model, nd, interval = "prediction")
out("fig-ci-pi.png", 1400, 950)
par_ja()
plot(studyTime, grade, pch = 19, col = "grey40", xlab = "勉強時間（時間）",
     ylab = "成績（点）")
polygon(c(nd$studyTime, rev(nd$studyTime)), c(pint[,"lwr"], rev(pint[,"upr"])),
        col = "grey88", border = NA)
polygon(c(nd$studyTime, rev(nd$studyTime)), c(ci[,"lwr"], rev(ci[,"upr"])),
        col = "grey70", border = NA)
points(studyTime, grade, pch = 19, col = "grey25")
lines(nd$studyTime, ci[,"fit"], lwd = 2.2)
# 勉強時間5時間のところに2つの区間を示す
# （点線＝予測区間，太い実線＝信頼区間，白丸＝予測値 fit）
p5c <- predict(model, data.frame(studyTime = 5), interval = "confidence")
p5p <- predict(model, data.frame(studyTime = 5), interval = "prediction")
print(round(rbind(p5c, p5p), 2))
segments(5, p5p[,"lwr"], 5, p5p[,"upr"], lty = 3, lwd = 1.6, col = "grey15")
segments(4.88, p5p[,c("lwr","upr")], 5.12, p5p[,c("lwr","upr")], lwd = 1.6, col = "grey15")
segments(5, p5c[,"lwr"], 5, p5c[,"upr"], lwd = 3.2, col = "black")
segments(4.88, p5c[,c("lwr","upr")], 5.12, p5c[,c("lwr","upr")], lwd = 2.2, col = "black")
points(5, p5c[,"fit"], pch = 21, bg = "white", cex = 1.3, lwd = 1.5)
halo_text(5.25, p5p[,"lwr"] - 1.2, sprintf("勉強時間5時間（fit = %.2f）", p5c[,"fit"]),
          adj = c(0, 1), cex = 1.15)
legend("topleft", c("回帰直線", "信頼区間（平均の不確かさ）", "予測区間（個人の不確かさ）"),
       lwd = c(2.2, 12, 12), col = c("black", "grey70", "grey88"), bty = "n", cex = 1.1)
dev.off()

## 診断プロット4枚（平滑線を黒で描く）
out("fig-lm-diag.png", 1500, 1400)
par(mfrow = c(2, 2), family = JA_FAMILY, mar = c(4.6, 5.9, 3.3, 2.8),
    mgp = c(3.2, .85, 0), cex.lab = 1.65, cex.axis = 1.60)
plot(model, cex.caption = 1.65, cex.id = 1.58,
     panel = function(x, y, ...)
  panel.smooth(x, y, col.smooth = "black", lwd = 2, ...))
dev.off()
cat("第9章の図を2枚作りました:", normalizePath(OUT_DIR), "\n")
