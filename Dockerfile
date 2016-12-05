FROM ubuntu:16.04

#MAINTAINER Advantech

#update and install npm
RUN apt-get update
RUN apt-get install -y npm

#tools
RUN apt-get install -y vim
RUN apt-get install -y sudo git

# Install nodejs and npm node-red
RUN apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
RUN apt-get install -y nodejs

# adv account
RUN useradd -m -k /home/adv adv -p adv -s /bin/bash -G sudo

# set up adv as sudo
RUN echo "adv ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
WORKDIR /home/adv

# install APIGateway
RUN git clone https://github.com/ADVANTECH-Corp/APIGateway.git /home/adv/api_gw
RUN cp api_gw/script/init_wsn_setting.sh /usr/local/bin/.

USER adv

#Share folder with host
RUN mkdir /home/adv/APIGateway
VOLUME /home/adv/APIGateway

RUN mkdir /home/adv/wsn_setting
VOLUME /home/adv/wsn_setting

RUN mkdir /home/adv/wsn_setting/device_table
#VOLUME /home/adv/wsn_setting/device_table

RUN mkdir /home/adv/wsn_setting/device_html
#VOLUME /home/adv/wsn_setting/device_html

# Run api-gw
ENTRYPOINT ["init_wsn_setting.sh"]
