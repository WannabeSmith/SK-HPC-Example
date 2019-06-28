library(Rmpi)
library(snow)

n.boot <- 10000
n <- 5000
d <- 5

data <- matrix(rnorm(n * d), ncol = d)

X <- model.matrix(y ~ ., data = data)
beta <- rnorm(d + 1, mean = 10, sd = 1)

y <- X %*% beta + rnorm(n, mean = 0, sd = 0.1)

data <- cbind(y, data)

n.cores <- mpi.universe.size() - 1

print(paste("MPI universe size:", n.cores))

cl <- makeMPIcluster(n.cores) # Create the openMPI cluster
clusterExport(cl, ls()) # Send all objects in R session to cl

system.time(bootstrap.list <- parLapply(cl, 1:n.boot, function(iter){
    boot.data <- data[sample.int(nrow(data)),]
    
    m <- lm(y ~ ., data = boot.data)

    return(m$coefficients)
}))

bootstrap.ests <- do.call(rbind, bootstrap.list)

beta.hat <- colMeans(bootstrap.ests)

print("bootstrap beta hat estimate:")
print(beta.hat)

mpi.exit()
mpi.quit()
