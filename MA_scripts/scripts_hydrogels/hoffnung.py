import numpy as np

off_set = np.array([0,5,10,15,20,25,30,35,40])#])

#off_set = np.array([40])#,27,36])


#for i in off_set:
    
for folder in range(30,31):
    
    pth = f'/home/nikolasmif98/nobackup/Test_2/{folder}'
    
    print(pth)
    
    for n in off_set:
        
        print(n)
        
        
        data_1 = np.loadtxt(pth + f'/{n+1}energy.xvg',comments=("#","@","&"),unpack=True,usecols = (0,2,3,6))

        data_2 = np.loadtxt(pth + f'/{n+2}energy.xvg',comments=("#","@","&"),unpack=True,usecols = (0,2,3,6))

        data_3 = np.loadtxt(pth + f'/{n+3}energy.xvg',comments=("#","@","&"),unpack=True,usecols = (0,2,3,6))

        data_4 = np.loadtxt(pth + f'/{n+4}energy.xvg',comments=("#","@","&"),unpack=True,usecols = (0,2,3,6))

        data_5 = np.loadtxt(pth + f'/{n+5}energy.xvg',comments=("#","@","&"),unpack=True,usecols = (0,2,3,6))



        a = np.concatenate((data_1[1:],data_2[1:],data_3[1:],data_4[1:],data_5[1:]),axis=1)

        tim = np.concatenate((data_1[0],data_2[0]+data_1[0,-1],data_2[0]+data_1[0,-1]*2,
                             data_1[0],data_2[0]+data_1[0,-1]),axis=0)
        
        np.save(f'{folder}_{n}.npy',[a,tim])
        
        del a,tim,data_1,data_2,data_3,data_4,data_5

      
