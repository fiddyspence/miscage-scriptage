#!/bin/ruby

$mylog = "#{ENV['HOME']}/wifilog.log"
filehandle=File.open($mylog,'w')
$lines = File.readlines('/var/log/messages').count
while true do
  $log = File.readlines('/var/log/messages')
  nowlines = $log.count
  if nowlines < $lines
    $lines = 0
  end
  if nowlines > $lines
    loopstart = $lines
    while loopstart < $log.count do
      begin
        if $log[loopstart.to_int] =~ /DHCPREQUEST/
        #   system("bin/nmap -O -vvv #{$log[loopstart.to_int].split(' ')[7]} >> #{$mylog}")
         runcommand = true
        end
      rescue => e
        puts "#{e.message}"
      end
      if runcommand
        begin
          system("/bin/nmap -O -vvv #{$log[loopstart.to_int].split(' ')[7]} >> #{$mylog}")
        rescue => e
          puts "#{e.message}"
        end
        runcommand = false
      end
      loopstart+=1
    end
  end
  $lines = nowlines
  sleep 5
end
