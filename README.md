# Router

## Setup
Install git: opkg install git  

## Cronjob
targetDir=/media/Main/opt/usr/adblock  
logPath=/opt/var/log/startupScript.log  

00 04 * * 2 echo $(date +'%Y%m%d-%h%m-%H%M') >> $logPath && mkdir $targetDir > $logPath && /opt/bin/git clone --progress   git://github.com/Kalekulan/Router.git /media/Main/opt/usr/adblock 2> $logPath && bash -x $targetDir/AdblockScript.sh >> $logPath   && rm -r $targetDir && echo **************************** >> $logPath  

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
