# squid-proxy

This is an automatic script to install Squid-proxy with basic authentication for Linux Ubuntu.
This script is already tested and working in Linux Ubuntu 16.04 LTS & 18.04 LTS.

## Installation

1. Download or clone this repo.

   ```bash
   git clone https://github.com/dnwandana/squid-proxy.git
   cd squid-proxy
   ```

2. Make the file `install-squid.sh` is executable.

   ```bash
   sudo chmod +x install-squid.sh
   ```

3. Execute `install-squid.sh`

   ```bash
   sudo ./install-squid.sh
   ```

### Installation note

- You'll be prompted for first user to use the proxy-server. You can leave it blank (add user later).

- To add another user you can type :

  ```bash
  sudo htpasswd /etc/squid/passwd username
  ```

  ^ Change username to your preferred username.

## Verify the Squid service status

- To verify if the squid service is running, you can type :

  ```bash
  sudo systemctl status squid
  ```

  You should see the `active (running)` status like this.

  ```bash
  Loaded: .....
  Active: active (running) since DATE; TIME ago
  Docs: ....
  ```

- or you can check running Squid proxy port using following command :

  ```bash
  sudo netstat -ntlp
  ```

  By default, Squid runs on port `3128`. You should see the result like this.

  ```bash
  Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
  tcp6       0      0 :::3128                 :::*                    LISTEN      14768/(squid-1)
  ```

## Test Squid proxy

We're gonna test Squid proxy authentication using curl. You can use the following syntax :

```bash
curl -x [SQUID_SERVER_IP]:[SQUID_PORT] --proxy-user [USERNAME]:[USER_PASSWORD] -I [SITE]
```

For Example :

```bash
curl -x 192.168.0.100:3128 --proxy-user testuser:P@ssw0rd -I https://google.com/
```

You'll see the following results :

- Success

  ```bash
  HTTP/1.1 200 Connection established
  ```

- Authentication Error

  ```bash
  HTTP/1.1 407 Proxy Authentication Required
  .....
  .....
  Received HTTP code 407 from proxy after CONNECT
  ```

  That's it now you're ready to go to use Squid proxy for any reason!

## Reference

- [Squid Example Config](https://wiki.squid-cache.org/ConfigExamples "Squid Example Config")
- [curl Tutorial](https://curl.haxx.se/docs/httpscripting.html "curl Tutorial")
