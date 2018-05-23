#!/usr/bin/python
#
#   tapinfo.py : List TAP device info for running VMs
#
#   2010/01/20 ver1.0
#   2010/01/21 ver1.1
#
# Copyright (C) 2010 Etsuji Nakai
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

import libvirt
import os
import re
from xml.dom import minidom

Conn = libvirt.open( "qemu:///system" )

def showTaps():
    vnetRe = re.compile( "vnet\d+" )
    fmt = "%-16s %-12s %-18s %-12s %-12s"
    print fmt % ( "Domain", "Tap", "MAC Address", "Network", "Bridge" )
    for id in Conn.listDomainsID():
        print "-" * 78
        vm = Conn.lookupByID( id )
        vmXMLDesc = minidom.parseString( vm.XMLDesc( 0 ) )
        for iface in vmXMLDesc.getElementsByTagName( "interface" ):
            ifaceType = iface.getAttribute( "type" )
            if ifaceType == "network":
                network = iface.getElementsByTagName( "source" )[0].getAttribute( "network" )
                netXMLDesc = minidom.parseString( Conn.networkLookupByName( network ).XMLDesc( 0 ) )
                bridge = netXMLDesc.getElementsByTagName( "bridge" )[ 0 ].getAttribute( "name" )
            elif ifaceType == "bridge":
                network = ""
                bridge = iface.getElementsByTagName( "source" )[0].getAttribute( "bridge" )
            mac = iface.getElementsByTagName( "mac" )[0].getAttribute( "address" )
            device = iface.getElementsByTagName( "target" )[0].getAttribute( "dev" )
            print fmt % ( vm.name(), device, mac, network, bridge )

if __name__ == "__main__":
    showTaps()
    print
