# Manual Installation Squid-proxy

This page will help you to manual install Squid-proxy with Basic authentication in Linux Ubuntu. This script is already tested and working in Linux Ubuntu 16.04 LTS & 18.04 LTS with Squid Cache: Version 3.5.12.

Before you follow the instruction below, you can see my Simple Squid Configuration with Basic Authentication [here](squid.conf "Simple Squid Configuration with Basic Authentication").

## Basic Installation

1. First thing we need to do is update package list and upgrade new versions of existing packages on the machine.

   ```bash
   sudo apt update && sudo apt upgrade -y

   ```

2. Then we install Squid service.

   ```bash
   sudo apt install squid -y

   ```

3. After the installation is finished, we need to start and enable Squid service.

   ```bash
   sudo systemctl start squid
   sudo systemctl enable squid
   ```

## Verify The Squid Service Status

To verify if the squid service is running, you execute following command :

```bash
sudo systemctl status squid
```

You should see the `active (running)` status like this.

```bash
Loaded: .....
Active: active (running) since DATE; TIME ago
Docs: ....
```

By default, Squid service is running on port `3128`. But you can change Squid port inside Squid configuration.

```bash
sudo nano \etc\squid\squid.conf
```

Search for `http_port 3128`, and then change to custom port that you want. If you change the default Squid port, dont forget to restart the service, using following command :

```bash
sudo systemctl restart squid
```

and then, to make sure Squid service is running on port `3128` or your custom Squid port, you check using the following command :

```bash
sudo netstat -ntlp | grep :[PORT]
```

Example to check if there is a running service on port `3128` :

```bash
sudo netstat -ntlp | grep :3128
```

You should see the result like this.

```bash
tcp6       0      0 :::3128                 :::*                    LISTEN      108936/(squid-1)
```

## Enable Squid ACL for Internet Connectivity

By default, all the incoming connection to the proxy server will be denied. We need to change a few Squid configurations, so the server can accept connections from other hosts.

Open the Squid configuration file.

```bash
sudo nano \etc\squid\squid.conf
```

Search for `http_access allow localnet`. By default, it should be commented out. Uncomment it.
still in the Squid configuration file. We need to add ACL for localnet using the following format :

```bash
acl localnet src [SOURCE-IP-RANGE]
```

Example, you can whitelist the source IP ranges in the following ways :

- Single IP Source : [192.168.0.10]
- Range of IP Source : [192.168.0.1-192.168.0.255]

This is my ACL configuration.

```bash
acl localnet src 0.0.0.1-0.255.255.255
```

Save the file, and dont forget to restart the service.

```bash
sudo systemctl restart squid
```

## Test Squid Proxy

We're gonna test Squid proxy authentication using curl. You can use the following command :

```bash
curl -x [SQUID_SERVER_IP]:[SQUID_PORT] -I [SITE]
```

For Example :

```bash
curl -x 192.168.0.100:3128 -I https://google.com/
```

You'll see the following result :

```bash
HTTP/1.1 200 Connection established
```

## Setup Squid With Basic Authentication

The previous method would allow anonymous proxy usage. To prevent this, we can set up basic authentication using a username and password.

1. First we need to install apache-utils.

   ```bash
   sudo apt install apache2-utils -y

   ```

2. Create a passwd file and change the ownership to proxy user.

   ```bash
   sudo touch /etc/squid/passwd
   sudo chown proxy /etc/squid/passwd

   ```

3. Next we need to create user using the following command, change `PROXY_USER` to your prefer username. Then you will be prompt for a password. Provide a secure password.

   ```bash
   sudo htpasswd /etc/squid/passwd [PROXY_USER]
   ```

4. Open and modify Squid configuration file.

   ```bash
   sudo nano /etc/squid/squid.conf
   ```

5. Search for `auth_param basic program` uncomment it and then put the following Squid configuration.

   ```bash
   auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwd
   auth_param basic children 5
   auth_param basic realm Squid Basic Authentication
   auth_param basic credentialsttl 2 hours
   acl auth_users proxy_auth REQUIRED
   ```

6. Save the file and restart Squid service.

   ```bash
   sudo systemctl restart squid
   ```

## Test Squid Proxy with Basic Authentication

We're gonna test Squid proxy authentication using curl. You can use the following command :

```bash
curl -x [SQUID_SERVER_IP]:[SQUID_PORT] --proxy-user [USERNAME]:[USER_PASSWORD] -I [SITE]
```

For Example :

```bash
curl -x 192.168.0.100:3128 --proxy-user testuser:P@ssw0rd -I https://google.com/
```

You'll see the authentication error if the authentication details are not passed properly.

```bash
HTTP/1.1 407 Proxy Authentication Required
.....
.....
Received HTTP code 407 from proxy after CONNECT
```

Otherwise, you'll see the following result :

```bash
HTTP/1.1 200 Connection established
```

That's it now you're ready to go to use Squid proxy for any reason!

## Reference

- [Squid configuration directive http_access](http://www.squid-cache.org/Doc/config/http_access/)
- [Squid configuration directive acl](http://www.squid-cache.org/Doc/config/acl/)
- [Squid configuration directive auth_param](http://www.squid-cache.org/Doc/config/auth_param/)
- [curl Tutorial](https://curl.haxx.se/docs/httpscripting.html)
