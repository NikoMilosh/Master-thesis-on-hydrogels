#!/bin/bash



for i in `seq 1 20`; do mkdir ${i}Water_run; 

cp MDP/minim.mdp ${i}Water_run/.
cp MDP/min2.mdp ${i}Water_run/.
cp MDP/nvtrun.mdp ${i}Water_run/.
cp MDP/nptrun.mdp ${i}Water_run/.
cp MDP/mdrun.mdp ${i}Water_run/.
cp MDP/topol.top ${i}Water_run/.
#cd ${i}Water_run 
cd ./${i}Water_run

gmx22 solvate -cs tip4p -o conf.gro -box 3 3 3 -p topol.top 

gmx22 grompp -f minim.mdp -o min.tpr -pp min.top -po min.mdp


gmx22 mdrun -s min.tpr -o min.trr -x min.xtc -c min.gro -e min.edr -g min.log


gmx22 grompp -f min2.mdp -o min2.tpr -pp min2.top -po min2.mdp -c min.gro


gmx22 mdrun -s min2.tpr -o min2.trr -x min2.xtc -c min2.gro -e min2.edr -g min2.log

gmx22 grompp -f nvtrun.mdp -o eql.tpr -pp eql.top -po eql.mdp -c min2.gro

gmx22 mdrun -s eql.tpr -o eql.trr -x eql.xtc -c eql.gro -e eql.edr -g eql.log
#
gmx22 grompp -f nptrun.mdp -o eql2.tpr -pp eql2.top -po eql2.mdp -c eql.gro

gmx22 mdrun -s eql2.tpr -o eql2.trr -x eql2.xtc -c eql2.gro -e eql2.edr -g eql2.log

gmx22 grompp -f mdrun.mdp -o prd.tpr -pp prd.top -po prd.mdp -c eql2.gro

gmx22 mdrun -s prd.tpr -o prd.trr -x prd.xtc -c prd.gro -e prd.edr -g prd.log

#27 | gmx22 energy -f prd.edr -vis VIS.xvg 

echo "27 " | gmx22 energy -f prd.edr -vis VIS.xvg

cd -

done



