import numpy as np
import statsmodels.api as sm

def AFC_Wiener(P_data):


    """""""""

    Calculates viscosity from Pressure tensor using Green-Kubo relation. It has a autocorrelation function (ACF) implemented, that uses 
    Wiener ACF. 

    INPUT

    P_data - (13,N) array where N are the steps/frame from GROMACS

    GK_type - How many off diagonal elements do you wanna use to compute. 0 is default and uses (xy,xz,yz)


    OUTPUT

    - one dimensional array of AFC austocorrelation of the pressure tensor

    """""""""""""""



    recalc = 10**(5)


    P_xx = P_data[1] * recalc

    P_xy = P_data[2]* recalc

    P_xz = P_data[3]* recalc

    P_yx = P_data[4]* recalc

    P_yy = P_data[5]* recalc

    P_yz = P_data[6]* recalc

    P_zx = P_data[7]* recalc

    P_zy = P_data[8]* recalc

    P_zz = P_data[9]* recalc


    # P_xxyy = (P_xx - P_yy) / 2

    # P_yyzz = (P_yy-P_zz) / 2

    # P_xxzz = (P_xx - P_zz) / 2

    # P_xxyz = (4/3) * (P_xx - ((P_xx + P_yy + P_zz)/3))

    # P_yxyz = (4/3) * (P_yy - ((P_xx + P_yy + P_zz)/3))

    # P_zxyz = (4/3) * (P_zz - ((P_xx + P_yy + P_zz)/3))

    def AFC(P):

        N = len(P)

        X = np.zeros(N)

        X= np.concatenate((P,X))

        X = np.fft.fft(X)

        X = X * np.conj(X)

        X = np.fft.ifft(X)

        X = X[1:N].real

        

        

        return X/N

    N_ = len(P_xy)    

    #print('start Library')

    P_xy_afc_sm = sm.tsa.acf(P_xy, nlags = N_)# len(N)-1)

    P_xz_afc_sm = sm.tsa.acf(P_xz, nlags = N_)# len(N)-1)

    P_yz_afc_sm = sm.tsa.acf(P_yz, nlags = N_)# len(N)-1)

    avg_sm_afc = (P_xy_afc_sm + P_xz_afc_sm + P_yz_afc_sm) / 3 

    #print('End Library')


    print('start own')

    P_xy_mean = P_xy #- np.mean(P_xy)

    P_xy_afc = AFC(P_xy_mean)

    P_xz_mean = P_xz #- np.mean(P_xz)

    P_xz_afc = AFC(P_xz_mean)

    P_yz_mean = P_yz #- np.mean(P_yz)

    P_yz_afc = AFC(P_yz_mean)

    avg_afc = (P_xy_afc + P_xz_afc + P_yz_afc) / 3 

        #avg_afc_norm_mean = (P_xy_afc + P_xz_afc + P_yz_afc) / 3 - np.mean(np.array([P_xy_afc,P_xz_afc,P_yz_afc])) 
    # print('start no mean')

    return avg_afc,avg_sm_afc#,no_mean_avg_afc_#,var_avg_afc_




def ACF(P):

    N = len(P)

    X = np.zeros(N)

    X= np.concatenate((P,X))

    X = np.fft.fft(X)

    X = X * np.conj(X)

    X = np.fft.ifft(X)

    X = X[1:N].real

        

        

    return X/N



def AFC_Wiener_openmm(P_data):


    """""""""

    Calculates viscosity from Pressure tensor using Green-Kubo relation 

    INPUT

    P_data - (13,N) array where N are the steps/frame

    GK_type - How many off diagonal elements do you wanna use to compute. 0 is default and uses (xy,xz,yz)


    OUTPUT

    - one dimensional array of AFC austocorrelation of the pressure tensor

    """""""""""""""



    recalc = 10**(5)


    P_xx = P_data[:,0,0] * recalc

    P_xy = P_data[:,0,1]* recalc

    P_xz = P_data[:,0,2]* recalc

    P_yx = P_data[:,1,0]* recalc

    P_yy = P_data[:,1,1]* recalc

    P_yz = P_data[:,1,2]* recalc

    P_zx = P_data[:,2,0] * recalc

    P_zy = P_data[:,2,1]* recalc

    P_zz = P_data[:,2,2]* recalc


    # P_xxyy = (P_xx - P_yy) / 2

    # P_yyzz = (P_yy-P_zz) / 2

    # P_xxzz = (P_xx - P_zz) / 2

    # P_xxyz = (4/3) * (P_xx - ((P_xx + P_yy + P_zz)/3))

    # P_yxyz = (4/3) * (P_yy - ((P_xx + P_yy + P_zz)/3))

    # P_zxyz = (4/3) * (P_zz - ((P_xx + P_yy + P_zz)/3))

    def AFC(P):

        N = len(P)

        X = np.zeros(N)

        X= np.concatenate((P,X))

        X = np.fft.fft(X)

        X = X * np.conj(X)

        X = np.fft.ifft(X)

        X = X[1:N].real

        

        

        return X/N

    N_ = len(P_xy)    

    print('start Library')

    P_xy_afc_sm = sm.tsa.acf(P_xy, nlags = N_)# len(N)-1)

    P_xz_afc_sm = sm.tsa.acf(P_xz, nlags = N_)# len(N)-1)

    P_yz_afc_sm = sm.tsa.acf(P_yz, nlags = N_)# len(N)-1)

    avg_sm_afc = (P_xy_afc_sm + P_xz_afc_sm + P_yz_afc_sm) / 3 

    print('End Library')


    print('start own')

    P_xy_mean = P_xy #- np.mean(P_xy)

    P_xy_afc = AFC(P_xy_mean)

    P_xz_mean = P_xz #- np.mean(P_xz)

    P_xz_afc = AFC(P_xz_mean)

    P_yz_mean = P_yz #- np.mean(P_yz)

    P_yz_afc = AFC(P_yz_mean)

    avg_afc = (P_xy_afc + P_xz_afc + P_yz_afc) / 3 

        #avg_afc_norm_mean = (P_xy_afc + P_xz_afc + P_yz_afc) / 3 - np.mean(np.array([P_xy_afc,P_xz_afc,P_yz_afc])) 
    # print('start no mean')

    return avg_afc,avg_sm_afc#,no_mean_avg_afc_#,var_avg_afc_




def conv_txt(tensor):

    Pxx = tensor[:,0,0]

    Pxy = tensor[:,0,1]

    Pxz = tensor[:,0,2]

    Pyx = tensor[:,1,0]

    Pyy = tensor[:,1,1]

    Pyz = tensor[:,1,2]

    Pzx = tensor[:,2,0]

    Pzy = tensor[:,2,1]

    Pyy = tensor[:,2,2]

    np.savetxt('Pressure.txt', np.c_[Pxx,Pxy,Pxz,Pyx,Pyy,Pyz,Pzx,Pzy,Pyy])