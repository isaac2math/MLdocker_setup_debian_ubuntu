#!/bin/bash

docker_setup () {

    #set up docker on ubuntu 20.04 or 22.04

    sudo apt-get update 
    sudo apt-get install ca-certificates curl gnupg lsb-release 
    sudo mkdir -p /etc/apt/keyrings 
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg 
    
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null 
    
    sudo apt-get update 
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin 
    
    sudo groupadd docker 
    sudo usermod -aG docker $USE

    #restart your .bashrc to make sure docker is running properly; enable docker afterwards

    source ~/.bashrc && sudo systemctl --now enable docker

}

nvdocker_setup () {

    # ubuntu version check

    file=/etc/lsb-release
    ubuntu_v=$(grep DISTRIB_RELEASE "$file" | cut -f2 -d'=') 
    
    #echo $ubuntu_v

    if [[ "$ubuntu_v" == "22.04"  || "$ubuntu_v" == "20.04" ]]; then

		echo $'this is 20.04; it is okay to proceed \n'
		
	else

		echo $'the current Ubuntu release is not 22.04 nor 20.04 \n'
        
        return

	fi

    read -p "Input YES for stable version of NV-docker; press ENTER to continue : " confirm

    if [[ "$confirm" == "YES" ]]; then
    
        #Setup the package repository and the GPG key

        echo $'you are installing the stable version \n'

        read -p "Press enter to double-confirm or CTRL + C to cancel"

        distribution=$(. /etc/os-release;echo $ID$VERSION_ID) 
        curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg 
        curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
    
    else

        echo $'you are installing the experimental version \n'

        read -p "Press enter to double-confirm or CTRL + C to cancel"

        #If you are looking for experimental features, run the following script instead
        #not recommended if you don't know what you are doing

        distribution=$(. /etc/os-release;echo $ID$VERSION_ID) 
        curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg 
        curl -s -L https://nvidia.github.io/libnvidia-container/experimental/$distribution/libnvidia-container.list | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
    
    fi

    #install nvidia-docker2

    sudo apt-get update && sudo apt-get install -y nvidia-docker2 && source ~/.bashrc && sudo systemctl restart docker

    #testing nvidia-docker2

    sudo docker run --rm --gpus all nvidia/cuda:11.6.2-base-ubuntu20.04 nvidia-smi

}

nvdocker () {

    # create a docker container
    
    echo 'I recommend 64GB memory at minimum; increase it to 128 if possible'

    read -p "Input your shared memory size (in GB, number only): " ram_size

    read -p "Input your data path (end with /): " your_coco_path
    read -p "Input your code path (end with /): " your_code_path

    read -p "Input YES if you need COCO sample data; press ENTER to continue : " coco_sample

    if [[ "$coco_sample" == "YES" ]]; then
        # Download/unzip labels
        
        # unzip directory
        d="$your_coco_path" 
        # download url
        url=https://github.com/ultralytics/yolov5/releases/download/v1.0/
        # label data
        f='coco2017labels-segments.zip' # or 'coco2017labels.zip', 68 MB

        echo 'Downloading' $url$f ' ...'
        # download, unzip, remove in background
        curl -L $url$f -o $f && unzip -q $f -d $d && rm $f & 

        # Download/unzip images

        d="$your_coco_path"/images # unzip directory
        url=http://images.cocodataset.org/zips/
        f1='train2017.zip' # 19G, 118k images
        f2='val2017.zip'   # 1G, 5k images
        f3='test2017.zip'  # 7G, 41k images (optional)
        
        for f in $f1 $f2 $f3; do
            
            echo 'Downloading' $url$f '...'

            # download, unzip, remove in background
            curl -L $url$f -o $f && unzip -q $f -d $d && rm $f & 

        done

        # finish background tasks
        wait 

    fi

    sudo nvidia-docker run --name yolov7 -it -v "$your_coco_path"/:/coco/ -v "$your_code_path"/:/yolov7 --shm-size="$ram_size"g nvcr.io/nvidia/pytorch:21.08-py3
    
}

main() {

    read -p "Input YES if you need to install docker; press ENTER to continue : " confirm_dk

    if [[ "$confirm_dk" == "YES" ]]; then
        
        docker_setup
    
    fi

    read -p "Input YES if you need to install NV-docker; press ENTER to continue : " confirm_nvdk

    if [[ "$confirm_nvdk" == "YES" ]]; then
        
        nvdocker_setup
    
    fi

    read -p "Input YES if you need to setup a NV-docker container; press ENTER to continue : " nvdk

    if [[ "$nvdk" == "YES" ]]; then
        
        nvdocker
    
    fi
   
}

main