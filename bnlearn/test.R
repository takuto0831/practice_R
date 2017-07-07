install.packages("Rgaphviz")
library(bnlearn)
library(dplyr)


data("learning.test")
str(learning.test)
res <- hc(learning.test)
plot(res)
data("iris")

# bayesian network
res1 <- hc(iris)
plot(res1)
res2 <- gs(iris)
plot(res2)

fit <- bn.fit(res1,iris)
a <- impute(fit,iris)
length(iris)
predict(object = fit,node = "Species", data = iris)
iris[,5]

# factor変換
for(i in 1:length(iris)){
  iris1[,i] <- iris[,i] %>% as.factor()
}
str(iris1)

# naive bayes
bn1 <- naive.bayes(iris1,"Species")
pred <- predict(bn1,iris1)
table(pred, iris1$Species)

# TAN
tan <- tree.bayes(iris1,"Species")
fit.tan <- bn.fit(tan,iris1, method = "bayes")
pred <- predict(fit.tan, iris1)
table(pred, iris1$Species)
