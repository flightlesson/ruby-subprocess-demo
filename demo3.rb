#! /usr/bin/env ruby

require "open3"

class ProcessRunner
  
  #
  def run(cmd)
    @subin, subout, suberr, @wait_thr = Open3.popen3(cmd)

    puts "started #{cmd} as pid=#{@wait_thr.pid}"
    STDOUT.flush

    @tsubout = Thread.new(subout) do |f|
      puts "reading cmd's stdout"
      begin
        while 1 do
          line = f.readline
          puts "subout: #{line}"
          STDOUT.flush
        end
      rescue Exception => e
        puts "Exception: tsubout => #{e.to_s}"
        STDOUT.flush
      end
    end

    @tsuberr = Thread.new(suberr) do |f|
      puts "reading cmd's stderr"
      begin
        while 1 do
          line = f.readline
          puts "suberr: #{line}"
          STDOUT.flush
        end
      rescue Exception => e
        puts "Exception: tsuberr => #{e.to_s}"
        STDOUT.flush
      end
    end
  end

  # signal: "TERM", "HUP", "KILL", etc.
  # grace: if grace > 0 and process still running after grace seconds, send "KILL" signal
  def kill(signal="TERM",grace=0)
    puts "kill #{@wait_thr.pid}"
    STDOUT.flush
    Process.kill signal, @wait_thr.pid
    t = Thread.new do
      if grace > 0
        sleep grace
        Process.kill "KILL", @wait_thr.pid
      end
    end
    Process.wait(@wait_thr.pid)
    t.join
  end

  def join
    status = @wait_thr.join
    @tsuberr.join
    @tsubout.join
  end

end

puts "Constructing ProcessRunner"
p1 = ProcessRunner.new
puts "running ./hardToKill"
p1.run("./hardToKill")
puts "sleep 8"
sleep(8)
puts "killing p1"
p1.kill("TERM",12)
puts "all done"









