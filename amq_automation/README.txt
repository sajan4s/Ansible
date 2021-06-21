Cronjobs can be setup as follows:

# ActiveMQ CERT check and Restart is not up
*/2 * * * * /home/user/amq_automation/cert/amq_cert_status.sh > /dev/null 2>&1

# ActiveMQ PROD check and Restart is not up
*/2 * * * * /home/user/amq_automation/prod/amq_prod_status.sh > /dev/null 2>&1


The hostnames need to be updated in the corresponding files. Now they are mentioned as host1, host2 etc.

Created by Sajan Sebastian 
