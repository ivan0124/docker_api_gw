# How to test
Step1. clone project
<pre>
$ git clone https://github.com/ivan0124/docker_api_gw.git
</pre>

Step2. enter `docker_api_gw` directory and clone APIGateway source code
<pre>
$ cd docker_api_gw
$ git clone https://github.com/ADVANTECH-Corp/APIGateway.git
</pre>

Step3. enter `docker_api_gw/APIGateway/apps/wsn_manage` to edit `wisesnail_msgmgr.js` like below
<pre>
//var Client  = Mqtt.connect('mqtt://advigw-mqtt-bus');
var Client  = Mqtt.connect('mqtt://mqtt.advigw_network');
</pre>

Step4. launch `deploy_api_gw.sh` to download and run docker images (`mqtt` and `APIGateway`).

ex: Host PC IP address: `192.168.0.1`
<pre>
$ deploy_api_gw.sh
</pre>

Step5. use `WiseSnail` connect to `APIGateway` (mqtt's IP address is Step2 host IP address)

ex: connect to Mqtt , IP address is `192.168.0.1`

Step6. login to  `Webmin` server and use GET/PUT RESTful API


# How to develope and update APIGateway
Step1. enter `docker_api_gw` directory and clone APIGateway source code
<pre>
$ cd docker_api_gw
$ git clone https://github.com/ADVANTECH-Corp/APIGateway.git
</pre>

Step2. edit `deploy_api_gw.sh` and change parameter `-itd` to `-it`.
<pre>
sudo docker run --network=$ADVANTECH_NET -itd --name $DOCKER_API_GW_CONTAINER -v $PWD/APIGateway:/home/adv/APIGateway:rw -v /usr/share/webmin/$WSN_SETTING_FOLDER:/home/adv/wsn_setting:rw -p 3000:3000 $DOCKER_API_GW_IMAGE
</pre>

Step3. re-run docker container.
<pre>
$ deploy_api_gw.sh restart
</pre>
