#!/bin/bash

#SBATCH --mail-user=nikolasmif98@zedat.fu-berlin.de
#SBATCH --job-name=ethanol_NVT
#SBATCH --mail-type=none
#SBATCH --time=3-00:00:00
#SBATCH --qos=standard
#SBATCH --mem=6g
#SBATCH --partition=agkeller
#SBATCH --gres=gpu:1

module add GROMACS/2020-fosscuda-2019b

mkdir ${SLURM_ARRAY_TASK_ID}ethanol; 

cp ethanol/minim.mdp ${SLURM_ARRAY_TASK_ID}ethanol/.
cp ethanol/min2.mdp ${SLURM_ARRAY_TASK_ID}ethanol/.
cp ethanol/nvtrun.mdp ${SLURM_ARRAY_TASK_ID}ethanol/.
cp ethanol/nptrun.mdp ${SLURM_ARRAY_TASK_ID}ethanol/.
cp ethanol/mdrun.mdp ${SLURM_ARRAY_TASK_ID}ethanol/.
cp ethanol/topol.top ${SLURM_ARRAY_TASK_ID}ethanol/.
cp ethanol/ethanol.pdb ${SLURM_ARRAY_TASK_ID}ethanol/.
cp ethanol/ethanol.itp ${SLURM_ARRAY_TASK_ID}ethanol/.
cp -r ethanol/gromos54a7_atb.ff ${SLURM_ARRAY_TASK_ID}ethanol/.







cd ./${SLURM_ARRAY_TASK_ID}ethanol



gmx insert-molecules -ci ethanol.pdb -o conf.gro -nmol 1180 -box 5 5 5

gmx grompp -f minim.mdp -o min.tpr -pp min.top -po min.mdp -maxwarn 2
gmx mdrun -s min.tpr -o min.trr -x min.xtc -c min.gro -e min.edr -g min.log -nb gpu

gmx grompp -f min2.mdp -o min2.tpr -pp min2.top -po min2.mdp -c min.gro -maxwarn 2
gmx mdrun -s min2.tpr -o min2.trr -x min2.xtc -c min2.gro -e min2.edr -g min2.log -nb gpu


gmx grompp -f nptrun.mdp -o eql.tpr -pp eql.top -po eql.mdp -c min2.gro -maxwarn 2
gmx mdrun -s eql.tpr -o eql.trr -x eql.xtc -c eql.gro -e eql.edr -g eql.log -nb gpu

gmx grompp -f nvtrun.mdp -o eql2.tpr -pp eql2.top -po eql2.mdp -c eql.gro -maxwarn 2
gmx mdrun -s eql2.tpr -o eql2.trr -x eql2.xtc -c eql2.gro -e eql2.edr -g eql2.log -nb gpu

gmx grompp -f mdrun.mdp -o prd.tpr -pp prd.top -po prd.mdp -c eql2.gro -maxwarn 2
gmx mdrun -s prd.tpr -o prd.trr -x prd.xtc -c prd.gro -e prd.edr -g prd.log -nb gpu


echo "125" | gmx energy -f prd.edr -vis VIS.xvg

cd -

done











