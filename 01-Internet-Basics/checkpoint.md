# Module 1 Checkpoint: Internet Basics

## Before Moving Forward

Complete this checkpoint to ensure you're ready for the next module.

## Knowledge Check (Answer these questions)

### Fundamentals

1. What is the Internet and how is it different from the World Wide Web?
   <details>
   <summary>Answer</summary>
   The Internet is a global network of interconnected computers that communicate using standardized protocols (TCP/IP). It's the physical and logical infrastructure. The World Wide Web is a service that runs on top of the Internet - it's the collection of websites and web pages accessed through browsers using HTTP/HTTPS protocols. The Internet includes email, file transfer, gaming, streaming, and the web.
   </details>

2. What is an IP address and what is the difference between IPv4 and IPv6?
   <details>
   <summary>Answer</summary>
   An IP address is a unique numerical identifier assigned to each device on a network. IPv4 uses 32-bit addresses (e.g., 192.168.1.1) providing about 4.3 billion addresses, while IPv6 uses 128-bit addresses (e.g., 2001:0db8:85a3:0000:0000:8a2e:0370:7334) providing 340 undecillion addresses. IPv6 was created to solve IPv4 address exhaustion.
   </details>

3. What is DNS and why is it necessary?
   <details>
   <summary>Answer</summary>
   DNS (Domain Name System) is like the phone book of the Internet. It translates human-readable domain names (like google.com) into IP addresses (like 142.250.190.46) that computers use to communicate. It's necessary because remembering numerical IP addresses for every website would be impractical for humans.
   </details>

4. What are packets and why is data sent in packets rather than as one continuous stream?
   <details>
   <summary>Answer</summary>
   Packets are small chunks of data that include the data payload plus metadata (source IP, destination IP, sequence number). Data is sent in packets for: 1) Efficiency - multiple packets can travel simultaneously through different routes, 2) Reliability - lost packets can be resent without resending everything, 3) Flexibility - packets can take the fastest available route, and 4) Fair sharing of network resources.
   </details>

### Intermediate

5. Explain the basic flow of what happens when you type a URL in your browser and press Enter.
   <details>
   <summary>Answer</summary>
   1. Browser checks cache for DNS record
   2. If not cached, DNS lookup translates domain to IP address
   3. Browser initiates TCP connection to server (3-way handshake)
   4. Browser sends HTTP request
   5. Server processes request and sends HTTP response
   6. Browser receives packets, assembles them, and renders the page
   7. Connection may be kept alive or closed
   </details>

6. What is the difference between a router and a switch?
   <details>
   <summary>Answer</summary>
   A switch operates at Layer 2 (Data Link) and connects devices within the same local network using MAC addresses. It's like a traffic director within a building. A router operates at Layer 3 (Network) and connects different networks together using IP addresses. It's like a post office routing mail between different cities. Routers also provide NAT, firewall, and DHCP services.
   </details>

7. What are the main layers in the simplified network model and what does each do?
   <details>
   <summary>Answer</summary>
   From top to bottom:
   - Application Layer (HTTP, FTP, DNS): User-facing protocols and applications
   - Transport Layer (TCP, UDP): Reliable data transfer, port numbers, error checking
   - Network Layer (IP): Routing packets across networks using IP addresses
   - Link Layer (Ethernet, WiFi): Physical transmission of data over network hardware
   </details>

8. What is the difference between public and private IP addresses?
   <details>
   <summary>Answer</summary>
   Public IP addresses are unique globally and routable on the Internet - assigned by ISPs and used for communication across the Internet. Private IP addresses (192.168.x.x, 10.x.x.x, 172.16-31.x.x) are used within local networks and cannot be routed on the public Internet. NAT (Network Address Translation) allows private IPs to access the Internet through a single public IP.
   </details>

### Advanced

9. Explain how traceroute works and what information it provides.
   <details>
   <summary>Answer</summary>
   Traceroute uses ICMP or UDP packets with incrementing TTL (Time To Live) values. It sends packets with TTL=1, then TTL=2, etc. Each router decrements TTL by 1 and when it reaches 0, the router sends back an ICMP "Time Exceeded" message. This reveals each hop (router) along the path to the destination, showing the route packets take and the latency at each hop. Useful for diagnosing network issues and understanding network topology.
   </details>

10. What is NAT (Network Address Translation) and why is it important?
    <details>
    <summary>Answer</summary>
    NAT allows multiple devices on a private network to share a single public IP address. When a device sends a request, the router maps the private IP:port to the public IP:port and maintains this mapping. When responses return, the router forwards them to the correct internal device. NAT is crucial because it: 1) Conserves IPv4 addresses, 2) Provides security by hiding internal network structure, 3) Allows home/office networks to function with one ISP connection.
    </details>

11. What is the difference between TCP and UDP, and when would you use each?
    <details>
    <summary>Answer</summary>
    TCP (Transmission Control Protocol) is connection-oriented, reliable, ordered, and includes error-checking. It's slower but ensures data arrives correctly. Use for: web browsing, email, file transfers. UDP (User Datagram Protocol) is connectionless, fast, but unreliable with no guaranteed delivery. Use for: live streaming, video calls, online gaming, DNS queries - where speed matters more than occasional data loss.
    </details>

12. How does the Internet handle the exponential growth in connected devices despite IPv4 limitations?
    <details>
    <summary>Answer</summary>
    Several technologies enable this: 1) NAT allows multiple devices to share one public IP, 2) DHCP dynamically assigns IPs only when needed, 3) IPv6 adoption is gradually increasing, 4) Carrier-Grade NAT (CGN) allows ISPs to share IPs among customers, 5) Private address spaces reduce public IP usage. Most homes/businesses use one public IP with NAT for dozens of devices.
    </details>

## Practical Skills Verification

### Task 1: IP Address Discovery
**Objective:** Identify your public and private IP addresses and understand the difference.

**Steps:**
1. Find your private IP address:
   - **Windows**: Open Command Prompt, run `ipconfig`, look for "IPv4 Address"
   - **Mac/Linux**: Open Terminal, run `ifconfig` or `ip addr`, look for inet address
2. Find your public IP address:
   - Visit https://ifconfig.me or https://whatismyip.com
   - Or run: `curl ifconfig.me` in terminal
3. Compare the two addresses

**Success Criteria:**
- [ ] You can identify your private IP address (likely 192.168.x.x or 10.x.x.x)
- [ ] You can identify your public IP address (different from private)
- [ ] You understand why they're different (NAT)

**Troubleshooting:**
If you can't find your IP address, ensure you're connected to a network. On Linux, try `ip a` instead of `ifconfig`. If curl doesn't work, check your internet connection or use a web browser instead.

---

### Task 2: DNS Lookup Practice
**Objective:** Perform DNS lookups to see how domain names resolve to IP addresses.

**Steps:**
1. Look up a domain using `nslookup`:
   ```bash
   nslookup google.com
   nslookup github.com
   ```
2. Try `dig` for more detailed information (Mac/Linux):
   ```bash
   dig google.com
   ```
3. On Windows, use:
   ```bash
   nslookup google.com
   ```

**Success Criteria:**
- [ ] You can see the IP address(es) for a domain
- [ ] You understand that one domain can have multiple IPs
- [ ] You can identify the DNS server being queried

**Troubleshooting:**
If `dig` is not found on Windows, use `nslookup` instead. If you get "connection timed out," your DNS server might be blocked - try using Google's DNS: `nslookup google.com 8.8.8.8`

---

### Task 3: Network Path Tracing
**Objective:** Trace the route packets take from your computer to a destination.

**Steps:**
1. Use traceroute/tracert to see the path:
   - **Windows**: `tracert google.com`
   - **Mac/Linux**: `traceroute google.com`
2. Observe the hops (routers) along the path
3. Note the latency at each hop
4. Try different destinations (github.com, amazon.com, your local university website)

**Success Criteria:**
- [ ] You can see multiple hops between you and the destination
- [ ] You understand that each hop is a router
- [ ] You notice latency increases as hops increase

**Troubleshooting:**
If traceroute hangs or shows asterisks (***), some routers don't respond to ICMP. This is normal - the path is still being traced. On Mac/Linux, use `traceroute -I` for ICMP or `traceroute -T` for TCP-based tracing.

---

### Task 4: Understanding Network Layers
**Objective:** Identify which layer different protocols operate at.

**Steps:**
1. Create a list of protocols: HTTP, TCP, IP, Ethernet, DNS, UDP
2. Map each to its layer (Application, Transport, Network, Link)
3. Explain what each protocol does

**Success Criteria:**
- [ ] Correctly map all protocols to their layers
- [ ] Understand the purpose of each layer
- [ ] Recognize how layers build on each other

**Troubleshooting:**
If confused about layers, remember: Application (what users see), Transport (reliable delivery), Network (routing between networks), Link (physical transmission).

---

### Task 5: Ping and Connectivity Testing
**Objective:** Test network connectivity and measure latency.

**Steps:**
1. Ping your local router:
   ```bash
   ping 192.168.1.1   # or your router's IP
   ```
2. Ping a public DNS server:
   ```bash
   ping 8.8.8.8
   ```
3. Ping a domain:
   ```bash
   ping google.com
   ```
4. Notice the differences in response times

**Success Criteria:**
- [ ] Successfully ping local and remote hosts
- [ ] Understand RTT (Round Trip Time)
- [ ] Recognize that local pings are faster than remote ones

**Troubleshooting:**
If ping fails with "Request timed out," the host might block ICMP packets (security measure). This doesn't mean the host is unreachable - try accessing it via browser. On Windows, ping runs 4 times by default; use `ping -t` for continuous pinging (Ctrl+C to stop).

## Project-Based Assessment

**Mini-Project:** Network Diagnostic Report

Create a comprehensive network diagnostic report for your home or school network.

**Requirements:**
- [ ] Document your private IP address, subnet mask, and default gateway
- [ ] Identify your public IP address and ISP
- [ ] Perform DNS lookups for 5 different domains and record their IPs
- [ ] Trace routes to 3 different websites and document the number of hops
- [ ] Test connectivity to your router, ISP DNS, and Google DNS (8.8.8.8)
- [ ] Create a network diagram showing: your device → router → ISP → Internet
- [ ] Explain in writing why your private and public IPs are different
- [ ] Document at least one troubleshooting scenario (e.g., "what if DNS fails?")

**Evaluation Rubric:**
| Criteria | Needs Work | Good | Excellent |
|----------|------------|------|-----------|
| **Technical Accuracy** | Missing key information or contains errors | All technical data present and mostly correct | All information accurate with clear understanding shown |
| **Documentation** | Poorly organized, hard to follow | Well-organized, clear sections | Professional format, easy to understand, includes screenshots |
| **Analysis** | Basic listing of data without explanation | Good explanations of what data means | Deep insights, connections between concepts, troubleshooting scenarios |
| **Completeness** | Missing 3+ requirements | Missing 1-2 requirements | All requirements met plus extras |

**Sample Solution:**
See `checkpoint-solutions/01-network-diagnostic-report.md` for a sample report format and example outputs.

## Self-Assessment

Rate your confidence (1-5) in these areas:
- [ ] Understanding how the Internet works: ___/5
- [ ] Working with IP addresses and DNS: ___/5
- [ ] Using network diagnostic tools (ping, traceroute, nslookup): ___/5
- [ ] Explaining network layers and protocols: ___/5

**If you scored below 3 on any:**
- Review the README.md sections on the topics you're unsure about
- Practice the hands-on tasks again
- Watch supplementary videos on YouTube about TCP/IP basics
- Revisit common-mistakes.md to avoid pitfalls

**If you scored 4+ on all:**
- You're ready to move forward!
- Consider the advanced challenges below

## Advanced Challenges (Optional)

For those who want to go deeper:

1. **Subnet Mastery**: Learn about subnet masks and CIDR notation. Calculate how many hosts can exist in 192.168.1.0/24 vs 192.168.1.0/25. Set up a small home network with two different subnets.

2. **Packet Capture**: Use Wireshark to capture and analyze actual network packets. Filter for DNS queries, observe TCP handshakes, and examine packet headers.

3. **Network Security**: Research and document how VPNs work at the network layer. Set up your own VPN connection and observe how it changes your public IP address.

4. **IPv6 Deep Dive**: Check if your ISP supports IPv6. If yes, configure IPv6 on your network and compare performance with IPv4. If no, research why IPv6 adoption is slow.

5. **Custom DNS**: Set up a Pi-hole or modify your hosts file to create custom DNS entries. Use it to block ads or create local domain names for your network devices.

## Ready to Continue?

- [ ] I've completed the knowledge check (80% or better)
- [ ] I've verified all practical skills
- [ ] I've completed the mini-project
- [ ] I feel confident in this module's concepts
- [ ] I've reviewed common-mistakes.md

✅ **Proceed to Module 2: How The Web Works**
