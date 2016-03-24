---
title: Idiomatic Iterative Design
layout: post
tags:
  - design
  - ruby
  - functional
categories:
  - Design
authorId: amir_barylko
date: 2016-03-23 16:00:00 
originalurl: http://orthocoders.com/blog/2016/02/16/idiomatic-iterative-design/
---

Lately I have been having fun solving the [AdventOfCode](http://adventofcode.com). I mainly used _Haskell_ to solve each day so I can learn a bit about _Haskell_ and as a byproduct _VIM_ as well.

In the last [Ruby Meetup](http://winnipegrb.org) we used [Day 7](http://adventofcode.com/day/7) to illustrate how to use [Rantly](https://github.com/abargnesi/rantly) for properties testing.

It was my first try to solve _Day 7_ using [Ruby](https://github.com/amirci/adventofcode_rb), and I wanted to find an _elegant_, _idiomatic_, _short_ way to do it...

<!-- more -->

## Before we start

First I want to give a very big shout out to [Eric Wastl](http://was.tl/) for creating the [Advent Of Code](http://adventofcode.com/).

Try it out, and if you like it let [Eric](https://twitter.com/ericwastl) know!

## Exploring the problem

SPOILER ALERT: Yes, we are going to talk about _Day 7_ and how to implement the solution. Feel free to do it on your own first.

The problem describes a circuit board with instructions to apply signals to circuits using bitwise logic operations.

The operations are:

    - 123 -> x means that the signal 123 is provided to wire x.
    - x AND y -> z means that the bitwise AND of wire x and wire y 
      is provided to wire z.
    - p LSHIFT 2 -> q means that the value from wire p is left-shifted by 2 
      and then provided to wire q.
    - NOT e -> f means that the bitwise complement of the value from 
      wire e is provided to wire f.

    Other possible gates include OR (bitwise OR) and RSHIFT (right-shift).

I implemented the solution in [Haskell](https://github.com/amirci/adventofcode_hs) and found out that not only the parsing was the challenge but also the fact that you get a list of instructions that can be in any order, so some instructions when evaluated may result in having no signal (no value).

For example, let's consider the following sequence of instructions:

    lx -> a
    456 -> lx

When evaluating the first instruction, the wire `lx` has no signal yet, so it has to be reevaluated later.

Of course you could create an evaluation tree but that seemed a bit too much for the problem at hand. So I decided to do the following:

1. Parse instructions into commands
2. Repeat evaluating commands until all pass
3. Return the value of wire "a" from the board

## The _classy_ way

As soon as I read about _instructions_ my mind started to race thinking about _parsing_ and _patterns_.

My first thought was I could use the [Interpreter Pattern](https://en.wikipedia.org/wiki/Interpreter_pattern) to build a hierarchy of classes to evaluate expressions. But it seemed like an overkill.

Therefore, I decided to use classes to represent each command:

``` ruby
class AndCmd    ; end
class OrCmd     ; end
class LShiftCmd ; end
class RShiftCmd ; end
class NotCmd    ; end
class EvalCmd   ; end
```

Each _class_ has two methods with clear responsibilities:

- `parse(token1, token2, token3..., wire)` Class factory method that parses the command and returns an instance of the command.

- `wireIt(board)` Instance method that evaluates the command to assign the result of the operation to the target wire.

The constructor of the class stores the operands and target wire.

``` ruby
class AndCmd
  def initialize(lhs, rhs, wire) ; @lhs, @rhs, @wire = [lhs, rhs, wire] end
  def wireIt(board) 
    # asign the @lhs & @rhs to the board
  end
  def self.parse(....)
    # parse the string to match the AND command and return a new instance
  end
end
```

The `parse` factory method receives the expected tokens. If the `cmd` token matches the string `"AND"` then returns an instance of `AndCmd`.

``` ruby
def self.parse(x, cmd, y, arrow, z)
  AndCmd.new(x, y, z) if cmd == "AND"
end
```

### Abstracting the board

Evaluating the command was more complex because the values could be undefined. Some kind of validation was necessary.

I started using a `Hash` as a _CircuitBoard_ and then checking if the values were defined. It got a bit more complicated when I realized I had to parse values, because I could get `lx AND lb` and also `1 AND ll`.

Inspired by my _Haskell_ solution I thought that a class that implements a _short circuit_ evaluation could be very useful. That way, if one of the involved values was not defined the whole command was undefined.

To simplify board access and evaluation I created a `Board` class that handles the assignment plus the lookup.

The `assign` method takes a block that gets evaluated if all the values are defined, otherwise it is ignored.

``` ruby
class Board
  attr_reader :wires                                           
  def initialize ; @wires = {} end                             
  def [](y) ; @wires[y] end

  def assign(wire, *exprs)                                     
    values = exprs.map { |exp| value exp }                     
    return nil if values.any?(&:nil?)·                         
    @wires[wire] = block_given? ? yield(*values) : values[0]   
  end                                                          

  private·                                                     
  def value(exp)                                               
    /\d+/.match(exp) ? exp.to_i : @wires[exp]                  
  end                                                          
end                                                            
```

This simplifies things quite a bit. Now the `wireIt` implementation only applies the operation when all the values are defined:

``` ruby
def wireIt(board)
  board.assign(@wire, @lhs, @rhs) { |l, r| l & r }
end
```

### Parsing instructions into commands

To parse the string I created a `parse` method that splits the instruction into tokens (words) and finds a parsing factory method with the same amount of parameters that returns an actual instance of the command. 

This is similar to a [chain of responsibility](https://en.wikipedia.org/wiki/Chain-of-responsibility_pattern) where the parser tries to parse the instruction. If the parser cannot do it then the parser passes the instruction to the next parser in the chain until one of them succeeds.  If no parser succeeds, `nil` is returned.


``` ruby
def parse(instruction)                                              
  tokens = instruction.split                                        
  [AssignCmd, AndCmd, OrCmd, RightShiftCmd, LeftShiftCmd, NotCmd]   
    .map    { |k| k.method(:parse) }                                
    .select { |m| m.parameters.length == tokens.length }            
    .map    { |m| m.call(*tokens) }                                 
    .find   { |cmd| cmd }·                                          
end                                                                 
```

### The main loop

The last bit of the exercise is to keep evaluating all commands until there are no failing commands left.

``` ruby
def wire(instructions)                                  
  cmds = instructions.map(&method(:parse))              
  board = Board.new                                     
  while !cmds.empty?                                    
    cmds = cmds.select { |cmd| cmd.wireIt(board).nil? } 
  end                                                   
  board                                                 
end                                                     
```

You can see the complete source [here](https://github.com/amirci/adventofcode_rb/blob/master/lib/day7_v2.rb).

## The _Ruby_ way

After finishing the implementation using classes I started to wonder what would be more idiomatic to _Ruby_.

Classes are fine, but I wanted to explore the _dynamic_ aspect of _Ruby_ and use `eval`.

### Parsing instructions

Instead of having a `Class` factory method to parse, I declared `parse_xxx` functions that return a string to be evaluated later for the expected command.

``` ruby
def board(exp) ; "board['#{exp}']" end

def expr(exp) ; /\d+/.match(exp) ? exp : board(exp) end

def parse_and(x, cmd, y, arrow, z) 
  cmd == "AND" && "#{board z} = #{expr x} & #{board y}" 
end
```

The main `parse` function now uses the `parse_xxx` functions instead. The parse chooses the function that has the same amount of parameters as the tokens in the instructions and also returns a string with the expression to be evaluated.

``` ruby
def parse(instruction)
  tokens = instruction.split
  [:parse_assign, :parse_and, :parse_or, :parse_rshift, :parse_lshift, :parse_not]
  .map    { |s| method(s) }
  .select { |m| m.parameters.length == tokens.length }                           
  .map    { |m| m.call(*tokens) }
  .find   { |cmd| cmd }
end
```

### The main loop

The main loop is very similar to the main loop of the _classy version_ with the difference that to get the actual value, `eval` is called for every command. If the command succeeds, the evaluation will return some kind of number.

``` ruby
def wire(instructions)                                                     
  cmds = instructions.map { |line| self.parse line }                       
  board = {}                                                               
  while !cmds.empty?·                                                      
    cmds = cmds.reject { |cmd| (eval(cmd) rescue nil).kind_of? Fixnum }    
  end                                                                      
  board                                                                    
end                                                                        
```

### The result

The solution seems simpler than using classes. The strings make each command quite transparent.

Probably, even the parsing could be combined into one function and reduce the amount of functions in general.

You can see the complete solution [here](https://github.com/amirci/adventofcode_rb/blob/master/lib/day7_v3.rb).


## The _functional_ way

After the _Classy_ and _Ruby_ way I wanted to see if I could be a bit more functional.

The approach this time was to parse the instruction into a `lambda` that will evaluate the actual command.

I decided to reuse the `Board` class from the first solution to make the value evaluation easier and implement a short circuit when a value is not yet defined.

### Parsing instructions into commands

Third time’s the charm! I reduced the amount of parsing functions by having a binary parsing function that uses a hash to decide which operation to apply.

``` ruby
def parse_bin(x, cmd, y, arrow, wire)                                 
  op = {"AND" => :&, "OR" => :|, "LSHIFT" => :<<, "RSHIFT" => :>>}[cmd]
  op && -> (board) { board.assign(wire, x, y, &op) }
end
```

The hash lookup  decides which operation to use. 

The general `parse` function is similar to the _Ruby_ way:

``` ruby
def parse(instruction)
 tokens = instruction.split
 [:parse_assign, :parse_bin, :parse_not]
   .map    { |s| method(s) }
   .select { |m| m.parameters.length == tokens.length }
   .map    { |m| m.call(*tokens) }
   .find   { |cmd| cmd }
end
```

### The main loop

Instead of using `eval`, the `call` method is used on each `lambda` to evaluate the command.

``` ruby
def wire(instructions)
  cmds = instructions.map { |line| parse line }
  board = Board.new
  while !cmds.empty?
    cmds = cmds.select { |cmd| cmd.call(board).nil? }
  end
  board
end
```

You can see the entire solution [here](https://github.com/amirci/adventofcode_rb/blob/master/lib/day7_v4.rb).

## The verdict

The version I like the most is the `eval` version because it is simple and straightforward.

The second best option, in my opinion, is the _functional_ version because it uses  the bitwise logic operators as functions.

Last but not least is the _classy_ version. Using instances of classes does not seem to be necessary for this exercise because all parameters can be captured when creating the `lambda` closure for each instruction.

Which one is would __you__ choose?


