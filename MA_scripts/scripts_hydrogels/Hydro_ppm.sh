#!/bin/bash

#SBATCH --mail-user=nikolasmif98@zedat.fu-berlin.de
#SBATCH --job-name=Test
#SBATCH --mail-type=none
#SBATCH --time=2-00:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --qos=standard
#SBATCH --mem=500M
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1

module add GROMACS/2020-fosscuda-2019b

#module add GROMACS/2021.5-foss-2021b

workdir="${SLURM_ARRAY_TASK_ID}Phe_Val";

mkdir $workdir; 



cp -r MDP/{*.mdp,h.gro,topol.top,*itp,*.pdb} $workdir



cd ./$workdir


#sed -i "s/xx/${SLURM_ARRAY_TASK_ID}/g" mdrun.mdp
#sed -i "s/xx/$i/g" mdrun.mdp 


gmx insert-molecules -ci h.gro -o conf.gro -nmol 1 -box 10 10 10

gmx grompp -f minim.mdp -o min.tpr -pp min.top -po min.mdp -c conf.gro -maxwarn 2
gmx mdrun -s min.tpr -o min.trr -x min.xtc -c min.gro -e min.edr -g min.log -nb gpu 

gmx solvate -cp conf.gro -o sol.gro -cs tip4p.gro -p topol.top

gmx grompp -f minim.mdp -o min2.tpr -pp min2.top -po min2.mdp -c sol.gro -maxwarn 2
gmx mdrun -s min2.tpr -o min2.trr -x min2.xtc -c min2.gro -e min2.edr -g min2.log -nb gpu

gmx grompp -f min2.mdp -o min3.tpr -pp min3.top -po min3.mdp -c min2.gro -maxwarn 2
gmx mdrun -s min3.tpr -o min3.trr -x min3.xtc -c min3.gro -e min3.edr -g min3.log -nb gpu

gmx grompp -f nptrun.mdp -o eql.tpr -pp eql.top -po eql.mdp -c min3.gro -maxwarn 2
gmx mdrun -s eql.tpr -o eql.trr -x eql.xtc -c eql.gro -e eql.edr -g eql.log -nb gpu

gmx grompp -f nvtrun.mdp -o eql2.tpr -pp eql2.top -po eql2.mdp -c eql.gro -maxwarn 2
gmx mdrun -s eql2.tpr -o eql2.trr -x eql2.xtc -c eql2.gro -e eql2.edr -g eql2.log -nb gpu

gmx grompp -f mdrun.mdp -o prd.tpr -pp prd.top -po prd.mdp -c eql.gro -maxwarn 2
gmx mdrun -s prd.tpr -o prd.trr -x prd.xtc -c prd.gro -e prd.edr -g prd.log -nb gpu

echo "1000" | gmx energy -f prd.edr -vis VIS.xvg


rm -r *.trr
rm -r *.tpr
rm -r *.xtc






