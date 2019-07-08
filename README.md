# IPTABLES

  Whether you’re a novice user or a system administrator, iptables is a mandatory knowledge!
  iptables is the userspace command line program used to configure the Linux 2.4.x and later packet filtering ruleset.
  When a connection tries to establish itself on your system, iptables looks for a rule in its list to match it to.
  If it doesn’t find one, it resorts to the default action.

#### IPTables uses three different chains to allow or block traffic: input, output and forward

 * Input – This chain is used to control the behavior for incoming connections.
 * Output – This chain is used for outgoing connections.
 * Forward – This chain is used for incoming connections that aren’t actually being delivered locally like routing and NATing.


# Tips and Tricks

#### Monitor what's going on.

You would like to monitor what's going on with iptables in real time, like with top. Use this command to monitor the activity of iptables activity dynamically and show only the rules that are actively being traversed:

     watch --interval=5 'iptables -nvL | grep -v "0     0"'

#### Show ALL iptable rules 
     for i in `cat /proc/net/ip_tables_names`; do iptables -nL -v --line-numbers -t $i ; done

#### By default everything is logged to /var/log/messages file:
    tail -f /var/log/messages

##### By default all chains are configured to the accept rule, so during the hardening process the suggestion is to start with a deny all configuration and then open only needed ports:

     iptables --policy INPUT DROP
     iptables --policy OUTPUT DROP
     iptables --policy FORWARD DROP

# Saving And Restoring Rules

     iptables-save > iptables.rules
     iptables-restore < my_iptables_rules.txt

# Misc

##### Verbose print out all active iptables rules
     iptables -n -L -v

#### Same output with line numbers:
     iptables -n -L -v --line-numbers

#### Same data output but related to INPUT/OUTPUT chains:
     iptables -L INPUT -n -viptables -L OUTPUT -n -v --line-numbers

#### List Rules as for a specific chain
     iptables -L INPUT

#### Same data with rules specifications:
     iptables -S INPUT

#### Rules list with packet count
     iptables -L INPUT -v

#### Dump Current Rules In Save Format
     iptables -S

#### Zero Out Bytes In Verbose Listing
    iptables -Z

#### Delete All Chains From The Firewall Table
    iptables -X

#### Flush All Rules, Delete All Chains, and Accept All
    iptables -P INPUT ACCEPT
    iptables -P FORWARD ACCEPT
    iptables -P OUTPUT ACCEPT

#### Also (if you need these you know what's it means)
    iptables -t nat -F
    iptables -t mangle -F
    iptables -F
    iptables -X


#### Allow Loopback Connections
    iptables -A INPUT -i lo -j ACCEPT
    iptables -A OUTPUT -o lo -j ACCEPT

#### Allow Established and Related Incoming Connections
    iptables -A INPUT -m conntrack –ctstate ESTABLISHED,RELATED -j ACCEPT

#### Allow Established Outgoing Connections
    iptables -A OUTPUT -m conntrack –ctstate ESTABLISHED -j ACCEPT


#### Flush All Chains
    iptables -F

#### Flush a Single Chain
    iptables -F INPUT

# Delete All Rules

    iptables -F
    iptables -X
    iptables -t nat -F
    iptables -t nat -X
    iptables -t mangle -F
    iptables -t mangle -X
    iptables -P INPUT ACCEPT
    iptables -P FORWARD ACCEPT
    iptables -P OUTPUT ACCEPT

#### List opened ports
    netstat --inet -nplae

# Delete rules

#### Iptables -L  
     iptables -n -L -v --line-numbers
     iptables -D INPUT <number>

#### Delete Rule by Specification
     iptables -D INPUT -m conntrack --ctstate INVALID -j DROP

####  Delete Rule by Chain and Number
     iptables -D INPUT 10

####  Delete Rule by Specification
     iptables -D INPUT -m conntrack --ctstate INVALID -j DROP

#### Flush All Rules, Delete All Chains, and Accept All
     iptables -P INPUT ACCEPT
     iptables -P FORWARD ACCEPT
     iptables -P OUTPUT ACCEPT
     iptables -t nat -F
     iptables -t mangle -F
     iptables -F
     iptables -X

####  Flush All Chains
     iptables -F

#### Flush a Single Chain

# Accept Rules

#### Ensure to accept the connection in first place
    iptables -P INPUT ACCEPT

#### Allow All Local Traffic
     iptables -A INPUT -i lo -j ACCEPT
     iptables -A OUTPUT -o lo -j ACCEPT

#### Allow all traffic from your IP
    iptables -A INPUT -s {YOUR_IP_HERE} -j ACCEPT

#### Allow anyone ping your server
    iptables -A INPUT -p icmp  -j ACCEPT

#### Open A Specific Port (HTTP)
    iptables -A INPUT -p tcp --dport 80 -j ACCEPT

#### Accept Already Established Connection (lDNS queries etc)
     iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT


#### Allow a specifik ip address on a specifik port
    iptables -A INPUT -p tcp -m tcp --dport port_number -s ip_address -j ACCEPT

#### Allow Loopback Connections
     iptables -A INPUT -i lo -j ACCEPTiptables -A OUTPUT -o lo -j ACCEPT

#### Allow Established and Related Incoming Connections
     iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

#### Allow Established Outgoing Connections
     iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED -j ACCEPT

####  Internal to External
     iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT

#### Add rule for port on all addresses
     iptables -A INPUT -p tcp -m tcp --dport port_number --sport 1024:65535 -j ACCEPT

#### Allow Traffic From Mac Address
    iptables -A INPUT -m mac --mac-source 00:0F:EA:91:04:08 -j ACCEPT

#### Open a range of ip addresses
    iptables -A INPUT -p tcp --destination-port 80 -m iprange --src-range 192.168.1.100-192.168.1.200 -j ACCEPT

####  Open a range of ports
    iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 7000:7010 -j ACCEPT

#### Specifying portrange with multiport
     iptables -A INPUT -i eth0 -p tcp -m state --state NEW -m multiport --dports ssh,smtp,http,https -j ACCEPT

### Add RULE with Port and IP-Address 
     iptables -A INPUT -p tcp -m tcp --dport port_number -s ip_address -j ACCEPT

#### Accept traffic for TCP port # 8080 from mac address
    iptables -A INPUT -p tcp --destination-port 22 -m mac --mac-source 00:11:22:33:44:55 -j ACCEPT

#### Accept a range on port 80
    iptables -A INPUT -p tcp --destination-port 80 -m iprange --src-range 192.168.1.100-192.168.1.200 -j ACCEPT
     
#### Time-based Rules with time*
     iptables -A FORWARD -p tcp -m multiport --dport http,https -o eth0 -i eth1 -m time --timestart 21:30 --timestop 22:30 --days Mon,Tue,Wed,Thu,Fri -j ACCEPT

#####  Allow time sync via NTP for lan users (open udp port 123)
     iptables -A INPUT -s 192.168.1.0/24 -m state --state NEW -p udp --dport 123 -j ACCEPT

####  Open dns server ports for all

    iptables -A INPUT -m state --state NEW -p udp --dport 53 -j ACCEPT
    iptables -A INPUT -m state --state NEW -p tcp --dport 53 -j ACCEPT

####  Open access to Samba file server for lan users only
    iptables -A INPUT -s 192.168.1.0/24 -m state --state NEW -p tcp --dport 137 -j ACCEPT
    iptables -A INPUT -s 192.168.1.0/24 -m state --state NEW -p tcp --dport 138 -j ACCEPT
    iptables -A INPUT -s 192.168.1.0/24 -m state --state NEW -p tcp --dport 139 -j ACCEPT
    iptables -A INPUT -s 192.168.1.0/24 -m state --state NEW -p tcp --dport 445 -j ACCEPT

####  Open access to proxy server for lan users only
    iptables -A INPUT -s 192.168.1.0/24 -m state --state NEW -p tcp --dport 3128 -j ACCEPT

####  Open access to mysql server for local users only
    iptables -A INPUT -i eth0 -p tcp -s 192.168.100.0/24 --dport 3306 -m state --state NEW,ESTABLISHED -j ACCEPT
    iptables -A OUTPUT -o eth0 -p tcp --sport 3306 -m state --state ESTABLISHED -j ACCEPT

# Drop/Reject Rules

#### Drop/Reject all inbound packets by default
     iptables -P INPUT DROP

#### Block outgoing sites
     iptables -A OUTPUT -p tcp -d www.microsoft.com -j DRO	
#### Block an IP Address
     iptables -A INPUT -s 192.168.1.10 -j DROP

#### Block and IP Address and Reject
    iptables -A INPUT -s 192.168.1.10 -j REJECT

#### Block Connections to a Network Interface
     iptables -A INPUT -i eth0 -s 192.168.1.10 -j DROP

#### To block port 80 only for an ip address 1.2.3.4
     iptables -A INPUT -p tcp -s 1.2.3.4 --dport 80 -j DROP
     iptables -A INPUT -i eth1 -p tcp -s 192.168.1.0/24 --dport 80 -j DROP

#### Log and block IP spoofing on public interface called eth1
    iptables -A INPUT -i eth1 -s 10.0.0.0/8 -j LOG --log-prefix "IP_SPOOF A: "
    iptables -A INPUT -i eth1 -s 10.0.0.0/8 -j DROP

####  Drop Private Network Address On Public Interface
     iptables -A INPUT -i eth1 -s 192.168.1.0/24 -j DROP
     iptables -A INPUT -i eth1 -s 10.0.0.0/8 -j DROP

#### Drop Invalid Packets
     iptables -A INPUT -m conntrack --ctstate INVALID -j DROP

#### Use the following command to block ICMP ping requests:
     iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
     iptables -A INPUT -i eth1 -p icmp --icmp-type echo-request -j DROP

#### Ping responses can also be limited to certain networks or hosts:
    iptables -A INPUT -s 192.168.1.0/24 -p icmp --icmp-type echo-request -j ACCEPT

#### Drop or Accept Traffic From Mac Address
     iptables -A INPUT -m mac --mac-source 00:0F:EA:91:04:08 -j DROP
     iptables -A INPUT -p tcp --destination-port 22 -m mac --mac-source 00:0F:EA:91:04:07 -j ACCEPT

#### Block ICMP Ping Request
     iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
     iptables -A INPUT -i eth1 -p icmp --icmp-type echo-request -j DROP

#### Restricting the Number of Connections with limit and iplimit*
     iptables -A INPUT -p tcp -m state --state NEW --dport http -m iplimit --iplimit-above 5 -j DROP

##### Maintaining a List of recent Connections to Match Against
    iptables -A FORWARD -m recent --name portscan --rcheck --seconds 100 -j DROPiptables -A FORWARD -p tcp -i eth0 --dport 443 -m recent --name portscan --set -j DROP

#### Matching Against a string in a Packet’s Data Payload
     iptables -A FORWARD -m string --string '.com' -j DROP
     iptables -A FORWARD -m string --string '.exe' -j DROP

#### Protection against port scanning
     iptables -N port-scanningiptables -A port-scanning -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s --limit-burst 2 -j RETURNiptables -A port-scanning -j DROP

#### SSH brute-force protection
     iptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --setiptables -A INPUT -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --update --seconds 60 --hitcount 10 -j DROP

#### Syn-flood protection
     iptables -N syn_floodiptables -A INPUT -p tcp --syn -j syn_floodiptables -A syn_flood -m limit --limit 1/s --limit-burst 3 -j RETURN
     iptables -A syn_flood -j DROPiptables -A INPUT -p icmp -m limit --limit  1/s --limit-burst 1 -j ACCEPT
     iptables -A INPUT -p icmp -m limit --limit 1/s --limit-burst 1 -j LOG --log-prefix PING-DROP:
     iptables -A INPUT -p icmp -j DROPiptables -A OUTPUT -p icmp -j ACCEPT

#### Mitigating SYN Floods With SYNPROXY
     iptables -t raw -A PREROUTING -p tcp -m tcp --syn -j CT --notrack
     iptables -A INPUT -p tcp -m tcp -m conntrack --ctstate INVALID,UNTRACKED -j SYNPROXY --sack-perm --timestamp --wscale 7 --mss 1460
     iptables -A INPUT -m conntrack --ctstate INVALID -j DROP

#### Block New Packets That Are Not SYN
     iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP

####  Force Fragments packets check
     iptables -A INPUT -f -j DROP

####  XMAS packets
     iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP

####  Drop all NULL packets
     iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

#### Block Uncommon MSS Values
     iptables -t mangle -A PREROUTING -p tcp -m conntrack --ctstate NEW -m tcpmss ! --mss 536:65535 -j DROP

#### Block Packets With Bogus TCP Flags
     iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
     iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
     iptables -t mangle -A PREROUTING -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
     iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
     iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,ACK FIN -j DROP
     iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,URG URG -j DROP
     iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,FIN FIN -j DROP
     iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,PSH PSH -j DROP
     iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL ALL -j DROP
     iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL NONE -j DROP
     iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL FIN,PSH,URG -j DROP
     iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,FIN,PSH,URG -j DROP
     iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP





#### Reject rules

##### Reject all rules by default
    iptables -P INPUT REJECT
	
#### Packet Matching Based on TTL Values
     iptables -A INPUT -s 1.2.3.4 -m ttl --ttl-lt 40 -j REJECT

# Logging

# Log and Drop Packets
     iptables -A INPUT -i eth1 -s 10.0.0.0/8 -j LOG --log-prefix "IP_SPOOF A: "
     iptables -A INPUT -i eth1 -s 10.0.0.0/8 -j DROP

#####  By default everything is logged to /var/log/messages file:
    tail -f /var/log/messagesgrep --color 'IP SPOOF' /var/log/messages

#### Log and Drop Packets with Limited Number of Log Entries
     iptables -A INPUT -i eth1 -s 10.0.0.0/8 -m limit --limit 5/m --limit-burst 7 -j LOG --log-prefix "IP_SPOOF A: "
     iptables -A INPUT -i eth1 -s 10.0.0.0/8 -j DROP




# Allow examples
### Allow All Incoming SSH
     iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
     iptables -A OUTPUT -p tcp --sport 22 -m conntrack --ctstate ESTABLISHED -j ACCEPT

#### Allow Incoming SSH from Specific IP address or subnet
     iptables -A INPUT -p tcp -s 192.168.1.0/24 --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
     iptables -A OUTPUT -p tcp --sport 22 -m conntrack --ctstate ESTABLISHED -j ACCEPT

#### Allow Outgoing SSH
     iptables -A OUTPUT -p tcp --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
     iptables -A INPUT -p tcp --sport 22 -m conntrack --ctstate ESTABLISHED -j ACCEPT

#### Allow Incoming Rsync from Specific IP Address or Subnet
     iptables -A INPUT -p tcp -s 192.168.1.0/24 --dport 873 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
     iptables -A OUTPUT -p tcp --sport 873 -m conntrack --ctstate ESTABLISHED -j ACCEPT

#### Allow Incoming HTTP
     iptables -A INPUT -p tcp --dport 80 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
     iptables -A OUTPUT -p tcp --sport 80 -m conntrack --ctstate ESTABLISHED -j ACCEPT

#### Allow Incoming HTTPS
     iptables -A INPUT -p tcp --dport 443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
     iptables -A OUTPUT -p tcp --sport 443 -m conntrack --ctstate ESTABLISHED -j ACCEPT

#### Allow Incoming HTTP and HTTPS
     iptables -A INPUT -p tcp -m multiport --dports 80,443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
     iptables -A OUTPUT -p tcp -m multiport --dports 80,443 -m conntrack --ctstate ESTABLISHED -j ACCEPT

#### Allow MySQL from Specific IP Address or Subnet
     iptables -A INPUT -p tcp -s 192.168.1.0/24 --dport 3306 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
     iptables -A OUTPUT -p tcp --sport 3306 -m conntrack --ctstate ESTABLISHED -j ACCEPT

#### Allow MySQL to Specific Network Interface
     iptables -A INPUT -i eth1 -p tcp --dport 3306 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
     iptables -A OUTPUT -o eth1 -p tcp --sport 3306 -m conntrack --ctstate ESTABLISHED -j ACCEPT

#### Allow PostgreSQL from Specific IP Address or Subnet
     iptables -A INPUT -p tcp -s 192.168.1.0/24 --dport 5432 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
     iptables -A OUTPUT -p tcp --sport 5432 -m conntrack --ctstate ESTABLISHED -j ACCEPT

#### Allow PostgreSQL to Specific Network Interface
     iptables -A INPUT -i eth1 -p tcp --dport 5432 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
     iptables -A OUTPUT -o eth1 -p tcp --sport 5432 -m conntrack --ctstate ESTABLISHED -j ACCEPT

#### Block Outgoing SMTP Mail
     iptables -A OUTPUT -p tcp --dport 25 -j REJECT

#### Allow All Incoming SMTP
     iptables -A INPUT -p tcp --dport 25 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
     iptables -A OUTPUT -p tcp --sport 25 -m conntrack --ctstate ESTABLISHED -j ACCEPT

#### Allow All Incoming IMAP
     iptables -A INPUT -p tcp --dport 143 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
     iptables -A OUTPUT -p tcp --sport 143 -m conntrack --ctstate ESTABLISHED -j ACCEPT

#### Allow All Incoming IMAPS
     iptables -A INPUT -p tcp --dport 993 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
     iptables -A OUTPUT -p tcp --sport 993 -m conntrack --ctstate ESTABLISHED -j ACCEPT

#### Allow All Incoming POP3
     iptables -A INPUT -p tcp --dport 110 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
     iptables -A OUTPUT -p tcp --sport 110 -m conntrack --ctstate ESTABLISHED -j ACCEPT

#### Allow All Incoming POP3S
     iptables -A INPUT -p tcp --dport 995 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
     iptables -A OUTPUT -p tcp --sport 995 -m conntrack --ctstate ESTABLISHED -j ACCEPT






