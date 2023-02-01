#!/bin/bash

preset () {


	sudo apt-get update 
	sudo apt-get upgrade -y 
	
	sudo apt upgrade -y

	sudo apt-get install -y build-essential cmake unzip pkg-config gcc-6 g++-6 libxmu-dev libxi-dev libglu1-mesa libglu1-mesa-dev libjpeg-dev libpng-dev libtiff-dev libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libxvidcore-dev libx264-dev libopenblas-dev libatlas-base-dev liblapack-dev gfortran libhdf5-serial-dev python3-dev python3-tk python-imaging-tk libgtk-3-dev 

}

cuda_2004_118 () {

	cd ~

	#cuda

	wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
	
	sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
	
	wget https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda-repo-ubuntu2004-11-8-local_11.8.0-520.61.05-1_amd64.deb
	
	sudo dpkg -i cuda-repo-ubuntu2004-11-8-local_11.8.0-520.61.05-1_amd64.deb
	
	sudo cp /var/cuda-repo-ubuntu2004-11-8-local/cuda-*-keyring.gpg /usr/share/keyrings/
	
	sudo apt-get update
	sudo apt-get -y install cuda

	echo $'export PATH=\"/usr/local/cuda-11.8/bin:$PATH\" \n' >> ~/.bashrc
	echo $'export LD_LIBRARY_PATH=\"/usr/local/cuda-11.8/lib64:$LD_LIBRARY_PATH\" \n' >> ~/.bashrc

	source ~/.bashrc

	#cudnn

	cd ~/Downloads

	tar -xf cudnn-linux-x86_64-8.6.0.163_cuda11-archive.tar.xz

	mv ./cudnn-linux-x86_64-8.6.0.163_cuda11-archive ./cuda

	sudo mv ./cuda/include/* /usr/local/cuda/include
	sudo mv ./cuda/lib/* /usr/local/cuda/lib64
	
	sudo chmod a+r /usr/local/cuda

}

cuda_2204_118 () {

	cd ~

	wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
	
	sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
	
	wget https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda-repo-ubuntu2204-11-8-local_11.8.0-520.61.05-1_amd64.deb
	
	sudo dpkg -i cuda-repo-ubuntu2204-11-8-local_11.8.0-520.61.05-1_amd64.deb
	
	sudo cp /var/cuda-repo-ubuntu2204-11-8-local/cuda-*-keyring.gpg /usr/share/keyrings/
	
	sudo apt-get update
	sudo apt-get -y install cuda

	echo $'export PATH=\"/usr/local/cuda-11.8/bin:$PATH\" \n' >> ~/.bashrc
	echo $'export LD_LIBRARY_PATH=\"/usr/local/cuda-11.8/lib64:$LD_LIBRARY_PATH\" \n' >> ~/.bashrc

	source ~/.bashrc

	#cudnn

	cd ~/Downloads

	tar -xf cudnn-linux-x86_64-8.6.0.163_cuda11-archive.tar.xz

	mv ./cudnn-linux-x86_64-8.6.0.163_cuda11-archive ./cuda

	sudo mv ./cuda/include/* /usr/local/cuda/include
	sudo mv ./cuda/lib/* /usr/local/cuda/lib64
	
	sudo chmod a+r /usr/local/cuda

}

cuda_wsl2_118 () {

	cd ~
	
	wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-wsl-ubuntu.pin

	sudo mv cuda-wsl-ubuntu.pin /etc/apt/preferences.d/cuda-repository-pin-600

	wget https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda-repo-wsl-ubuntu-11-8-local_11.8.0-1_amd64.deb

	sudo dpkg -i cuda-repo-wsl-ubuntu-11-8-local_11.8.0-1_amd64.deb
	
	sudo cp /var/cuda-repo-wsl-ubuntu-11-8-local/cuda-*-keyring.gpg /usr/share/keyrings/

	sudo apt-get update
	sudo apt-get -y install cuda

	echo $'export PATH=\"/usr/local/cuda-11.8/bin:$PATH\" \n' >> ~/.bashrc
	echo $'export LD_LIBRARY_PATH=\"/usr/local/cuda-11.8/lib64:$LD_LIBRARY_PATH\" \n' >> ~/.bashrc

	source ~/.bashrc

	#cudnn

	cd ~/Downloads

	tar -xf cudnn-linux-x86_64-8.6.0.163_cuda11-archive.tar.xz

	mv ./cudnn-linux-x86_64-8.6.0.163_cuda11-archive ./cuda

	sudo mv ./cuda/include/* /usr/local/cuda/include
	sudo mv ./cuda/lib/* /usr/local/cuda/lib64
	
	sudo chmod a+r /usr/local/cuda

}

main() {

	echo '!Download cudnn-linux-x86_64-8.6.0.163_cuda11-archive.tar.xz to ~/Downloads/ from cudnn archive first!'

	read -p "Input YES and press ENTER if it's WSL2: " is_wsl2

	if [[ "$is_wsl2" == "YES" ]]; then

		cuda_wsl2_118

	else

		file=/etc/lsb-release
		ubuntu_v=$(grep DISTRIB_RELEASE "$file" | cut -f2 -d'=') 

		if [[ "$ubuntu_v" == "22.04" ]]; then

			echo $'this is 22.04 \n'

			cuda_2204_118
			
					
		elif [[ "$ubuntu_v" == "20.04" ]]; then

			echo $'this is 20.04 \n'

			cuda_2004_118
			
		else

			echo $'the current Ubuntu release is neither 22.04 nor 20.04 \n'

		fi

	fi

}



main