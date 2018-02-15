# keras, tensorflow のインストール
devtools::install_github("rstudio/keras")
devtools::install_github("rstudio/tensorflow")

# python にpath を通す
Sys.setenv(TENSORFLOW_PYTHON='/Users/takuto/.pyenv/shims/python')

library('tensorflow')
hello = tf$constant('Hello TensorFlow for R.')
sess = tf$Session()
sess$run(hello)

# 教師データ読み込み
datasets <- tf$contrib$learn$datasets
mnist <- datasets$mnist$read_data_sets("MINIST-data", one_hot = TRUE)

# モデル定義する
x <- tf$placeholder(tf$float32,  shape(NULL, 784L))
W <- tf$Variable(tf$zeros(shape(784L, 10L)))
b <- tf$Variable(tf$zeros(shape(10L)))
y <- tf$nn$softmax(tf$matmul(x,W) + b) 

# モデルの学習
y_ <- tf$placeholder(tf$float32,shape(NULL,10L))
cross_entropy <- tf$reduce_mean(-tf$reduce_sum(y_ * tf$log(y),reduction_indices=1L))

# モデルの最適化
optimizer <- tf$train$GradientDescentOptimizer(0,5)
train_step <- optimizer$minimize(cross_entropy)

# run session 実行する
init <- tf$global_variables_initializer()
sess <- tf$Session()
sess$run(init)

for (i in 1:1000) {
  batches <- mnist$train$next_batch(100L)
  batch_x <- batches[[1]]
  batch_y <- batches[[2]]
  sess$run(train_step,
           feed_dict = dict(x=batch_x, y_=batch_y))
}

# 評価
correct_prediction <- tf$equal(tf$argmax(y, 1L), tf$argmax(y_, 1L))
accuracy <- tf$reduce_mean(tf$cast(correct_prediction, tf$float32))
sess$run(accuracy, feed_dict=dict(x = mnist$test$images, y_ = mnist$test$labels))
