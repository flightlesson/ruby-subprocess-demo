#! /usr/bin/env ruby

require "open3"

def all_eof(files)
  files.find { |f| puts "all_eof: #{f.inspect}: #{f.eof ? 'EOF' : ''}"; !f.eof }.nil?
end

cmd = "Open3Subproc/subproc"
Open3.popen3(cmd) do |subin,subout,suberr|
  tsubout = Thread.new(subout) do |f|
    while 1 do
      line = f.readline
      puts "subout: #{line}"
    end
  end
  tsuberr = Thread.new do
    while 1 do
      line = suberr.readline
      puts "suberr: #{line}"
    end
  end

  while s = gets 
    subin.puts s
  end

  tsubout.join
  tsuberr.join
end

exit 0

puts "!"
Open3.popen3("Open3Subproc/subproc") do |subin,subout,suberr|
  puts "subin=#{subin.inspect}"
  puts "subout=#{subout.inspect}"
  puts "suberr=#{suberr.inspect}"
  subin.close_write
  begin 
    inputs = [subout,suberr]
    until all_eof(inputs) do
      ready = IO.select(inputs)
      puts "ready=#{ready.inspect}"
      if ready 
        readable = ready[0]
        puts "readable=#{readable.inspect}"
        readable.each do |f|
          puts "f=#{f.inspect}"
          fileno = f.fileno
          puts "fileno=#{fileno}"
          begin
            data = f.read_nonblock(4096);
            # puts "#{fileno}: >>#{data}<< "
          rescue EOFError => e
            puts "#{fileno}: EOF "
          end
        end
      end
    end
  rescue IOError => e
    puts "rescue: #{e}"
  end
end
