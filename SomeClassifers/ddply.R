library(magrittr)
library(dplyr)
library(ggplot2)

num_data <- 10
X <- runif(n = num_data, min = 0, max = 2)
beta_1 <- 1
beta_2 <- 3

lambda <- exp(beta_1 + beta_2 * log(X))
Y <- rpois(n = length(lambda), lambda = lambda)

df <- data.frame(x = log(X), y = Y)
glm_result <- glm(y ~ x, data = df, family = "poisson")
df$glm <- glm_result$fitted.values

f <- ggplot(df, aes(x, y))
f + geom_point() + geom_line(aes(x, glm))
glm_result

#入力された値でpoison分布に従う乱数を発生させる
each_likelihood_function <- function(y, x, beta_1, beta_2) {
  dpois(x = y, lambda = exp(beta_1 + beta_2 * log(x)), log = TRUE)
}

#総和をとって指数をとる
likelihood_function <- function(Y, X, beta_1, beta_2) {
  each_likelihood_function(Y, X, beta_1, beta_2) %>% sum %>% exp
}

beta_1_candidates <- seq(from = 0.5, to = 1.5, by = 0.1)
beta_2_candidates <- seq(from = 2.5, to = 3.5, by = 0.1)
params_candidates <- merge(x = beta_1_candidates, y = beta_2_candidates, all = TRUE)
names(params_candidates) <- c("beta_1", "beta_2")

#ddply 操作繰り返し
likelihood_df <- ddply(params_candidates, .(beta_1, beta_2),#種類ごとに
                       function(params) {
                         data.frame(likelihood <- likelihood_function(Y, X, params$beta_1, params$beta_2))
                         }
                       )

filled.contour(
  beta_1_candidates,
  beta_2_candidates,
  likelihood_df$likelihood %>% matrix(nrow = length(beta_1_candidates)),
  key.title = title(main = "likelihood"),
  xlab = "beta_1", ylab = "beta_2"
)

