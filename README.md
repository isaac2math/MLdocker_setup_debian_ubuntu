# the bash to install necessary deep learning and data science packages on Ubuntu/Debian NV-dockers

the file includes the installation and fine tuning of 

* Python (via Miniconda, depending on whether your CPU is x86-64 or arm) 
* R
* Julia
* Octave
* texlive
* all necessary C++ files (Fortran, MKL, openBLAS, etc)

### !!! do not run it with sudo !!! Remember to input the password when needed !!!

### step 1: read the cuda_setup.sh first. Make sure everything satisfies your requirements. Then run the cuda_setup.sh first.
> to make sure Ubuntu prioritize the cuda blas (instead of openblas or Intel MKL --- aka oneAPI --- a much slower version for data/matrix manipulation), run the cuda_setup bash before the ubuntu_debian.sh and source your .bashrc.

    - the default version is cuda 11.8 and cudnn 8.6 (the stablest version)
    - the script is optimzed for 22.04 and 20.04, ubuntu or WSL2 ubuntu
    - due to 2FA issue, you need to download cudnn-linux-x86_64-8.6.0.163_cuda11-archive.tar.xz from cudnn archive first and leave it at to ~/Downloads/
    
### !!! Now restart your OS !!!

### step 2: read the ubuntu_debian.sh. Make sure everything satisfies your requirements. Then run it on your native Ubuntu/Debian

    - the basics of Ubuntu/Debian;
    - C++, gcc/g++/clang, r, and fortran for BLAS and Intel MKL (necessary for quick deep learning and snappy data engineering);
    - Julia for huge BLAS manipulation (strongly recommended for beginners, easier to handle and quicker than C++);
    - Conda env for x86-64;
      - base env ;
      - sklearn env and Bayesian env for basic data maniplation ;
      - tf env with cuda 11.2 and cudnn 8.1 ;
      - pytorch env with cuda 11.6 and cudnn 8.1 ;
      - cpp env for running cuda cpp within Jupyter ;
      - a backup env with stable versions of cuda and cudnn for testing ;

### step 3: read the nvidia_docker.sh first. Make sure everything satisfies your requirements. Then run it to setup a proper nvidia-docker.

### step 4: within the docker, you can run yoloV5_setup.sh, yoloV7_setup.sh, or yoloV8_setup.sh to set up proper NV-dockers for the YoLo family.
