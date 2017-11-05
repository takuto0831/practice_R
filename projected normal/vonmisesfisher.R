library(foreach)
library(dplyr)
library(pipeR)
# bassel function
Bessel_func <- function(n,x,j){
  ( (x/2)^n * (-x^2/4)*j ) / gamma(j+1) * gamma(n+j+1)
}
ans <- foreach(j=1:50, .combine=c) %do% Bessel_func(n,x,j)

von_mises_fisher <- function(x,mu,sigma,d){
  ( sigma^(d/2 - 1) * exp(t(mu) %*% x *sigma) ) /( (2*pi)^(d/2) * besselI(sigma,d/2-1) )
}

mu0 = matrix(c(-0.251,-0.968),nrow = 2)
mu1 = matrix(c(0.399,0.917),nrow = 2)
sigma0 = 8
sigma1 = 2
d = length(mu0)
x = cbind(rnorm(1000,0,1),rnorm(1000,0,1)) %>% as.matrix()

von_mises_fisher(x[1,],mu0,sigma0,d)

# 顕著なデータを平均ベクトルとして定義すればどのベクトルに最も近いか調べられる
# 顕著なデータの選択方法？？
# つまり半教師学習ってことになるのかな