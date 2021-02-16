# update package list and upgrade new versions of packages existing on the machine.
sudo apt update && sudo apt upgrade -y

# install Squid Proxy Server.
sudo apt install squid -y

# start and enable squid service.
sudo systemctl start squid
sudo systemctl enable squid

# install apache utils.
sudo apt install apache2-utils -y

# create a passwd file in a same dir. to squid.conf.
sudo touch /etc/squid/passwd

# change the ownership to proxy user.
sudo chown proxy /etc/squid/passwd

# clear screen
clear

# create user for proxy service.
read -p "Create new user: " PROXY_USER
if [ "$PROXY_USER" != "" ]; then
    sudo htpasswd /etc/squid/passwd "$PROXY_USER"
fi

# replace old squid.conf with new conf. file.
sudo cp squid.conf /etc/squid

# restart squid service.
sudo systemctl restart squid

# clear screen
clear

# done.
if [ "$PROXY_USER" != "" ]; then
    echo -e "\n\nInstallation Done!"
    echo -e "Now, you can use proxy with a user that you've created before.\n\n"
else
    echo -e "\n\nInstallation Done,"
    echo "But you're skipping user proxy creation."
    echo -e "To add a proxy user, type 'sudo htpasswd /etc/squid/passwd \e[92musername\e[0m'."
    echo -e "And then you're ready to go.\n\n"
fi
