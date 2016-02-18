# A Perceptron in Ruby

# Some helper methods
module Refinements
  refine Numeric do
    def heaviside
      self < 0 ? 0 : 1
    end
  end

  refine Array do
    def dot(other)
      zip(other).map { |x, y| x * y }.inject(:+)
    end
  end
end

# definitions for output
OUTMAP = {
  -1 => '-',
  0 => '.',
  1 => '+'
}.freeze

TRAINING_DATA = [
  [[0, 0, 1], 0],
  [[0, 1, 1], 1],
  [[1, 0, 1], 1],
  [[1, 1, 1], 1]
].freeze

N = 100

# A simple perceptron classifier.
class Perceptron
  using Refinements
  ETA = 0.2

  attr_accessor :weight, :errors

  def initialize(size)
    @size = size
    @weight = Array.new(@size).map! { rand }
    @data = Array.new(@size)
    @errors = []
  end

  # Update the Perceptron with new data to work with.
  def update(data)
    @data = data
  end

  # calculate the normalized (heaviside) result based on the current ``@data`
  def result
    raw_result.heaviside
  end

  # calculate the result based on the current `@data`
  def raw_result
    @data.dot(weight)
  end

  # update the `@weight`s based on the current `@data`
  def train(error)
    @errors << error

    (0...@size).each do |i|
      @weight[i] += ETA * error * @data[i]
    end
  end
end

p = Perceptron.new(3)

puts "initial weight: #{p.weight}"

N.times do
  data, expected = TRAINING_DATA.sample
  p.update data
  error = expected - p.result
  p.train(error)
end

TRAINING_DATA.each do |data, expected|
  p.update data
  ok, nok = "\e[0;32m✓\e[m\e[m", "\e[0;31m✗\e[m\e[m"
  correct = p.result == expected ? ok : nok
  puts format('%s: % .7f -> %s %s', data[0, 2], p.raw_result, p.result, correct)
end

puts "final weight: #{p.weight}"

# display the progress
puts p.errors.map { |e| OUTMAP[e] }.join
