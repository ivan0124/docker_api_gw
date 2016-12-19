# How to test
Step1. clone project
<pre>
$ git clone https://github.com/ivan0124/docker_api_gw.git
</pre>
Step2. launch `deploy_api_gw.sh` to download and run docker images (`mqtt` and `APIGateway`).

ex: Host PC IP address: `192.168.0.1`

Step3. use `WiseSnail` connect to `APIGateway` (mqtt's IP address is Step2 host IP address)

ex: connect to Mqtt , IP address is `192.168.0.1`


# How to debug
Step1. edit `deploy_api_gw.sh` and change parameter `-itd` to `-it`.
<pre>
sudo docker run --network=$ADVANTECH_NET -itd --name $DOCKER_API_GW_CONTAINER -v $PWD/APIGateway:/home/adv/APIGateway:rw -v /usr/share/webmin/$WSN_SETTING_FOLDER:/home/adv/wsn_setting:rw -p 3000:3000 $DOCKER_API_GW_IMAGE
</pre>

Step2. re-run docker container.
<pre>
$ deploy_api_gw.sh restart
</pre>
