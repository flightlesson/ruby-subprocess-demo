#! /usr/bin/env ruby

class Stack

  def initialize
    @stack = []
  end

  def push(x)
    @stack.push x
  end

  def pop
    @stack.pop x
  end

  def display(h)
    puts h + ": " + @stack.join('+')
  end

  def getStack
    @stack
  end

  def initialize_copy(old)
    @stack = []
    old.getStack.each { |x| @stack.push x }
  end
end

s1 = Stack.new
s1.push("dogs")
s1.push("rabbits")
s1.display("s1")

s2 = s1.clone
s2.push("cats")

s3 = s1.clone
s3.push("horses")


s1.display("s1")
s2.display("s2")
s3.display("s3")

