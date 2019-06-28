#!/bin/bash

#PBS -l walltime=1:00:00
#PBS -l nodes=10:ppn=10
#PBS -l mem=20g,vmem=20g

module purge
module load R/3.5.3_rmpi

mpirun -np 1 Rscript ~/GitProjects/SK-HPC-Example/bootstrap_example/bootstrap_example.R
