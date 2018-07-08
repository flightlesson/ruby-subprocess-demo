#! /usr/bin/env ruby

require "open3"

def all_eof(files)
  files.find { |f| puts "all_eof: #{f.inspect}: #{f.eof ? 'EOF' : ''}"; !f.eof }.nil?
end

cmd = "Open3Subproc/subproc"
subin, subout, suberr, wait_thr = Open3.popen3(cmd)
puts "subin=#{subin.inspect}"
puts "subout=#{subout.inspect}"
puts "suberr=#{suberr.inspect}"
puts "wait_thr=#{wait_thr.inspect}"

tsubout = Thread.new(subout) do |f|
  begin
    while 1 do
      line = f.readline
      puts "subout: #{line}"
    end
  rescue Exception => e
    puts "Exception: tsubout => #{e.to_s}"
  end
end

tsuberr = Thread.new do
  begin
    while 1 do
      line = suberr.readline
      puts "suberr: #{line}"
    end
  rescue Exception => e
    puts "Exception: tsuberr => #{e.to_s}"
  end
end

rdr = Thread.new do
  subin.puts "one"
  sleep 2
  subin.puts "two"
  sleep 2
  subin.puts "QUIT"
  sleep 2
end

status = wait_thr.value
puts "status=#{status}"

tsubout.join
tsuberr.join

rdr.kill 
rdr.join

