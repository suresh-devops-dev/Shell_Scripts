echo ""
#echo -e "\033[1mForeman CLI...Initialization.\033 \033[0m";
echo -e "\033[0;33mForeman CLI...Initialization. \033[0m";
echo ""
echo "Choose any of the options to proceed :-"
echo ""
echo "1. Create New Host."
echo ""
echo "2. Delete Existing Hosts."
echo ""
echo -n "Select your choice [1 | or | 2]?"
read version
if [ $version = 1 ]
then
echo "Enter the hostname:"
read hostname
USER="admin"
PASS="redhat"
echo ""
hammer -u admin -p redhat hostgroup list
echo -e "\nPlease enter the host id: "
read hostid
hammer -u $USER -p $PASS  host create --name $hostname  --compute-resource-id=2 --hostgroup-id=$hostid

hammer -u $USER -p $PASS host start --name $hostname.testlab.local


elif [ $version = 2 ]
then
echo -e "\n\t\t\t\t\t===========Hosted vm's list=========="
echo ""
hammer -u admin -p redhat host list
echo  ""
echo -e "Please enter the host id: "
read hostid
hammer -u admin -p redhat host delete --id $hostid
fi
