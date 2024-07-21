#!/bin/bash

#SBATCH --mail-user=nikolasmif98@zedat.fu-berlin.de
#SBATCH --job-name=H2O_NVE
#SBATCH --mail-type=all
#SBATCH --time=3-00:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32                            # replace with value for your job
#SBATCH --mem=3g 
#SBATCH --qos=standard
#SBATCH --partition=main

module add GROMACS/2021.5-foss-2021b



for i in `seq 0 9`; do mkdir ${SLURM_ARRAY_TASK_ID}_${i}PPM; 


cp mdrun.mdp  ${SLURM_ARRAY_TASK_ID}_${i}PPM/.
cp topol.top  ${SLURM_ARRAY_TASK_ID}_${i}PPM/.
cp eql2.gro  ${SLURM_ARRAY_TASK_ID}_${i}PPM/.


cd ./${SLURM_ARRAY_TASK_ID}_${i}PPM



#str = "s/xx/1/g"
sed -i "s/yy/${SLURM_ARRAY_TASK_ID}/g" mdrun.mdp
sed -i "s/xx/$i/g" mdrun.mdp 

gmx grompp -f mdrun.mdp -o prd.tpr -pp prd.top -po prd.mdp -c eql2.gro

gmx mdrun -s prd.tpr -o prd.trr -x prd.xtc -c prd.gro -e prd.edr -g prd.log

#27 | gmx22 energy -f prd.edr -vis VIS${i}.xvg 

#echo "27 " | gmx22 energy -f prd${i}.edr -vis ${i}VIS.xvg

echo "31 0 " | gmx energy -f prd.edr -o Velprf.xvg

echo "32 0 " | gmx energy -f prd.edr -o inveta.xvg

cd -


done

#gmx22 grompp -f mdrun_7.mdp -o prd_.tpr -pp prd_.top -po prd_.mdp -c eql2.gro
#gmx22 mdrun -s prd_.tpr -o prd_.trr -x prd_.xtc -c prd_.gro -e prd_.edr -g prd_.log
