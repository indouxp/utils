#!/bin/sh

time (echo 192.168.0.{1..254} | xargs -P256 -n1 ping -s1 -c1 -W1 | grep ttl)
