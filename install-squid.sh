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

# create user for proxy service.
read -p "Create new user: " PROXY_USER
if [[ $PROXY_USER != "" ]]
then
    sudo htpasswd /etc/squid/passwd $PROXY_USER
fi

# replace old squid.conf with new conf. file.
sudo cp squid.conf /etc/squid

# restart squid service.
sudo systemctl restart squid

# done.
if [[ $PROXY_USER != "" ]]
then
    echo "Installation Done!"
    echo "now, you can use proxy with user that you've created before."
else
    echo "Installation Done,"
    echo "But You're skipping user proxy creation."
    echo -e "type 'sudo htpasswd /etc/squid/passwd \e[92musername\e[0m'."
    echo "and then you're ready to go."
fi
