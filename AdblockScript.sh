parentPath=/media/Main/opt/usr/adblock
path=/media/Main/opt/usr/adblock/Router-dev
zipPath=/media/Main/opt/usr/adblock/dev.zip
hostPath=$path/adblock_hosts.txt
i=1
exclusionListPath=$path/domainExclusions.txt
additionListPath=$path/domainAdditions.txt
retry=1
#mkdir $parentPath

wget --timeout=10 https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts -O $hostPath
#wget --timeout=10 https://raw.githubusercontent.com/Kalekulan/Router/dev/domainExclusions.txt -O $exclusionListPath
#wget --timeout=10 https://raw.githubusercontent.com/Kalekulan/Router/dev/domainAdditions.txt -O $additionListPath


while (( ps | grep -v "grep" | grep -qF "dnsmasq" 2>/dev/null )) || (( $retry -le 3 ))
do
        killall dnsmasq
        sleep 2
        echo Trying to kill dnsmasq... Attempt $retry
        ((retry=retry+1))
done
echo dnsmasq killed!

#dos2unix $path/adblock_hosts.txt
#cp /etc/storage/dnsmasq/hosts $path/original_hosts.txt


numLines=$(wc -l < $exclusionListPath)
#numLines=4
#hostFile=/var/test/hosts.txt

#for (( i=1; i<=$numLines; i++ ))
#for (( i=2; i <= 10; ++i ))
STATE=0

while [ $i -le $numLines ] #Loop through every line in domainExclusions.list
do
        case $STATE in
        0) #Read domain to comment
                #echo i=$i
                echo =========
                lineRead=$(sed "${i}q;d" $exclusionListPath) #Read line i in domainExclusions.list
                echo Domain to exclude: "$lineRead"
                #echo lineRead=$lineRead
                if [ ${#lineRead} -le 3 ]
                then
                        echo Domain read was empty. Skipping...
                        #i=$((i+1))
                        STATE=3
                else
                        #echo 1 > $STATE
                        STATE=$((STATE+1))

                fi
                ;;
        1) #Find read domain in hosts file
                patternHosts=$(grep -i -F "$lineRead" $hostPath) #use "-m 1" to only take first pattern
                #echo patternHosts=$patternHosts
                if [ ${#patternHosts} -le 3 ]
                # || [ "$patternHosts" != "$lineRead" ]
                then
                        echo Domain not found in hosts file. Skipping...
                        #i=$((i+1))
                        STATE=3
                else
                        echo Domain pattern found in hosts file!
                        #echo 2 > $STATE
                        STATE=$((STATE+1))
                fi
                ;;
        2) #Comment domain in hosts file
                #lineComment=$(echo grep "^[^#;]" "$lineRead") #Check to see if text on line i is commented.

                #echo lineComment=$lineComment
                #if $lineComment ! "#" #if not commented, then add comment

                if ! [[ "$patternHosts" = '\#*' ]]
                then
                        echo Comment not found. Commenting...
                        #sed -e 's/^/#/' $hostPath
                        #sed -i '/$lineRead/s/^/#/' $hostPath
                        #sed -i '$i s/^/#/' $hostFile
                        #awk '/$lineRead/ {$0="#"$0}1' $hostPath
                        #sed '/LogMsg/ s?^?//?' filename  new_filename
                        sed -i "s/$lineRead/#&/" $hostPath
                fi

                STATE=$((STATE+1))
                ;;
        3) #Restart case loop
                STATE=0
                i=$((i+1))
        esac

        #unset lineComment
        #STATE=0
        #i=$((i+1))
done


cat $additionListPath > /etc/storage/dnsmasq/hosts
cat $hostPath >> /etc/storage/dnsmasq/hosts

ln -s /etc/hosts /etc/storage/dnsmasq/hosts

#rm /etc/storage/dnsmasq/hosts
#ln -s /etc/hosts /etc/storage/dnsmasq/hosts

##ln -s /etc/storage/dnsmasq/hosts $hostPath

rm -r $parentPath
#rm -r $path
#rm $zipPath
retry=1
while ! (( ps | grep -v "grep" | grep -qF "dnsmasq" 2>/dev/null )) || (( $retry -le 3 ))
do
        dnsmasq
        sleep 2
        echo Trying to start dnsmasq... Attempt $retry
        ((retry=retry+1))
done
echo dnsmasq started!
#dnsmasq
# **************** ADBLOCK ****************
