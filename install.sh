#!/bin/bash

cd

clear
# declare STRING variable
STRING1="Make sure you double check before pressing enter! One chance at this only!"
STRING2="If you found this useful, please consider a small donation to DIN Donation: "
STRING3="DH2EYCRPeLrMqGNiEoDEh14dnNKxzRYE5C"
STRING4="Updating system and installing required packages."
STRING5="Switching to Aptitude"
STRING6="Some optional installs"
STRING7="Starting your masternode"
STRING8="Now, you need to finally start your masternode in the following order:"
STRING9="Go to your windows/mac wallet and modify masternode.conf as required, then restart and from the Control wallet debug console please enter"
STRING10="masternode start-alias <mymnalias>"
STRING11="where <mymnalias> is the name of your masternode alias (without brackets)"
STRING12="once completed please return to VPS and press the space bar"
STRING13=""

#print variable on a screen
echo $STRING1 

    read -e -p "Server IP Address : " ip
    read -e -p "Masternode Private Key (e.g. 7sQ27dGdwwEGrAPHmfghBBfWZnC6K1rDATNvm986dDfsaw3Wws4 # THE KEY YOU GENERATED EARLIER) : " key
    read -e -p "Install Fail2ban? [Y/N] : " install_fail2ban
    read -e -p "Install UFW and configure ports? [Y/N] : " UFW

    clear
 echo $STRING2
 echo $STRING13
 echo $STRING3 
 echo $STRING13
 echo $STRING4    
    sleep 10    

# update package and upgrade Ubuntu
    sudo apt-get -y update
    sudo apt-get -y upgrade
    sudo apt-get -y autoremove
    sudo apt-get install wget nano htop -y
    clear
echo $STRING5
    sudo apt-get -y install aptitude

#Generating Random Passwords
    password=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
    password2=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`

echo $STRING6
    if [[ ("$install_fail2ban" == "y" || "$install_fail2ban" == "Y" || "$install_fail2ban" == "") ]]; then
    cd ~
    sudo aptitude -y install fail2ban
    sudo service fail2ban restart 
    fi
    if [[ ("$UFW" == "y" || "$UFW" == "Y" || "$UFW" == "") ]]; then
    sudo apt-get install ufw
    sudo ufw default allow outgoing
    sudo ufw allow 26285/tcp comment DIN
    sudo ufw enable -y
    fi


#Create dinero.conf

sudo mkdir .dinerocore
echo '
rpcuser='$password'
rpcpassword='$password2'
rpcallowip=127.0.0.1
listen=1
server=1
disablewallet=1
daemon=1
maxconnections=256
masternode=1
masternodeprivkey='$key'
externalip='$ip'
addnode=85.10.199.135
addnode=167.86.85.58
addnode=206.189.177.158
addnode=51.38.57.53
addnode=195.201.160.242
addnode=128.199.84.231
addnode=178.254.12.231
addnode=45.77.5.181
addnode=138.201.196.245
addnode=85.121.197.59
addnode=85.121.197.49
addnode=85.121.197.56
addnode=85.121.197.58
addnode=85.121.197.53
addnode=85.121.197.60
addnode=85.121.197.55
addnode=85.121.197.52
addnode=85.121.197.50
addnode=85.121.197.51
addnode=85.121.197.54
addnode=85.121.197.57
addnode=144.126.148.238
addnode=8.9.5.109
addnode=82.66.94.6
addnode=192.248.161.144
addnode=66.70.182.1
addnode=216.238.69.27
addnode=149.56.155.28
addnode=155.138.244.229
addnode=23.88.58.86
addnode=83.233.2.113
addnode=70.91.250.149
addnode=91.17.211.12
addnode=72.68.67.27
addnode=81.166.148.242
addnode=80.254.127.139
addnode=24.178.44.106
addnode=84.234.52.190
addnode=54.202.155.174
addnode=88.198.170.29
addnode=94.27.226.106
addnode=50.220.121.211
addnode=24.212.138.118
addnode=84.139.102.214
addnode=192.228.154.188
addnode=69.21.232.207


' | sudo -E tee ~/.dinerocore/dinero.conf >/dev/null 2>&1
    sudo chmod 0600 ~/.dinerocore/dinero.conf

echo 'dinero.conf created'


sleep 40

    clear
 echo $STRING2
 echo $STRING13
 echo $STRING3 
 echo $STRING13
 echo $STRING4    


#Install Dinero Daemon
    wget https://github.com/dinerocoin/dinero/releases/download/v1.0.1.1/dinerocore-1.0.1.1-linux64.tar.gz
    sudo tar -xzvf dinerocore-1.0.1.1-linux64.tar.gz
    sudo rm dinerocore-1.0.1.1-linux64.tar.gz
    dinerocore-1.0.1/bin/dinerod -daemon
    clear
 
 sleep 10

#Setting up coin
    clear
echo $STRING2
echo $STRING13
echo $STRING3
echo $STRING13
echo $STRING4
sleep 10

#Install Sentinel
cd /root/.dinerocore
sudo apt-get install -y git python-virtualenv
sudo git clone https://github.com/dinerocoin/sentinel.git
cd sentinel
export LC_ALL=C
sudo apt-get install -y virtualenv
virtualenv venv
venv/bin/pip install -r requirements.txt

cd

dinerocore-1.0.1/bin/dinerod -daemon
dinerocore-1.0.1/bin/dinero-cli stop
#Starting coin
    (crontab -l 2>/dev/null; echo '@reboot sleep 30 && cd /root/dinerocore-1.0.1/bin/dinerod -daemon -shrinkdebugfile') | crontab
    (crontab -l 2>/dev/null; echo '* * * * * cd /root/.dinerocore/sentinel && ./venv/bin/python bin/sentinel.py >/$') | crontab


    clear
echo $STRING2
echo $STRING13
echo $STRING3
echo $STRING13
echo $STRING4
    sleep 10
echo $STRING7
echo $STRING13
echo $STRING8 
echo $STRING13
echo $STRING9 
echo $STRING13
echo $STRING10
echo $STRING13
echo $STRING11
echo $STRING13
echo $STRING12
    sleep 120

cd
    clear
 echo $STRING2
 echo $STRING13
 echo $STRING3 
 echo $STRING13
 echo $STRING4    

read -p "(this message will remain for at least 120 seconds) Then press any key to continue... " -n1 -s
dinerocore-1.0.1/bin/dinero-cli stop

#Download Bootstrap 
cd ~/.dinerocore/
wget https://github.com/locololo123/blocks/releases/download/bootstrap_cryptos2/blocksDIN-080922.zip && unzip blocksDIN-080922.zip && rm -r blocksDIN-080922.zip
cd..
echo 'bootstrap date 080922' 
