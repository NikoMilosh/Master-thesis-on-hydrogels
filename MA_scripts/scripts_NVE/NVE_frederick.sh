#!/bin/bash

#SBATCH --mail-user=nikolasmif98@zedat.fu-berlin.de
#SBATCH --job-name=VBT
#SBATCH --mail-type=all
#SBATCH --time=1-00:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32                            # replace with value for your job
#SBATCH --mem=3g 
#SBATCH --qos=standard
#SBATCH --partition=main


module add GROMACS/2021.5-foss-2021b


mkdir NVE_fred${SLURM_ARRAY_TASK_ID}

cp MDP_NVE_fred_DP/minim.mdp NVE_fred${SLURM_ARRAY_TASK_ID}/.
cp MDP_NVE_fred_DP/min2.mdp NVE_fred${SLURM_ARRAY_TASK_ID}/.
cp MDP_NVE_fred_DP/nvtrun.mdp NVE_fred${SLURM_ARRAY_TASK_ID}/.
cp MDP_NVE_fred_DP/nptrun.mdp NVE_fred${SLURM_ARRAY_TASK_ID}/.
cp MDP_NVE_fred_DP/mdrun${SLURM_ARRAY_TASK_ID}.mdp NVE_fred${SLURM_ARRAY_TASK_ID}/.
cp MDP_NVE_fred_DP/topol.top NVE_fred${SLURM_ARRAY_TASK_ID}/.

cd ./NVE_fred${SLURM_ARRAY_TASK_ID}

gmx solvate -cs tip4p -o conf.gro -box 3 3 3 -p topol.top 

gmx grompp -f minim.mdp -o min.tpr -pp min.top -po min.mdp


gmx mdrun -s min.tpr -o min.trr -x min.xtc -c min.gro -e min.edr -g min.log


gmx grompp -f min2.mdp -o min2.tpr -pp min2.top -po min2.mdp -c min.gro


gmx mdrun -s min2.tpr -o min2.trr -x min2.xtc -c min2.gro -e min2.edr -g min2.log

gmx grompp -f nptrun.mdp -o eql.tpr -pp eql.top -po eql.mdp -c min2.gro

gmx mdrun -s eql.tpr -o eql.trr -x eql.xtc -c eql.gro -e eql.edr -g eql.log
#
gmx grompp -f  nvtrun.mdp -o eql2.tpr -pp eql2.top -po eql2.mdp -c eql.gro

gmx mdrun -s eql2.tpr -o eql2.trr -x eql2.xtc -c eql2.gro -e eql2.edr -g eql2.log

gmx_d grompp -f mdrun${SLURM_ARRAY_TASK_ID}.mdp -o prd.tpr -pp prd.top -po prd.mdp -c eql2.gro

gmx_d mdrun -s prd.tpr -o prd.trr -x prd.xtc -c prd.gro -e prd.edr -g prd.log

echo "13 0 " | gmx energy -f prd.edr -o E_tot.xvg ;Depending on the GROMACS version another number

echo "15 0 " | gmx energy -f prd.edr -o temp.xvg


