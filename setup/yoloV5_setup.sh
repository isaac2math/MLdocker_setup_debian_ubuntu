#!/bin/bash

yoloV5_setup () {

    conda create -n open-mmlab python=3.8 pytorch==1.10.1 torchvision==0.11.2 cudatoolkit=11.3 -c pytorch -y
    conda activate open-mmlab
    conda install jupyterlab -c conda-forge -y 

    pip install -U pip
    pip install openmim
    
    mim install "mmengine==0.1.0"   
    mim install "mmcv>=2.0.0rc1,<2.1.0"
    mim install "mmdet>=3.0.0rc1,<3.1.0"
    
    git clone https://github.com/open-mmlab/mmyolo.git
    
    cd mmyolo
    
    # Install albumentations
    pip install -r requirements/albu.txt
    
    # Install MMYOLO
    mim install -v -e .

}

yoloV5_setup