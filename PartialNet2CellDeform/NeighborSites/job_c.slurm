#!/bin/bash
#SBATCH --job-name=L50
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --time=24:00:00
#SBATCH --mem-per-cpu=4G
#SBATCH --mail-user=yz47@rice.edu

module load MATLAB/2015a

matlab -nodisplay -r main
