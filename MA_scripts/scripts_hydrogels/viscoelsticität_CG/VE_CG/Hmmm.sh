#!/bin/bash

#SBATCH --mail-user=nikolasmif98@zedat.fu-berlin.de
#SBATCH --job-name=HG-Testn
#SBATCH --mail-type=all
#SBATCH --time=4-00:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --cpus-per-task=1
#SBATCH --qos=standard
#SBATCH --mem=500M
#SBATCH --partition=main

##module add GROMACS/2021.5-foss-2021b

module add GROMACS/2020-fosscuda-2019b



gmx grompp -f Amp.mdp -o 1prd.tpr -pp 1prd.top -po 1prd.mdp -c eql4.gro

gmx mdrun -s 1prd.tpr -o 1prd.trr -x 1prd.xtc -c 1prd.gro -e 1prd.edr -g 1prd.log -nt 16

for i in $(seq 2 2 50);do

k=$((i-1)) 
j=$((i+1)) 

gmx grompp -f 1Amp.mdp -o ${i}prd.tpr -pp ${i}prd.top -po ${i}prd.mdp -c ${k}prd.gro

gmx mdrun -s ${i}prd.tpr -o ${i}.trr -x ${i}prd.xtc -c ${i}prd.gro -e ${i}.edr -g ${i}prd.log -nt 16

gmx grompp -f 2Amp.mdp -o ${j}prd.tpr -pp ${j}prd.top -po ${j}prd.mdp -c ${i}prd.gro

gmx mdrun -s ${j}prd.tpr -o ${j}.trr -x ${j}prd.xtc -c ${j}prd.gro -e ${j}.edr -g ${j}prd.log -nt 16

done
