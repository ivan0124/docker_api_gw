#!/bin/bash
ADVANTECH_NET=advigw_network
#mqtt
MQTT_IMAGE=advigw4x86/mqtt-bus
MQTT_CONTAINER=advigw-mqtt-bus
#api_gw
DOCKER_API_GW_IMAGE=advigw4x86/api-gw
DOCKER_API_GW_CONTAINER=advigw-api-gw
#wisesnail_lib
WISESNAIL_LIB_IMAGE=advigw4x86/wisesnail-lib
WISESNAIL_LIB_CONTAINER=advigw-wisesnail-lib-dev
#wsn_simulator
WSN_SIMULATOR_IMAGE=advigw4x86/wsn-simulator
WSN_SIMULATOR_CONTAINER=advigw-wsn-simulator


if [ "$1" == "remove_images" ]; then
echo "======================================="
echo "Remove all images......"
echo "======================================="
MQTT_IMAGE_ID=`sudo docker images | grep $MQTT_IMAGE | awk '{print $3}'`
DOCKER_API_GW_IMAGE_ID=`sudo docker images | grep $DOCKER_API_GW_IMAGE | awk '{print $3}'`
WISESNAIL_LIB_IMAGE_ID=`sudo docker images | grep $WISESNAIL_LIB_IMAGE | awk '{print $3}'`
WSN_SIMULATOR_IMAGE_ID=`sudo docker images | grep $WSN_SIMULATOR_IMAGE | awk '{print $3}'`

#stop container
sudo docker stop $WSN_SIMULATOR_CONTAINER
sudo docker stop $WISESNAIL_LIB_CONTAINER
sudo docker stop $DOCKER_API_GW_CONTAINER
sudo docker stop $MQTT_CONTAINER
#remove container
sudo docker rm $WSN_SIMULATOR_CONTAINER
sudo docker rm $WISESNAIL_LIB_CONTAINER
sudo docker rm $DOCKER_API_GW_CONTAINER
sudo docker rm $MQTT_CONTAINER

#wisesnail_lib
echo "Remove WSN_SIMULATOR_IMAGE, ID= $WSN_SIMULATOR_IMAGE"
sudo docker rmi -f $WSN_SIMULATOR_IMAGE_ID
#wisesnail_lib
echo "Remove WISESNAIL_LIB_IMAGE, ID= $WISESNAIL_LIB_IMAGE_ID"
sudo docker rmi -f $WISESNAIL_LIB_IMAGE_ID
#api_gw
echo "Remove DOCKER_API_GW_IMAGE, ID= $DOCKER_API_GW_IMAGE_ID"
sudo docker rmi -f $DOCKER_API_GW_IMAGE_ID
#mqtt
echo "Remove MQTT_IMAGE, ID= $MQTT_IMAGE_ID"
sudo docker rmi -f $MQTT_IMAGE_ID

exit 0
fi

#stop container
echo "======================================="
echo "[Stpe1]: Stop container......"
echo "======================================="
sudo docker stop $MQTT_CONTAINER
sudo docker stop $DOCKER_API_GW_CONTAINER
sudo docker stop $WISESNAIL_LIB_CONTAINER
sudo docker stop $WSN_SIMULATOR_CONTAINER

#remove container
echo "======================================="
echo "[Step2]: Remove container......"
echo "======================================="
sudo docker rm $MQTT_CONTAINER
sudo docker rm $DOCKER_API_GW_CONTAINER
sudo docker rm $WISESNAIL_LIB_CONTAINER
sudo docker rm $WSN_SIMULATOR_CONTAINER

#pull images
if [ "$1" == "restart" ] ; then
echo "======================================="
echo "[Step3]: Skip pull container images......"
echo "======================================="
else
echo "======================================="
echo "[Step3]: Pull container images......"
echo "======================================="
sudo docker pull $MQTT_IMAGE
sudo docker pull $DOCKER_API_GW_IMAGE
sudo docker pull $WISESNAIL_LIB_IMAGE
sudo docker pull $WSN_SIMULATOR_IMAGE
fi

#create user-defined network `advigw_network`
NET=`sudo docker network ls | grep $ADVANTECH_NET | awk '{ print $2}'`
if [ "$NET" != "$ADVANTECH_NET" ] ; then
echo "======================================="
echo "[Step4]: $ADVANTECH_NET does not exist, create $ADVANTECH_NET network..."
echo "======================================="
sudo docker network create -d bridge --subnet 172.25.0.0/16 $ADVANTECH_NET
else
echo "======================================="
echo "[Step4]: Found $ADVANTECH_NET network. $ADVANTECH_NET exist."
echo "======================================="

fi

#run containers
echo "======================================="
echo "[Step5]: Run container images......"
echo "======================================="
sudo docker run -d -it --name $MQTT_CONTAINER -p 1883:1883 $MQTT_IMAGE
sudo docker run -d -it --name $DOCKER_API_GW_CONTAINER -p 3000:3000 $DOCKER_API_GW_IMAGE
#
sudo docker run -d -it --name $WISESNAIL_LIB_CONTAINER -v $PWD:/home/adv/workspace:rw $WISESNAIL_LIB_IMAGE
sudo docker run -d -it --name $WSN_SIMULATOR_CONTAINER $WSN_SIMULATOR_IMAGE
#sudo docker exec -it $WISESNAIL_LIB_CONTAINER bash
#

#join to user-defined network advigw_network
echo "======================================="
echo "[Step6]: Join to network advigw_network......"
echo "======================================="
sudo docker network connect $ADVANTECH_NET $MQTT_CONTAINER
sudo docker network connect $ADVANTECH_NET $DOCKER_API_GW_CONTAINER
sudo docker network connect $ADVANTECH_NET $WISESNAIL_LIB_CONTAINER
sudo docker network connect $ADVANTECH_NET $WSN_SIMULATOR_CONTAINER

sudo docker exec -it $WISESNAIL_LIB_CONTAINER bash
