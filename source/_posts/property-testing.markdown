---
layout: post
title: "Self generating data"
date: 2015-10-11 23:39:34 -0500
comments: true
authorId: amir_barylko
---
Every week I meet for [Code and Coffee](http://www.meetup.com/wpgcoffeecode) with other devs to chat about all kind of topics (often related to software) and lately we have been doing Katas from [CodeWars](http://codewars.com) under the _WpgDotNet_ clan.

This time around I was working with [@QuinnWilson](https://twitter.com/QuinnWilson) and [@AdamKrieger](https://twitter.com/AdamKrieger) doing the [Highest and lowest](http://www.codewars.com/kata/highest-and-lowest) Kata using Ruby and [RSpec](http://rspec.info).

Is a simple Kata but I wanted to put focus on TDD, self data generation and property testing...

<!--more-->

## The scenarios

I won't go into the TDD steps because I want to fast forward to data generation.

We created three tests, from the domain of the problem first we selected strings that contain only one number then the result should be that number as max and min.

{% codeblock lang:ruby %}
context 'When the string has only one number' do                       
  it 'Returns the same number twice' do                                
    str = "1"                                                          
    expect(highest_lowest str).to eq "1 1"                             
  end                                                                  
end   
{% endcodeblock %}

For our second scenario we thought that it would be easy if the sequence of numbers where already sorted, so the min and max are the `first` and `last`.                                                                 
{% codeblock lang:ruby %}
context 'When the numbers are sorted' do                               
  it 'returns the last and the first' do                               
    str = '-5 -2 8 12 32 150'                                          
    expect(highest_lowest str).to eq "150 -5"                          
  end                                                                  
end                                                                    
{% endcodeblock %}

The last scenario includes all the strings with sequence of integers.

{% codeblock lang:ruby %}
context 'For any string with one or more numbers separated by space' do
  it 'returns the max and the min' do                                  
    str = '22 -5 28 -294 33 1794 10000 2'                              
    expect(highest_lowest str).to eq "10000 -294"                      
  end                                                                  
end                                                                    
{% endcodeblock %}

Ruby has a `minmax` method on `Array` but we wanted to do it using a `fold`. So here is our implementation:

{% codeblock lang:ruby %}
def highest_lowest(str)
  str.split.map(&:to_i).inject([MIN, MAX]) do |mm, i|
    [[mm.first, i].max, [mm.last, i].min]
  end.join ' '
end                                                
{% endcodeblock %}

## Self generating data

We did write only one example on each scenario to start but now we wanted to cover more cases.

Not only I want to generate random data but I want to have a reasonable distribution of values and
describe it as a property that the function has to satisfy.

Libraries like [QuickCheck](https://hackage.haskell.org/package/QuickCheck) (for _Haskell_, main inspiration to others), [FsCheck](https://fscheck.github.io/FsCheck/) (for _F#_) and [ScalaCheck](https://www.scalacheck.org) (for _Scala_) do exactly that. For Ruby we used [Rantly](https://github.com/hayeah/rantly).

### Single integer
The first scenario requires a string with one _integer_.

To do that with _Rantly_ we can use the _integer_ generator `integer`. After converting it to a `string` we have the input for the test.

Imagine a property that looks like:

    Given a string with a single integer N
    The result is a string like "{N} {N}"

{% codeblock lang:ruby %}
it 'Returns the same number twice' do
  property_of {
    n = integer
    n.to_s
  }.check do |str, n|
    expect(highest_lowest str).to eq "#{n} #{n}"
  end
end
{% endcodeblock %}

_Rantly_ is going to generate 100 cases by default and _check_ to make sure the equality holds for all of them.

### Sorted integers

Having a sorted sequence of numbers is easy to specify where the min and max should be.

So the property could be something like (in pseudo formal but not so much english):

    Given an ordered string of integers
    Then the first is the MIN and the last is the MAX
    And the result is a string like "{MAX} {MIN}"    

{% codeblock lang:ruby %}
context 'When the numbers are sorted' do
  it 'returns the last and the first' do
    property_of {
      arr = array { integer }.sort
      [arr.join(' '), arr.last, arr.first]
    }.check { |str, max, min|
      expect(highest_lowest str).to eq "#{max} #{min}"
    }
  end
end
{% endcodeblock %}

### The general case

Thinking of the actual _postcondition_ of the problem, the property could be something like:

    Given any non empty collection of integers
    And exist MIN and MAX that belong to the collection
    Where MAX is the maximum and MIN is the minimum
    Then the result is a string like "{MAX} {MIN}"

Considering for a moment the domain (all the possible instances) of _any non empty collection of integers_. That would include sets of a single element and also sorted elements, thus we cover the other two scenarios.

I want to generate all the integers but at the same time have the max and min so I don't write the test duplicating the implementation to find maximum and minimum.

To do that, I will generate first the min and max and then add integers in between.

{% codeblock lang:ruby %}
it 'returns the max and the min' do
  property_of {
    min, max = [integer, integer].minmax
    arr = array { range min, max } + [max, min]
    [arr.shuffle.join(' '), max, min]
  }.check(200) do |str, max, min|
    expect(highest_lowest str).to eq "#{max} #{min}"
  end
end
{% endcodeblock %}

I changed the number of cases to _200_ just to illustrate how to override the default.

## Using properties

Properties can be very useful to help identify test cases plus data generation makes much easier to describe a scenario and find a domain for the test.

Having a combination of both _property testing_ and _example testing_ can be a good balance to have tests that are accurate and also descriptive.
