# 付録「R コードの文法」：本文でコメントに結果を書いた行を，実際に走らせて確かめます。

print(rep(0, 5))
print(seq(1.5, 12.5, by = 1))
scores <- c(60, 75, 80, 95)
print(scores[1]); print(scores[c(1, 3)]); print(scores[scores >= 80])
print(qnorm(0.975))
set.seed(12345); print(rnorm(3)); set.seed(12345); print(rnorm(3))
x <- 5; print(x == 5)
print(mean(c(1, 2, NA))); print(mean(c(1, 2, NA), na.rm = TRUE))
