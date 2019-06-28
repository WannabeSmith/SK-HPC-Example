library(Rmpi)
library(snow)

n.cores <- mpi.universe.size() - 1

print(paste("MPI universe size:", n.cores))

cl <- makeMPIcluster(n.cores) # Create the openMPI cluster
clusterExport(cl, ls()) # Send all objects in R session to cl

n.iter <- 6 

results.list <- parLapply(cl, 1:n.iter, function(iter){
  return(paste("iteration", iter, "running on", mpi.get.processor.name(short = FALSE)))
})

print(results.list)

mpi.exit()
mpi.quit()
