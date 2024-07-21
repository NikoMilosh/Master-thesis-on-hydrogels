#!/bin/bash


#SBATCH --mail-user=nikolasmif98@zedat.fu-berlin.de
#SBATCH --job-name=FmoF
#SBATCH --mail-type=none
#SBATCH --time=4-00:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --qos=standard
#SBATCH --mem=500M
#SBATCH --gres=gpu:2
#SBATCH --partition=gpu



module add GROMACS/2020-fosscuda-2019b

for i in `seq 1 1`; do mkdir ${SLURM_ARRAY_TASK_ID}FmocF; 


cp MDP/minim.mdp ${SLURM_ARRAY_TASK_ID}FmocF/.
cp MDP/min2.mdp ${SLURM_ARRAY_TASK_ID}FmocF/.
cp MDP/nvtrun.mdp ${SLURM_ARRAY_TASK_ID}FmocF/.
cp MDP/nptrun.mdp ${SLURM_ARRAY_TASK_ID}FmocF/.
cp MDP/mdrun.mdp ${SLURM_ARRAY_TASK_ID}FmocF/.
cp MDP/FmocF.pdb ${SLURM_ARRAY_TASK_ID}FmocF/.
cp MDP/topol.top ${SLURM_ARRAY_TASK_ID}FmocF/.
cp MDP/FmocF.itp ${SLURM_ARRAY_TASK_ID}FmocF/.
cp -r MDP/gromos54a7_atb.ff ${SLURM_ARRAY_TASK_ID}FmocF/.




#cd ${i}Water_run 
cd ./${SLURM_ARRAY_TASK_ID}FmocF


gmx insert-molecules -ci FmocF.pdb -o conf.gro -nmol 14 -box 10 10 10



gmx solvate -cp conf.gro -o conf.gro -cs tip4p.gro -p topol.top 

gmx grompp -f minim.mdp -o min.tpr -pp min.top -po min.mdp -maxwarn 2
gmx mdrun -s min.tpr -o min.trr -x min.xtc -c min.gro -e min.edr -g min.log -nb gpu

gmx grompp -f min2.mdp -o min2.tpr -pp min2.top -po min2.mdp -c min.gro -maxwarn 2
gmx mdrun -s min2.tpr -o min2.trr -x min2.xtc -c min2.gro -e min2.edr -g min2.log -nb gpu

echo "4" |gmx genion -s min2.tpr -p topol.top -o min2.gro -np 1 -pname NA -pq 1 -nn 1 -nname CL -nq -1 -rmin 1.4 -conc 0.01

gmx grompp -f min2.mdp -o min3.tpr -pp min3.top -po min3.mdp -c min2.gro -maxwarn 2
gmx mdrun -s min3.tpr -o min3.trr -x min3.xtc -c min3.gro -e min3.edr -g min3.log -nb gpu

#gmx grompp -f min2.mdp -o min4.tpr -pp min4.top -po min4.mdp -c min3.gro -maxwarn 2
#gmx mdrun -s min4.tpr -o min4.trr -x min4.xtc -c min4.gro -e min4.edr -g min4.log -nb gpu

gmx grompp -f nptrun.mdp -o eql.tpr -pp eql.top -po eql.mdp -c min3.gro -maxwarn 2
gmx mdrun -s eql.tpr -o eql.trr -x eql.xtc -c eql.gro -e eql.edr -g eql.log -nb gpu

gmx grompp -f nvtrun.mdp -o eql2.tpr -pp eql2.top -po eql2.mdp -c eql.gro -maxwarn 2

gmx mdrun -s eql2.tpr -o eql2.trr -x eql2.xtc -c eql2.gro -e eql2.edr -g eql2.log -nb gpu


gmx grompp -f mdrun.mdp -o prd.tpr -pp prd.top -po prd.mdp -c eql2.gro -maxwarn 2
gmx mdrun -s prd.tpr -o prd.trr -x prd.xtc -c prd.gro -e prd.edr -g prd.log  -nb gpu



echo "1000" | gmx energy -f prd.edr -vis VIS.xvg

cd -



done



