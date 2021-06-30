#set -x
port=8161

nc -z host1 $port
tc_1=$?
nc -z host2 $port
tc_2=$?
nc -z host3 $port
tc_3=$?

# Section to find the current master and store in the file master.txt
# master.txt file wil be overwritten with current master during each run

cd /home/user/amq_automation/cert/

if [[ $tc_1 -eq 0 ]]
then
   nc -z host1 $port | awk '{ print $3 }'  > master.txt
elif [[ $tc_2 -eq 0 ]]
then
   nc -z host2 $port | awk '{ print $3 }'  > master.txt
elif [[ $tc_3 -eq 0 ]]
then
   nc -z host3 $port | awk '{ print $3 }'  > master.txt
else
   echo 'No master'
fi

m=`cat master.txt`

# Section for AMQ status check
# If AMQ is down, AMQ is restarted using amq_restart.yml playbook

if [[ $tc_1 -eq 1 ]] && [[ $tc_2 -eq 1 ]] && [[ $tc_3 -eq 1 ]]
then
  echo 'Cert ActiveMQ has no master'
  echo 'Restarting slaves'
  grep -v $m activemq_cert_inventory.txt > new_inventory.txt

  ansible-playbook -i new_inventory.txt ../amq_restart.yml
  sleep 10

  echo 'Restarting master'
  ansible-playbook -i master.txt ../amq_restart.yml
  echo 'CERT ActiveMQ has been restarted' | mailx -E -r "NAME <From Email address>" -s "CERT ActiveMQ has been restarted" emailaddress
  exit 1
else
  echo 'CERT AMQ is up'
fi
exit 0

