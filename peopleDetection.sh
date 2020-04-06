#!/bin/bash
echo "Installing dependencies for people detection model"

## save the platform name in the variable p_name
p_name=`uname`
echo $p_name

## function to install openVINO
function install_vino_mac {
    echo 'installing xcode command line tool'
    xcode-select --install
    echo 'installing latest version ofcmake'
    pip3 install --upgrade cmake
    echo 'installing latest version of opencv'
    pip3 install --upgrade opencv-python
    echo 'installing latest version of numpy'
    pip3 install --upgrade numpy
    echo 'downloading openvino'
    curl http://registrationcenter-download.intel.com/akdlm/irc_nas/16343/m_openvino_toolkit_p_2020.1.023.dmg --output vino.dmg
    echo 'finished downloading'
    # Mount the image
    hdiutil mount vino.dmg
    #Install the packages in the image
    open -a /Volumes/m_openvino_toolkit_p_2020.1.023/m_openvino_toolkit_p_2020.1.023.app
    echo 'Setting environment variables'
    echo 'source /opt/intel/openvino/bin/setupvars.sh' >> ~/.bash_profile
    # Unmount the image
    hdiutil unmount "/Volumes/Chicken of the VNC/"
    echo 'OpenVINO toolkit installation completed'
}


## if platform is Mac OS
if [ "$p_name" == 'Darwin' ]
then
    echo "I am a Mac"
    # Return 1 if python version is ≥ 3.5, otherwise return 0 if python < 3.5 or doesn't exist.
    py_version=$(python -c"import sys; print(0) if sys.version_info.major < 3 and sys.version_info.minor < 5 else print(1)")
    # if python version is ≥ 3.5, do
    if [ $py_version == 1 ]
    then
        # install openVINO toolkkit
        install_vino_mac
    # if python version is < 3.5 or python isn't installed, do
    elif [ $py_version == 0 ]
    then
        # use brew to install python
        brew install python3
        # install openVINO toolkit
        install_vino_mac
    fi

## if platform is Linux
elif [ "$p_name" == 'Linux' ]
then 
    #echo "I am a Linux"
    py_version=$(python3 -c"import sys; print(0) if sys.version_info.major < 3 and sys.version_info.minor < 5 else print(1)")
    if [ $py_version == 1 ]
    then
        echo 'installing latest version of opencv'
        # pip3 install --upgrade opencv-python
        echo 'installing latest version of numpy'
        # pip3 install --upgrade numpy

        Distribution=$(lsb_release -i -s)
        if [ $Distribution == 'Ubuntu' ]
        then 
            echo "Ubuntu"
            echo 'downloading openvino'
            #curl http://registrationcenter-download.intel.com/akdlm/irc_nas/16345/l_openvino_toolkit_p_2020.1.023.tgz --output vino.tgz
            echo 'finished downloading'

        else
            echo'Linux Distribution not supported by OpenVINO or require some modification'
        fi
    fi

## if platform is Windows
elif [ "$p_name" == 'Windows_NT' ]
then
    echo "Windows"
fi