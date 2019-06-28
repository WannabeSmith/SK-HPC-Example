library(Rmpi)
library(snow)

n.boot <- 10000
n <- 5000
d <- 5

data <- data.frame(matrix(rnorm(n * d), ncol = d))

X <- model.matrix(~ ., data = data)
beta <- rnorm(d + 1, mean = 10, sd = 1)

y <- X %*% beta + rnorm(n, mean = 0, sd = 0.1)

data <- cbind(y, data)

n.cores <- mpi.universe.size() - 1

print(paste("MPI universe size:", n.cores))

cl <- makeMPIcluster(n.cores) # Create the openMPI cluster
clusterExport(cl, ls()) # Send all objects in R session to cl

system.time(bootstrap.list <- parLapply(cl, 1:n.boot, function(iter){
    boot.data <- data[sample.int(nrow(data), replace = TRUE),]

    m <- lm(y ~ ., data = boot.data)

    return(m$coefficients)
}))

parallel.ests <- do.call(rbind, bootstrap.list)

parallel.beta.hat <- colMeans(parallel.ests)

print("bootstrap beta hat estimate:")
print(parallel.beta.hat)

system.time(bootstrap.list <- lapply(1:n.boot, function(iter){
  boot.data <- data[sample.int(nrow(data), replace = TRUE),]

  m <- lm(y ~ ., data = boot.data)

  return(m$coefficients)
}))

sequential.ests <- do.call(rbind, bootstrap.list)
sequential.beta.hat <- colMeans(sequential.ests)

print("bootstrap beta hat estimate:")
print(sequential.beta.hat)

mpi.exit()
mpi.quit()
