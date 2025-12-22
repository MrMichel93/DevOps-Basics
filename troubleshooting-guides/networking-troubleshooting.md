# Networking Troubleshooting Guide

## Issue Categories

### Cannot Reach Host/Server

**Symptoms:**

- Ping fails
- Connection timeout
- Host unreachable
- No route to host

**Diagnostic Steps:**

1. **Test basic connectivity**
   ```bash
   ping 8.8.8.8           # Test internet connectivity
   ping google.com        # Test DNS + connectivity
   ping 192.168.1.1       # Test local network
   ```

2. **Check network interface**
   ```bash
   ip addr show           # Or ifconfig
   ip link show           # Check if interface is up
   ```

3. **Test routing**
   ```bash
   ip route show          # View routing table
   traceroute google.com  # Trace route to destination
   mtr google.com         # Real-time traceroute
   ```

**Common Causes & Solutions:**

#### Cause 1: No internet connection

**Solution:**

```bash
# Check if interface is up
ip link show

# Bring interface up if down
sudo ip link set eth0 up

# Restart network service
sudo systemctl restart NetworkManager     # Desktop
sudo systemctl restart networking         # Server

# Check cable/WiFi connection
# Verify router/modem is working
```

#### Cause 2: DNS not working

**Error message:**
```
ping: google.com: Name or service not known
```

**But this works:**
```
ping 8.8.8.8
PING 8.8.8.8: 56 data bytes
64 bytes from 8.8.8.8: icmp_seq=0 ttl=117 time=14.1 ms
```

**Solution:**

```bash
# Check DNS configuration
cat /etc/resolv.conf

# Add reliable DNS servers
sudo nano /etc/resolv.conf
# Add:
nameserver 8.8.8.8
nameserver 8.8.4.4

# Or use systemd-resolved
sudo nano /etc/systemd/resolved.conf
# Set: DNS=8.8.8.8 8.8.4.4
sudo systemctl restart systemd-resolved

# Test DNS resolution
nslookup google.com
dig google.com
```

#### Cause 3: Firewall blocking

**Solution:**

```bash
# Check firewall status
sudo ufw status                    # Ubuntu
sudo firewall-cmd --list-all      # CentOS/RHEL
sudo iptables -L -n               # All Linux

# Allow specific service
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow from 192.168.1.0/24

# Temporarily disable to test (not recommended for production)
sudo ufw disable
```

#### Cause 4: Wrong network configuration

**Solution:**

```bash
# Check current IP configuration
ip addr show

# Check if you have IP address
# Should see: inet 192.168.1.100/24

# Request DHCP address
sudo dhclient -r  # Release
sudo dhclient     # Renew

# Or configure static IP
sudo nano /etc/netplan/01-netcfg.yaml  # Ubuntu
# Example:
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: no
      addresses: [192.168.1.100/24]
      gateway4: 192.168.1.1
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]

sudo netplan apply
```

---

### Port Not Accessible

**Symptoms:**

- Connection refused
- Connection timeout on specific port
- Service running but can't connect

**Diagnostic Steps:**

1. **Check if port is listening**
   ```bash
   sudo netstat -tulpn | grep :80
   sudo ss -tulpn | grep :80
   sudo lsof -i :80
   ```

2. **Test port connectivity**
   ```bash
   telnet localhost 80
   nc -zv localhost 80
   curl -v localhost:80
   ```

3. **Check from remote**
   ```bash
   telnet server.example.com 80
   nc -zv server.example.com 80
   nmap server.example.com -p 80
   ```

**Common Causes & Solutions:**

#### Cause 1: Service not listening on correct interface

**Problem:**
Service only listening on 127.0.0.1 (localhost), not 0.0.0.0 (all interfaces).

**Check:**
```bash
sudo netstat -tulpn | grep :8000

# Bad: Only localhost
tcp   0   0 127.0.0.1:8000   0.0.0.0:*   LISTEN

# Good: All interfaces
tcp   0   0 0.0.0.0:8000     0.0.0.0:*   LISTEN
```

**Solution:**

Configure application to bind to 0.0.0.0:

```python
# Python Flask
app.run(host='0.0.0.0', port=8000)  # Not '127.0.0.1'
```

```javascript
// Node.js
app.listen(8000, '0.0.0.0');  // Not 'localhost'
```

#### Cause 2: Firewall blocking port

**Solution:**

```bash
# Allow port in firewall
sudo ufw allow 8000/tcp

# For specific source
sudo ufw allow from 192.168.1.0/24 to any port 8000

# Check if rule was added
sudo ufw status numbered

# For cloud providers, check security groups
# AWS: EC2 → Security Groups → Inbound Rules
# Azure: Network Security Groups
# GCP: VPC Firewall Rules
```

#### Cause 3: Port already in use

**Solution:**

```bash
# Find what's using the port
sudo lsof -i :8000
# Or
sudo netstat -tulpn | grep :8000

# Kill the process (carefully!)
sudo kill <PID>

# Or use different port
# Change application configuration to use 8001
```

#### Cause 4: SELinux blocking (Red Hat/CentOS)

**Solution:**

```bash
# Check SELinux status
getenforce

# Allow port in SELinux
sudo semanage port -a -t http_port_t -p tcp 8000

# Or temporarily disable (not for production)
sudo setenforce 0
```

---

### DNS Issues

**Symptoms:**

- Cannot resolve domain names
- Slow DNS resolution
- Intermittent name resolution failures

**Diagnostic Steps:**

1. **Test DNS resolution**
   ```bash
   nslookup google.com
   dig google.com
   host google.com
   ```

2. **Check DNS servers**
   ```bash
   cat /etc/resolv.conf
   systemd-resolve --status  # systemd systems
   ```

3. **Test different DNS servers**
   ```bash
   nslookup google.com 8.8.8.8
   dig @8.8.8.8 google.com
   ```

**Common Causes & Solutions:**

#### Cause 1: DNS server not responding

**Solution:**

```bash
# Test current DNS servers
for server in $(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'); do
  echo "Testing $server"
  dig @$server google.com +time=2
done

# Switch to public DNS
# Edit /etc/resolv.conf
nameserver 8.8.8.8       # Google
nameserver 8.8.4.4       # Google
nameserver 1.1.1.1       # Cloudflare
nameserver 208.67.222.222 # OpenDNS
```

#### Cause 2: DNS cache issues

**Solution:**

```bash
# Clear DNS cache (systemd-resolved)
sudo systemd-resolve --flush-caches

# Or restart resolver
sudo systemctl restart systemd-resolved

# macOS
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder

# Windows
ipconfig /flushdns
```

#### Cause 3: DNS propagation delay

**What it means:**
DNS changes can take 24-48 hours to propagate globally.

**Solution:**

```bash
# Check DNS from different locations
# Use online tools:
# - https://www.whatsmydns.net/
# - https://dnschecker.org/

# Use local DNS temporarily
# Edit /etc/hosts
192.168.1.100  myapp.local
```

---

### Slow Network Performance

**Symptoms:**

- High latency
- Slow downloads/uploads
- Timeouts

**Diagnostic Steps:**

1. **Measure latency**
   ```bash
   ping -c 10 8.8.8.8
   mtr google.com  # Continuous monitoring
   ```

2. **Test bandwidth**
   ```bash
   # Install speedtest-cli
   pip install speedtest-cli
   speedtest-cli

   # Or use iperf for LAN testing
   # On server:
   iperf -s
   # On client:
   iperf -c server-ip
   ```

3. **Check for packet loss**
   ```bash
   ping -c 100 8.8.8.8 | grep "packet loss"
   mtr --report google.com
   ```

**Common Causes & Solutions:**

#### Cause 1: Network congestion

**Solution:**

```bash
# Check current bandwidth usage
iftop           # Interactive
vnstat -l       # Monitor live traffic
nethogs         # Per-process bandwidth

# Limit bandwidth for specific application
# Using tc (traffic control)
sudo tc qdisc add dev eth0 root tbf rate 1mbit burst 32kbit latency 400ms
```

#### Cause 2: WiFi signal issues

**Solution:**

```bash
# Check WiFi signal strength
iwconfig
nmcli dev wifi list

# Switch to 5GHz if available
# Move closer to access point
# Reduce interference (change channel)
# Use wired connection if possible
```

#### Cause 3: DNS resolution slow

**Solution:**

```bash
# Measure DNS resolution time
time nslookup google.com

# Use faster DNS servers
# Edit /etc/resolv.conf
nameserver 1.1.1.1  # Cloudflare (often fastest)
nameserver 8.8.8.8  # Google
```

---

### SSL/TLS Certificate Errors

**Symptoms:**

- Certificate verification failed
- Certificate expired
- Hostname mismatch
- Self-signed certificate errors

**Diagnostic Steps:**

1. **Check certificate details**
   ```bash
   openssl s_client -connect example.com:443 -servername example.com
   
   # View certificate dates
   openssl s_client -connect example.com:443 2>/dev/null | \
     openssl x509 -noout -dates
   ```

2. **Verify certificate chain**
   ```bash
   openssl s_client -connect example.com:443 -showcerts
   ```

**Common Causes & Solutions:**

#### Cause 1: Expired certificate

**Solution:**

Server-side (renew certificate):
```bash
# For Let's Encrypt
sudo certbot renew

# Check expiration
sudo certbot certificates
```

Client-side (update CA bundle):
```bash
# Update certificates
sudo apt-get update
sudo apt-get install ca-certificates

# Or download latest CA bundle
curl -o cacert.pem https://curl.se/ca/cacert.pem
```

#### Cause 2: Self-signed certificate

**Solution:**

Development (accept self-signed):
```bash
# curl - skip verification
curl -k https://example.com

# wget
wget --no-check-certificate https://example.com
```

Production (add to trust store):
```bash
# Add certificate to system trust store
sudo cp cert.crt /usr/local/share/ca-certificates/
sudo update-ca-certificates
```

#### Cause 3: Hostname mismatch

**Error:**
```
SSL: certificate subject name 'example.com' does not match 
target host name 'www.example.com'
```

**Solution:**

- Use correct hostname in URL
- Or get certificate with correct SANs (Subject Alternative Names)

---

### Port Forwarding/NAT Issues

**Symptoms:**

- Can't access service from external network
- Works locally but not from internet
- Connection refused from outside

**Diagnostic Steps:**

1. **Verify local access works**
   ```bash
   curl localhost:8000
   ```

2. **Check public IP**
   ```bash
   curl ifconfig.me
   curl icanhazip.com
   ```

3. **Test from external source**
   ```bash
   # Use online port checker
   # https://www.yougetsignal.com/tools/open-ports/
   ```

**Common Causes & Solutions:**

#### Cause 1: Router not forwarding port

**Solution:**

1. Access router admin panel (usually 192.168.1.1)
2. Find Port Forwarding section
3. Add rule:
   - External Port: 8000
   - Internal IP: 192.168.1.100
   - Internal Port: 8000
   - Protocol: TCP

#### Cause 2: Using private IP

**Solution:**

```bash
# Check if IP is private
ip addr show

# Private ranges:
# 10.0.0.0 - 10.255.255.255
# 172.16.0.0 - 172.31.255.255
# 192.168.0.0 - 192.168.255.255

# If private, you need:
# - Port forwarding on router
# - Or VPN
# - Or reverse proxy/tunnel (ngrok, CloudFlare Tunnel)

# Quick solution for testing - ngrok
ngrok http 8000
# Provides public URL
```

#### Cause 3: ISP blocking port

**Solution:**

```bash
# Common blocked ports: 80, 25, 443
# Test if ISP is blocking:

# Use different port (e.g., 8080 instead of 80)
# Or use VPN
# Or use cloud hosting
```

---

## Network Diagnostic Tools

### Essential Commands

```bash
# Connectivity
ping <host>              # Test basic connectivity
traceroute <host>        # Trace route to host
mtr <host>               # Real-time traceroute

# DNS
nslookup <domain>        # Query DNS
dig <domain>             # Detailed DNS query
host <domain>            # Simple DNS lookup

# Port Testing
telnet <host> <port>     # Test port connectivity
nc -zv <host> <port>     # Netcat port test
nmap <host>              # Port scanner

# Network Info
ip addr show             # Show IP addresses
ip route show            # Show routing table
ip link show             # Show network interfaces

# Listening Ports
netstat -tulpn           # Show listening ports
ss -tulpn                # Modern alternative to netstat
lsof -i                  # Show network connections

# Traffic Monitoring
iftop                    # Bandwidth usage by connection
nethogs                  # Bandwidth by process
tcpdump                  # Packet capture
wireshark                # GUI packet analyzer

# Performance
iperf                    # Bandwidth testing
speedtest-cli            # Internet speed test
```

### Advanced Troubleshooting

```bash
# Capture packets
sudo tcpdump -i eth0 port 80 -w capture.pcap

# Analyze packets
tcpdump -r capture.pcap
wireshark capture.pcap

# Test HTTP specifically
curl -v http://example.com
curl -I http://example.com  # Headers only

# Test HTTPS/TLS
openssl s_client -connect example.com:443

# Monitor network in real-time
watch -n 1 'netstat -i'
```

## Quick Diagnosis Checklist

When network issues occur:

- [ ] Can you ping 8.8.8.8? (Internet connectivity)
- [ ] Can you ping google.com? (DNS working)
- [ ] Can you ping local gateway? (Local network)
- [ ] Is the service running? (ps, systemctl status)
- [ ] Is the port listening? (netstat, lsof)
- [ ] Can you connect locally? (telnet localhost port)
- [ ] Can you connect remotely? (telnet host port)
- [ ] Is firewall allowing traffic? (ufw, iptables)
- [ ] Are there any errors in logs? (journalctl, /var/log)

## Prevention Tips

1. **Document network configuration**
   - IP addresses
   - DNS servers
   - Firewall rules
   - Port mappings

2. **Monitor network health**
   ```bash
   # Set up monitoring
   # Check regularly for:
   # - Bandwidth usage
   # - Packet loss
   # - Latency
   # - Connection errors
   ```

3. **Keep systems updated**
   ```bash
   sudo apt-get update
   sudo apt-get upgrade
   ```

4. **Use reliable DNS**
   - Primary: 1.1.1.1 (Cloudflare)
   - Secondary: 8.8.8.8 (Google)

5. **Test after changes**
   - Always verify connectivity after network changes
   - Test from multiple locations
   - Check both IPv4 and IPv6

## When to Ask for Help

If you've tried these steps and still stuck:

1. Check network provider status
2. Verify hardware (cables, router, modem)
3. Test with different device
4. Contact ISP if external connectivity issue
5. Consult network administrator if corporate network

When asking for help, provide:
- Network topology
- IP addresses (public and private)
- Firewall rules
- Output of diagnostic commands
- Error messages
- What you've already tried
