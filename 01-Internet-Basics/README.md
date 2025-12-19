# Module 01: Internet Basics

## 🎯 Learning Objectives

By the end of this module, you will understand:

- ✅ How data travels across the Internet
- ✅ What IP addresses are and how they work
- ✅ The role of DNS (Domain Name System)
- ✅ Network layers (simplified OSI model)
- ✅ The difference between IPv4 and IPv6
- ✅ How routers and switches work

**Time Required**: 2-3 hours

## 📚 What is the Internet?

The Internet is a global network of interconnected computers that communicate using standardized protocols. It's not a single entity but a "network of networks" that connects billions of devices worldwide.

### Key Components:

1. **Devices**: Computers, phones, servers, IoT devices
2. **Connections**: Cables, fiber optics, wireless signals
3. **Protocols**: Agreed-upon rules for communication
4. **Infrastructure**: Data centers, routers, switches, cables

## 🌐 How Data Travels

### The Journey of a Web Request

When you visit a website, here's what happens:

```
You (Client) → ISP → Router → Internet Backbone → Server → Back to You
```

1. **You type a URL** in your browser
2. **DNS lookup** translates the domain to an IP address
3. **Request is packaged** into data packets
4. **Packets travel** through multiple routers
5. **Server receives** the request
6. **Server sends back** the response in packets
7. **Your browser assembles** the packets and displays the page

### Packets

Data doesn't travel as one big chunk. It's broken into small **packets**:

- Each packet contains: data + source IP + destination IP + sequence number
- Packets can take different routes
- They're reassembled at the destination

**Why packets?**
- Efficiency: Multiple packets can travel simultaneously
- Reliability: Lost packets can be resent without resending everything
- Flexibility: Packets can take the fastest available route

## 🔢 IP Addresses

An **IP Address** is a unique identifier for devices on a network. Think of it like a street address for computers.

### IPv4 (Internet Protocol version 4)

Format: Four numbers (0-255) separated by dots

Examples:
```
192.168.1.1        (Private network)
8.8.8.8            (Google DNS)
142.250.190.46     (Public IP)
```

**Structure**:
- 32 bits (4 bytes)
- Approximately 4.3 billion possible addresses
- Running out of addresses → led to IPv6

**Special Ranges**:
- `127.0.0.1` - Localhost (your own computer)
- `192.168.x.x` - Private networks (home/office)
- `10.x.x.x` - Private networks (large organizations)

### IPv6 (Internet Protocol version 6)

Format: Eight groups of hexadecimal digits

Example:
```
2001:0db8:85a3:0000:0000:8a2e:0370:7334
```

**Structure**:
- 128 bits (16 bytes)
- 340 undecillion possible addresses (essentially unlimited)
- Solves IPv4 exhaustion problem

### Finding Your IP Address

**Public IP** (how the Internet sees you):
```bash
curl ifconfig.me
```

**Private IP** (your local network address):

Windows:
```powershell
ipconfig
```

macOS/Linux:
```bash
ifconfig
# or
ip addr show
```

## 🏷️ DNS (Domain Name System)

**DNS** translates human-readable domain names into IP addresses.

### Why DNS?

Humans: "I want to visit google.com"  
Computers: "I need to connect to 142.250.190.46"

DNS acts as the Internet's phonebook.

### How DNS Works

```
1. You type: www.example.com
2. Browser checks: DNS cache (local)
3. If not cached: Ask DNS resolver (usually your ISP)
4. Resolver asks: Root DNS servers
5. Root servers say: "Ask .com servers"
6. .com servers say: "Ask example.com servers"
7. example.com servers return: IP address
8. Your browser connects to: That IP address
```

### DNS Hierarchy

```
Root (.)
  └── Top-Level Domain (.com, .org, .net)
      └── Second-Level Domain (google, amazon)
          └── Subdomain (www, mail, api)
```

### DNS Record Types

- **A Record**: Maps domain to IPv4 address
- **AAAA Record**: Maps domain to IPv6 address
- **CNAME**: Maps domain to another domain
- **MX Record**: Mail server addresses
- **TXT Record**: Text information (verification, SPF)

### Testing DNS

```bash
# Lookup IP address for a domain
nslookup google.com

# Detailed DNS information
dig google.com

# Windows alternative
nslookup google.com
```

## 📊 Network Layers (Simplified OSI Model)

The **OSI Model** describes how data moves through a network in 7 layers. Here's a simplified practical version:

### The 7 Layers

```
7. Application Layer    (HTTP, FTP, SMTP)        ← Where your app lives
6. Presentation Layer   (Encryption, Compression)
5. Session Layer        (Manage connections)
4. Transport Layer      (TCP, UDP)               ← Reliable delivery
3. Network Layer        (IP, Routing)            ← Addressing
2. Data Link Layer      (Ethernet, WiFi)         ← Local network
1. Physical Layer       (Cables, Radio waves)    ← Hardware
```

### Practical Understanding

**Application Layer (7)**: Your web browser, email client, or app

**Transport Layer (4)**: Ensures data arrives correctly
- **TCP**: Reliable, ordered delivery (web pages, emails)
- **UDP**: Fast, but no guarantees (video streaming, gaming)

**Network Layer (3)**: Routes packets across networks
- IP addressing
- Router decisions

**Data Link Layer (2)**: Communication within local network
- MAC addresses
- Switch operations

**Physical Layer (1)**: The actual cables, WiFi, fiber optics

### Example: Loading a Web Page

```
Application:  Browser requests HTTP page
Transport:    TCP ensures reliable delivery
Network:      IP routes packets across Internet
Data Link:    Ethernet/WiFi moves data locally
Physical:     Electrical signals on cables
```

## 🔀 Network Devices

### Router

- Connects different networks
- Decides best path for packets
- Uses IP addresses
- Home router: Connects your devices to the Internet

### Switch

- Connects devices in the same network
- Uses MAC addresses
- Faster than routers for local traffic
- Office/home network: Connects multiple computers

### Modem

- Converts digital signals to analog (and back)
- Connects your home network to your ISP
- Often combined with router in home setups

## 🚦 How Communication Works

### Example: Visiting a Website

```
1. You: "I want to see example.com"
2. DNS: "That's IP 93.184.216.34"
3. Your computer: Creates packets with:
   - Source IP: Your IP
   - Destination IP: 93.184.216.34
   - Data: HTTP request for the homepage
4. Router: Forwards packets toward destination
5. Internet backbone: Routes through multiple hops
6. Server: Receives request, sends back HTML
7. Packets return: May take different route
8. Your computer: Assembles packets, browser displays page
```

## 🧪 Hands-On Exercises

### Exercise 1: Trace a Route

See the path packets take to reach a server:

```bash
# Windows/macOS/Linux
traceroute google.com

# Windows alternative
tracert google.com
```

Watch how many "hops" it takes!

### Exercise 2: DNS Lookup

```bash
nslookup github.com
nslookup facebook.com
nslookup netflix.com
```

Notice how some domains return multiple IP addresses (load balancing).

### Exercise 3: Ping a Server

```bash
ping 8.8.8.8
# Google's DNS server

ping google.com
# Same server, but using DNS
```

Observe the round-trip time (latency).

### Exercise 4: Check Your Network

```bash
# Your private IP
ipconfig  # Windows
ifconfig  # macOS/Linux

# Your public IP
curl ifconfig.me
```

## 🎯 Key Takeaways

1. **Internet** = Network of networks using standardized protocols
2. **IP Addresses** = Unique identifiers for devices (IPv4 running out, IPv6 is the future)
3. **DNS** = Translates domains to IP addresses (the Internet's phonebook)
4. **Packets** = Data is split into small chunks for efficient transmission
5. **Layers** = Communication happens at different levels (OSI model)
6. **Routing** = Packets can take multiple paths to reach destination

## 📖 Next Steps

Now that you understand how the Internet works at a fundamental level, you're ready to learn:

➡️ [Module 02: How The Web Works](../02-How-The-Web-Works/) - Clients, servers, and browsers

## 🔗 Additional Resources

- [How Does the Internet Work? (Video)](https://www.youtube.com/watch?v=7_LPdttKXPc)
- [Submarine Cable Map](https://www.submarinecablemap.com/) - See the physical Internet
- [Visual Traceroute Tool](https://stefansundin.github.io/traceroute-mapper/)
- [DNS Explained (Comic)](https://howdns.works/)

## 💡 Fun Facts

- The Internet weighs about as much as a strawberry (the mass of all electrons in motion)
- There are over 400 submarine cables carrying 99% of international data
- IPv6 has enough addresses to give 100 addresses to every atom on Earth's surface
- The average packet makes 10-15 hops to reach its destination
