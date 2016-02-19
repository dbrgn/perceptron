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

using Refinements

# definitions for output
OUTMAP = {
  -1 => '-',
  0 => '.',
  1 => '+'
}
OK  = "\e[0;32m✓\e[m\e[m"
NOK = "\e[0;31m✗\e[m\e[m"

# constant data
TRAINING_DATA = [
  [[0, 0, 1], 0],
  [[0, 1, 1], 1],
  [[1, 0, 1], 1],
  [[1, 1, 1], 1]
]
ETA = 0.2
N = 100

# runtime data
weight = Array.new(3).map! { rand }
errors = []

puts "initial weight: #{weight}"

N.times do
  data, expected = TRAINING_DATA.sample
  result = data.dot(weight)
  error = expected - result.heaviside
  errors << error

  (0...weight.size).each do |i|
    weight[i] += ETA * error * data[i]
  end
end

# output for control
TRAINING_DATA.each do |data, expected|
  result = data.dot(weight)

  correct = result.heaviside == expected ? OK : NOK
  puts format('%s: % .7f -> %s %s',
              data[0, 2],
              result,
              result.heaviside,
              correct)
end

puts "final weight: #{weight}"

# display the progress
puts errors.map { |e| OUTMAP[e] }.join
