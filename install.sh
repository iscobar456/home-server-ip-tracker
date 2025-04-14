#!/bin/bash

# Check for AWS cli
while true; do

read -p "Have you configured the AWS cli? (yes/no) " yn

case $yn in 
	yes ) echo "Installing IPTracker...";
		break;;
	no ) echo exiting...;
		exit;;
	* ) echo invalid response;;
esac

done

# Install 
echo "    - copying executable script..."
sudo cp update_ip /usr/local/bin/

echo "    - copying systemd service, timer files..."
sudo cp ip_tracker.* /etc/systemd/system/

echo "    - creating state file..."
if [[ ! -f /var/lib/misc/current_ip ]]; then
	sudo touch /var/lib/misc/current_ip
fi
sudo chmod 770 /var/lib/misc/current_ip

echo "    - reloading systemd..."
sudo systemctl daemon-reload

echo "    - starting ip_tracker.timer ..."
sudo systemctl start ip_tracker.timer

echo "    - enabling ip_tracker.timer ..."
sudo systemctl enable ip_tracker.timer

echo "    - initial run..."
/usr/local/bin/update_ip

echo "Done!"
