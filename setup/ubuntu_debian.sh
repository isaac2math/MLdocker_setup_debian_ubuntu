#!/bin/bash

################
#### basics ####
################

basic() {

    sudo apt-get update 
    
    sudo apt-get upgrade -y 
    
    sudo apt upgrade -y 

    sudo apt-get install -y texlive-full octave    

}

##########################################################
#### c++, gcc, r, and fortran for BLAS and Intel MKL #####
##########################################################

gcc_setup() {
 
    sudo apt-get install -y r-base libavfilter-dev cargo libpoppler-cpp-dev libmagick++-dev librsvg2-dev \
        tesseract-ocr-eng libtesseract-dev libleptonica-dev libgmp3-dev libcurl4-gnutls-dev libv8-dev \ 
        libssl-dev libjpeg62 libxml2-dev libcairo2-dev libudunits2-dev libgeos-dev libgdal-dev clang gcc \ 
        g++ libmpfr-dev libssh2-1-dev libgit2-dev xdotool xclip libcupti-dev libglu1-mesa-dev freeglut3-dev \ 
        mesa-common-dev gfortran libx11-dev libmkl-dev libboost-all-dev libmlpack-dev libboost-test-dev \ 
        libboost-serialization-dev libarmadillo-dev binutils-dev

}

#############################################
##### julia for huge matrix manipulation ####
#############################################

julia_setup() {

    cd ~ 

    wget https://julialang-s3.julialang.org/bin/linux/x64/1.8/julia-1.8.4-linux-x86_64.tar.gz 
    tar xf julia-1.8.4-linux-x86_64.tar.gz 
    mv ~/julia-1.8.4 ~/julia 
    sudo ln -s /home/ning/julia/julia-1.8.4/bin /usr/local/bin/julia

}

################################
##### conda env for x86-64 #####
################################

conda_setup() {

    cd ~

    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && bash Miniconda3-latest-Linux-x86_64.sh

    #base env : leave it be and don't change it 

    pip install -U pip && conda update --all -y && conda install jupyterlab -c conda-forge -y && conda install -c conda-forge octave_kernel -y && conda install -c conda-forge jax -y

    #sklearn env for basic data maniplation

    conda create -n sklearn-env -c conda-forge scikit-learn -y && conda activate sklearn-env && pip install -U pip && conda update --all -y && conda install -c conda-forge octave_kernel -y && conda install -c conda-forge linearmodels -y && conda install -c conda-forge jax -y && conda install jupyterlab -c conda-forge -y

    #Bayesian env for basic data maniplation

    conda create -n bayesian python=3.9.13 -y && conda activate bayesian && pip install -U pip && conda install -c conda-forge pymc3 -y && conda install -c conda-forge arviz -y && conda install -c conda-forge bambi -y && conda install -c conda-forge aesara -y && conda install jupyterlab -c conda-forge -y && conda install -c conda-forge jax -y && conda install -c conda-forge octave_kernel -y

    #tf env with cuda 11.2 and cudnn 8.1

    conda create -n tensorflow python=3.9.13 -y && conda activate tensorflow && pip install -U pip && conda install -c conda-forge cudatoolkit=11.2 cudnn=8.1.0 -y && export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/ && python3 -m pip install tensorflow && conda install -c conda-forge jax -y && conda install jupyterlab -c conda-forge -y && python3 -c "import tensorflow as tf; print(tf.config.list_physical_devices('GPU'))"
    
    #pytorch env with cuda 11.6 and cudnn 8.1
    
    conda create -n pytorch python=3.9.13 -y && conda activate pytorch && pip install -U pip && conda install pytorch torchvision torchaudio cudatoolkit=11.6 -c pytorch -c conda-forge -y && conda install jupyterlab -c conda-forge -y && conda install -c conda-forge jax -y && conda install -c conda-forge matplotlib -y

    #cpp env for running cuda cpp within Jupyter

    conda create -n cpp -y && conda activate cpp && conda install xeus-cling -c conda-forge -y && conda install jupyterlab -c conda-forge -y

    #a backup env for stable cuda and cudnn

    conda create -n cuda python=3.9.12 -y && conda activate cuda && conda install cuda -c nvidia -y && conda install -c conda-forge jax -y && conda install jupyterlab -c conda-forge -y

}

################
##### main #####
################

main() {

    cd ~

    file=/etc/lsb-release
	ubuntu_v=$(grep DISTRIB_RELEASE "$file" | cut -f2 -d'=') 

    if [[ "$ubuntu_v" == "22.04" ]]; then

        echo $'this is 22.04 \n'

        basic && gcc_setup && julia_setup && conda_setup
        
                
    elif [[ "$ubuntu_v" == "20.04" ]]; then

        echo $'this is 20.04 \n'

        basic && gcc_setup && julia_setup && conda_setup
        
    else

        echo $'the current Ubuntu release is neither 22.04 nor 20.04 \n'

    fi

}


main