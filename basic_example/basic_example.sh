#!/bin/bash

#PBS -l walltime=1:00:00
#PBS -l nodes=2:ppn=2
#PBS -l mem=3g,vmem=3g

module purge
module load R/3.5.3_rmpi

mpirun -np 1 Rscript ~/GitProjects/SK-HPC-Example/basic_example/basic_example.R
