functions{
  real pn_circle_lpdf(real theta,vector mu,matrix sigma){
    vector[2] u;
    real A;
    real B;
    real C;
    real tmp;
    real p;
    real pdf;
    u[1] = cos(theta);
    u[2] = sin(theta);
    A = u' * inverse(sigma) * u;
    B = u' * inverse(sigma) * mu;
    C = (-1/2) * (mu' * inverse(sigma) * mu);
    tmp = B/sqrt(A);
    pdf = exp(-(tmp^2)/2) / sqrt(2*pi());
    p = (1/(2*A*sqrt(determinant(sigma)))) * exp(C) * 
        (1 + tmp*normal_cdf(tmp,0,1) / pdf);
    return p;
  }
}

data{
  int N; //sample size
  real theta[N]; //data
}

parameters{
  vector[2] mu;
  real tau;
  real rho;
}

transformed parameters{
  matrix[2,2] sigma;
  sigma[1,1] = tau; sigma[1,2] = sqrt(tau)*rho;
  sigma[2,1] = sqrt(tau)*rho; sigma[2,2] = 1;
}

model{
  mu ~ multi_normal(rep_vector(0,2),diag_matrix(rep_vector(10^5,2)));
  tau ~ inv_gamma(0.01,0.01);
  rho ~ uniform(-1,1);
  for(n in 1:N){
    theta[n] ~ pn_circle(mu,sigma);
  }
}

