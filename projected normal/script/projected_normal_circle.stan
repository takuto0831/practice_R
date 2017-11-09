functions{ //関数定義
  PnCircle_log(real theta,vector[2] mu,matrix[2,2] Sigma){
    vector[2] u;
    real A;
    real B;
    real C;
    real tmp;
    real<lower=0,upper=1> p;
    u <- (cos(theta),sin(theta));
    A <- u' * inv(Sigma) * u;
    B <- u' * inv(Sigma) * mu;
    C <- (-1/2) * (mu' inv(Sigma) * mu);
    tmp <- B/sqrt(A);
    p <- (1/(2*pi*A*sqrt(determinant(Sigma)))) * exp(C) * 
         (1 + tmp*pnorm(tmp,0,1)/dnorm(tmp,0,1));
  return(p)
  }
}