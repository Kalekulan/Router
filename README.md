# Router

## Setup
Install git: opkg install git  

## Cronjob
mkdir /media/Main/opt/usr/adblock && /opt/bin/git clone git://github.com/Kalekulan/Router.git /media/Main/opt/usr/adblock && bash -x /media/Main/opt/usr/adblock/AdblockScript.sh && rm -r /media/Main/opt/usr/adblock



## Router startup script
targetDir=/media/Main/opt/usr/adblock  
logPath=/opt/var/log/startupScript.log  
timestamp=$(date +'%Y%m%d-%H%M')

echo -e "$timestamp\n" >> $logPath   
mkdir $targetDir >> $logPath  
/opt/bin/git clone --progress git://github.com/Kalekulan/Router.git /media/Main/opt/usr/adblock 2>> $logPath  
bash -x $targetDir/AdblockScript.sh >> $logPath  
rm -r $targetDir  
echo "****************************************************" >> $logPath
