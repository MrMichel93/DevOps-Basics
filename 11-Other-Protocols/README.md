# Module 11: Other Protocols

## 🎯 Learning Objectives

- ✅ Understand TCP vs UDP
- ✅ Learn common protocols (FTP, SMTP, SSH)
- ✅ Know when to use each protocol
- ✅ Understand protocol layers

**Time Required**: 2-3 hours

## 📡 TCP vs UDP

### TCP (Transmission Control Protocol)

**Reliable, connection-oriented protocol**

**Characteristics**:
- Connection established (3-way handshake)
- Guaranteed delivery
- Ordered packets
- Error checking
- Flow control
- Slower but reliable

**Use Cases**:
- Web browsing (HTTP/HTTPS)
- Email (SMTP, IMAP)
- File transfer (FTP)
- SSH connections
- Any data that must be accurate

**Example**: Loading a web page
```
1. Establish connection
2. Send HTTP request
3. Receive HTML (all packets, in order)
4. Close connection
```

### UDP (User Datagram Protocol)

**Fast, connectionless protocol**

**Characteristics**:
- No connection setup
- No delivery guarantee
- No packet ordering
- Minimal error checking
- Faster than TCP
- "Fire and forget"

**Use Cases**:
- Video streaming
- Online gaming
- Voice calls (VoIP)
- DNS queries
- Live broadcasts
- Any data where speed > accuracy

**Example**: Video streaming
```
Packets arrive continuously
Some packets lost? Skip them
Keep streaming without waiting
```

### TCP vs UDP Comparison

| Feature | TCP | UDP |
|---------|-----|-----|
| Connection | Required | None |
| Reliability | Guaranteed | Best effort |
| Speed | Slower | Faster |
| Ordering | Ordered | Unordered |
| Error Checking | Full | Minimal |
| Use Case | Accuracy matters | Speed matters |

## 📧 SMTP (Simple Mail Transfer Protocol)

### What is SMTP?

Protocol for **sending** email.

### How It Works

```
1. Client connects to SMTP server (port 25/587)
2. Client identifies itself (HELO/EHLO)
3. Client specifies sender (MAIL FROM)
4. Client specifies recipient (RCPT TO)
5. Client sends message (DATA)
6. Server delivers or relays email
```

### SMTP Commands

```
HELO example.com          # Identify client
MAIL FROM:<user@example.com>  # Sender
RCPT TO:<user@recipient.com>  # Recipient
DATA                       # Start message
Subject: Test Email        # Headers
                           # Blank line
This is the email body.    # Body
.                          # End message (period on its own line)
QUIT                       # Close connection
```

### Example with telnet

```bash
telnet smtp.example.com 25
HELO example.com
MAIL FROM:<sender@example.com>
RCPT TO:<recipient@example.com>
DATA
Subject: Test
This is a test email.
.
QUIT
```

### SMTP Ports

- **Port 25**: Standard SMTP (often blocked by ISPs)
- **Port 587**: Submission (with STARTTLS)
- **Port 465**: SMTP over SSL (deprecated)

### Related Protocols

**IMAP** (Internet Message Access Protocol):
- Receive email
- Keep messages on server
- Sync across devices
- Port 143 (993 for SSL)

**POP3** (Post Office Protocol):
- Receive email
- Download and delete from server
- Port 110 (995 for SSL)

## 📁 FTP (File Transfer Protocol)

### What is FTP?

Protocol for transferring files between computers.

### How It Works

```
1. Client connects to FTP server (port 21)
2. Client authenticates (username/password)
3. Two channels established:
   - Control channel (port 21)
   - Data channel (port 20 or random)
4. Client issues commands (LIST, GET, PUT)
5. Files transferred over data channel
```

### FTP Commands

```bash
# Connect
ftp ftp.example.com

# Login
Username: user
Password: ****

# Navigate
pwd          # Print working directory
cd folder    # Change directory
ls           # List files

# Download
get file.txt
mget *.txt   # Multiple files

# Upload
put local.txt
mput *.jpg   # Multiple files

# Delete
delete file.txt

# Disconnect
bye
```

### FTP Modes

**Active Mode**:
- Client opens random port
- Server connects to client
- Problem: Firewalls block incoming connections

**Passive Mode**:
- Server opens random port
- Client connects to server
- Better for firewalls

### Secure Alternatives

**SFTP** (SSH File Transfer Protocol):
- Uses SSH (port 22)
- Encrypted
- More secure

**FTPS** (FTP Secure):
- FTP with SSL/TLS
- Port 21 (explicit) or 990 (implicit)

```bash
# SFTP example
sftp user@example.com
sftp> get file.txt
sftp> put local.txt
sftp> exit
```

## 🔐 SSH (Secure Shell)

### What is SSH?

Secure protocol for remote command-line access and file transfer.

### Common Uses

1. **Remote shell access**: Control servers
2. **Secure file transfer**: SFTP, SCP
3. **Port forwarding**: Tunnel connections
4. **Git over SSH**: Secure code pushing

### Basic SSH Usage

```bash
# Connect to server
ssh user@example.com

# Connect with specific port
ssh -p 2222 user@example.com

# Connect with identity file
ssh -i ~/.ssh/id_rsa user@example.com

# Execute command without shell
ssh user@example.com 'ls -la'

# Copy files (SCP)
scp file.txt user@example.com:/path/
scp user@example.com:/path/file.txt .

# Port forwarding (local)
ssh -L 8080:localhost:80 user@example.com
# Now localhost:8080 → server:80
```

### SSH Key Authentication

```bash
# Generate key pair
ssh-keygen -t rsa -b 4096

# Copy public key to server
ssh-copy-id user@example.com

# Now can login without password
ssh user@example.com
```

### SSH Port Forwarding

**Local Forwarding**:
```bash
ssh -L local_port:destination:dest_port user@jump_server
```

**Remote Forwarding**:
```bash
ssh -R remote_port:localhost:local_port user@remote_server
```

**Dynamic Forwarding** (SOCKS proxy):
```bash
ssh -D 8080 user@example.com
```

## 🌐 DNS (Domain Name System)

### What is DNS?

Translates domain names to IP addresses.

### DNS Query Process

```
1. You type: google.com
2. Check local cache
3. Ask DNS resolver (ISP)
4. Resolver asks root server: "Where's .com?"
5. Root says: "Ask .com nameserver"
6. Ask .com server: "Where's google.com?"
7. .com says: "Ask Google's nameserver"
8. Ask Google's server: "IP for google.com?"
9. Google returns: 142.250.190.46
10. Your computer connects to that IP
```

### DNS Record Types

```bash
# A Record (IPv4)
example.com → 93.184.216.34

# AAAA Record (IPv6)
example.com → 2606:2800:220:1:248:1893:25c8:1946

# CNAME (Alias)
www.example.com → example.com

# MX (Mail)
example.com → mail.example.com

# TXT (Text)
example.com → "v=spf1 include:_spf.google.com ~all"

# NS (Nameserver)
example.com → ns1.example.com
```

### DNS Tools

```bash
# Lookup IP
nslookup google.com

# Detailed query
dig google.com

# Reverse lookup
dig -x 8.8.8.8

# Specific record type
dig google.com MX
```

## 🔌 Other Important Protocols

### DHCP (Dynamic Host Configuration Protocol)

Automatically assigns IP addresses to devices.

```
1. Device joins network
2. Sends DHCP discover broadcast
3. DHCP server offers IP address
4. Device requests that IP
5. Server acknowledges
6. Device configured with:
   - IP address
   - Subnet mask
   - Default gateway
   - DNS servers
```

### ICMP (Internet Control Message Protocol)

Used for diagnostics and errors.

**Tools using ICMP**:
- `ping`: Test connectivity
- `traceroute`: Show route to destination

```bash
# Test if server is reachable
ping google.com

# Show hops to server
traceroute google.com
```

### ARP (Address Resolution Protocol)

Maps IP addresses to MAC addresses on local network.

```bash
# View ARP cache
arp -a

# Shows which MAC address has which IP
```

## 📊 When to Use Each Protocol

| Need | Protocol | Why |
|------|----------|-----|
| Web browsing | HTTP/HTTPS | Standard web protocol |
| File transfer (insecure) | FTP | Simple, widely supported |
| File transfer (secure) | SFTP/SCP | Encrypted, uses SSH |
| Send email | SMTP | Email sending standard |
| Receive email | IMAP/POP3 | Email retrieval |
| Remote access | SSH | Secure command-line access |
| Real-time communication | WebSocket | Bidirectional, persistent |
| Fast streaming | UDP | Speed over reliability |
| Reliable data transfer | TCP | Guaranteed delivery |
| Name resolution | DNS | Domain to IP translation |

## 🧪 Hands-On Exercises

### Exercise 1: Test DNS

```bash
# Lookup different domains
nslookup google.com
nslookup github.com
nslookup your-domain.com

# Check MX records (email servers)
nslookup -type=MX gmail.com
```

### Exercise 2: Test Connectivity

```bash
# Ping test
ping 8.8.8.8
ping google.com

# Traceroute
traceroute google.com
```

### Exercise 3: SSH Practice

```bash
# If you have a server, try:
ssh user@server
ls -la
pwd
exit

# Generate SSH key
ssh-keygen -t ed25519 -C "your_email@example.com"
```

## 🎯 Key Takeaways

1. **TCP**: Reliable, ordered, slower - use for accuracy
2. **UDP**: Fast, unreliable - use for speed
3. **SMTP**: Sending email
4. **FTP/SFTP**: File transfer (prefer SFTP)
5. **SSH**: Secure remote access
6. **DNS**: Name to IP resolution
7. **Choose protocol based on requirements**

## 📖 Next Steps

➡️ [Module 12: HTTPS and TLS](../12-HTTPS-and-TLS/)

## 🔗 Resources

- [TCP vs UDP Explained](https://www.youtube.com/watch?v=uwoD5YsGACg)
- [SSH Tutorial](https://www.ssh.com/academy/ssh)
- [DNS Explained](https://howdns.works/)
- [Protocol Comparison Chart](https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers)
