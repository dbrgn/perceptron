# A Perceptron in Ruby
#

# Some helper methods
def heaviside(x)
  x < 0 ? 0 : 1
end

def dot(a, b)
  a.zip(b).map { |x,y| x*y }.inject(:+)
end

# definitions for output
outmap = {
  -1 => '-',
   0 => '.',
   1 => '+'
}

training_data = [
  [[0, 0, 1], 0],
  [[0, 1, 1], 1],
  [[1, 0, 1], 1],
  [[1, 1, 1], 1],
]

weight = Array.new(3).map! { rand }
errors = []
eta = 0.2
n = 100

puts "initial weight: #{weight}"

n.times do
  data, expected = training_data.sample
  result = dot(weight, data)
  error = expected - heaviside(result)
  errors << error

  for i in 0...weight.size
    weight[i] += eta * error * data[i]
  end
end

training_data.each do |data,expected|
  result = dot(data, weight)
  correct = heaviside(result) == expected ? '✓' : '✗'
  puts "%s: % .17f -> %s %s" % [data[0,2], result, heaviside(result), correct]
end

puts "final weight: #{weight}"

# display the progress
puts errors.map { |e| outmap[e] }.join
