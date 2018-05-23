#!/usr/bin/python
#
#   brinfo.py :  List bridge info for running VMs
#
#   2011/01/24 ver1.0 
#   2011/01/27 ver1.1   some golfing...
#   2012/05/05 ver1.2   modifed regular expression for RHEL6
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
import commands
from xml.dom import minidom

Conn = libvirt.open( "qemu:///system" )
VmName, NetName, MacAddr = {}, {}, {}

def getTaps():
    for id in Conn.listDomainsID():
        vm = Conn.lookupByID( id )
        vmXMLDesc = minidom.parseString( vm.XMLDesc( 0 ) )
        for iface in vmXMLDesc.getElementsByTagName( "interface" ):
            tapDevice = iface.getElementsByTagName( "target" )[0].getAttribute( "dev" )
            VmName[ tapDevice ] = vm.name()
            MacAddr[ tapDevice ] = iface.getElementsByTagName( "mac" )[0].getAttribute( "address" )

def getNetworks():
    for net in Conn.listNetworks():
        network = Conn.networkLookupByName( net )
        NetName[ network.bridgeName() ] = net

def showBridges():
    fmt = "%-12s %-12s %-12s %-16s %-18s"
    bridgeAndDeviceRe = re.compile( "^(\S+)?\s+.*\s+(\S+)?$" )

    print fmt % ( "Bridge", "Netowrk", "Device", "Domain", "MAC Address" )

    brshow = commands.getoutput( "/usr/sbin/brctl show" ).split( "\n" )
    brshow.pop(0)
    for line in brshow:
        ( bridge, device ) = bridgeAndDeviceRe.search( line ).groups()
        if bridge == None: bridge = ""
        if device == None: device = ""

        network = NetName.get( bridge, "" )
        vm = VmName.get( device, "" )
        mac = MacAddr.get( device, "" )

        if bridge != "": print "-" * 78
        print fmt % ( bridge, network, device, vm, mac )

if __name__ == "__main__":
    getTaps()
    getNetworks()
    showBridges()
    print
