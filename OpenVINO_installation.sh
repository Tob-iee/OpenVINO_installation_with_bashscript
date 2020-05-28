#!/bin/bash
echo "Installing dependencies for people detection model"

#function to install open_vino on Mac
function install_openVINO_Mac {        
    echo 'installing xcode command line tool'
    xcode-select --install
    echo 'installing latest version ofcmake'
    pip3 install --upgrade cmake
    echo 'installing latest version of opencv'
    pip3 install --upgrade opencv-python
    echo 'installing latest version of numpy'
    pip3 install --upgrade numpy
    echo 'downloading openvino'
    curl http://registrationcenter-download.intel.com/akdlm/irc_nas/16622/m_openvino_toolkit_p_2020.2.117.dmg --output vino.dmg
    echo 'finished downloading'
    # Mount the image
    hdiutil mount vino.dmg
    open -a /Volumes/m_openvino_toolkit_p_2020.2.117/m_openvino_toolkit_p_2020.2.117.app
    echo 'Setting environment variables'
    echo 'source /opt/intel/openvino/bin/setupvars.sh' >> ~/.bash_profile
    # Unmount the image
    hdiutil unmount "/Volumes/m_openvino_toolkit_p_2020.2.117"
    # Delete the image
    rm vino.dmg
    echo 'OpenVINO toolkit installation completed'
}
# function to install open_vino on linux
function install_openVINO_Linux {
    echo "Ubuntu"
    echo 'installing latest version of opencv'
    pip3 install --upgrade opencv-python
    echo 'installing latest version of numpy'
    pip3 install --upgrade numpy    
    cd ~/Downloads
    echo 'downloading openvino'
    curl http://registrationcenter-download.intel.com/akdlm/irc_nas/16345/l_openvino_toolkit_p_2020.1.023.tgz --output l_openvino_toolkit_p_2020.1.023.tgz
    echo 'finished downloading'
    tar -xvzf l_openvino_toolkit_p_2020.1.023.tgz
    cd l_openvino_toolkit_p_2020.1.023
    echo "Installing openVINO"
    sudo ./install.sh
    
    echo 'Installing dependencies'
    cd /opt/intel/openvino/install_dependencies
    sudo -E ./install_openvino_dependencies.sh

    echo 'Setting environment variables'
    echo 'source /opt/intel/openvino/bin/setupvars.sh' >> ~/.bashrc
}



# obtain the deployment platform
p_name=`uname`
echo $p_name


if [ "$p_name" == 'Darwin' ]
then
    echo "I am a Mac"
    # Return 1 if python version is ≥ 3.5, otherwise return 0 if python < 3.5 or doesn't exist.
    py_version=$(python -c"import sys; print(0) if sys.version_info.major < 3 and sys.version_info.minor < 5 else print(1)")
    # if python version is ≥ 3.5, do
    if [ $py_version == 1 ]
    then
    # install openVINO toolkkit
        install_openVINO_Mac
   
    # if python version is < 3.5 or python isn't installed,
    else
        # use brew to install python
        brew install python3
        # install openVINO toolkit
        install_openVINO_Mac
    fi

elif [ "$p_name" == 'Linux' ]
then 
    echo "Linux"
    py_version=$(python3 -c"import sys; print(0) if sys.version_info.major < 3 and sys.version_info.minor < 5 else print(1)")
    if [ $py_version == 1 ]
    then
        Distribution=$(lsb_release -i -s)
        if [ $Distribution == 'Ubuntu' ]
        then 
            install_openVINO_Linux
        else
            echo 'Linux Distribution not supported by OpenVINO or require some modification'
        fi
    else
        sudo apt-get update
        sudo apt-get install python3.6
        install_openVINO_Linux
    fi
fi
