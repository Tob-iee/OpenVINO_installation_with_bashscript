#!/bin/bash
echo "Installing dependencies for people detection model"
## obtain the deployment platform
p_name=`uname`
echo $p_name
if [ "$p_name" == 'Darwin' ]
then
    #echo "I am a Mac"
    py_version=$(python -c"import sys; print(0) if sys.version_info.major < 3 and sys.version_info.minor < 5 else print(1)")
    if [ $py_version == 1 ]
    then
        echo 'installing xcode command line tool'
        xcode-select --install
        echo 'installing latest version ofcmake'
        pip3 install --upgrade cmake
        echo 'installing latest version of opencv'
        pip3 install --upgrade opencv-python
        echo 'installing latest version of numpy'
        pip3 install --upgrade numpy
        echo 'downloading openvino'
        #curl http://registrationcenter-download.intel.com/akdlm/irc_nas/16343/m_openvino_toolkit_p_2020.1.023.dmg --output vino.dmg
        echo 'finished downloading'
        # Mount the image
        hdiutil mount vino.dmg
        open -a /Volumes/m_openvino_toolkit_p_2020.1.023/m_openvino_toolkit_p_2020.1.023.app
        echo 'Setting environment variables'
        echo 'source /opt/intel/openvino/bin/setupvars.sh' >> ~/.bash_profile
        # Unmount the image
        hdiutil unmount "/Volumes/Chicken of the VNC/"
        echo 'OpenVINO toolkit installation completed'
    fi
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
elif [ "$p_name" == 'Windows_NT' ]
then
    echo "Windows"
fi