#!/usr/bin/expect -f

#check arguments
if {$argc < 1} {
	puts "Usage: $argv0 <host> \[<file> ...\]"
	puts " <host> remote host"
	puts " <file> transfered file"
	exit
}

#export the files to the board
spawn ftp [lindex $argv 0]
expect "Name *: "
send "ftp\r"
expect "Password:"
send "ftp\r"
for {set i 1} {$i < $argc} {incr i} {
	expect "ftp> "
	send "put [file join [pwd] [lindex $argv $i]] [file tail [lindex $argv $i]]\r"
}
expect "ftp> "
send "bye\r"

#open telnet
spawn telnet [lindex $argv 0] 9000
expect ".*: "
send "root\r"
expect "/> "
send "cd /home/ftp\r"
for {set i 1} {$i < $argc} {incr i} {
	expect "/home/ftp> "
	send "chmod 777 [file tail [lindex $argv $i]]\r"
}
expect "/home/ftp> "
interact
