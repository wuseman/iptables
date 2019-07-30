#!/bin/bash
################################################################################
################################################################################
####                                                                       #####
#### A notice to all nerds.                                                #####
#### If you will copy developers real work it will not make you a hacker.  #####
#### Resepect all developers, we doing this because it's fun!              #####
####                                                                       #####
################################################################################
################################ SOURCE CODE ###################################
################################################################################
################################################################################
####                                                                       #####
####  Copyright (C) 2018-2019, wuseman                                     #####
####                                                                       #####
####  This program is free software; you can redistribute it and/or modify #####
####  it under the terms of the GNU General Public License as published by #####
####  the Free Software Foundation; either version 2 of the License, or    #####
####  (at your option) any later version.                                  #####
####                                                                       #####
####  This program is distributed in the hope that it will be useful,      #####
####  but WITHOUT ANY WARRANTY; without even the implied warranty of       #####
####  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        #####
####  GNU General Public License for more details.                         #####
####                                                                       #####
####  You must obey the GNU General Public License. If you will modify     #####
####  this file(s), you may extend this exception to your version          #####
####  of the file(s), but you are not obligated to do so.  If you do not   #####
####  wish to do so, delete this exception statement from your version.    #####
####  If you delete this exception statement from all source files in the  #####
####  program, then also delete it here.                                   #####
####                                                                       #####
####  Contact:                                                             #####
####          IRC: Freenode @ wuseman                                      #####
####          Mail: wuseman <wuseman@nr1.nu>                               #####
####                                                                       #####
################################################################################
################################################################################

iPV4="$(grep . /proc/net/fib_trie)"
iPV6="$(grep  '.' /proc/net/if_inet6)"; 

if [[ -n "${iPV4}" ]]; then 
printf "%25s\n" | tr ' ' '-'
printf "%s\n" "Removing all ipv4 rules"
iptables -P INPUT ACCEPT 
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -t nat -F &> /dev/null
iptables -t mangle -F &> /dev/null
iptables -F
iptables -X
printf "%s\n" "...Done"
fi

if [[ -n "${iPV6}" ]]; then 
printf "%25s\n" | tr ' ' '-'
printf "%s\n" "Removing all ipv6 rules"
ip6tables -P INPUT ACCEPT
ip6tables -P FORWARD ACCEPT
ip6tables -P OUTPUT ACCEPT
ip6tables -t nat -F &> /dev/null
ip6tables -t mangle -F &> /dev/null
ip6tables -F
ip6tables -X
printf "%s\n" "...Done"
fi
printf "%25s\n" | tr ' ' '-'
