#!/usr/bin/ruby

part, file_path = $*
file = File.open(file_path, 'r')
#noinspection RubyNilAnalysis
enhancement = file.gets.rstrip.chars.map { |b| b == ?# }

img = []
while (line = file.gets)
  break unless line
  line = line.strip
  next if line.empty?
  img = img.push line.chars.map { |b| b == ?# }
end

class Img
  @data
  def initialize(data)
    @data = data
  end

  def height
    @data.size
  end

  def width
    @data[0].size
  end

  def [](y, x)
    if y < 0 or y >= @data.size or x < 0 or x >= @data.size
      return false
    end
    @data[y][x]
  end

  def print
    @data.each { |line| puts line.map {|b| b ? '#' : '.'}.join }
  end

  def count_light
    cnt = 0
    @data.each { |line| line.each { |b| cnt += 1 if b } }
    cnt
  end

  def pad(padding)
    x_padding = [false] * padding
    Img.new Array.new(self.height + 2 * padding) { |y|
      y -= padding
      if y >= 0 and y < @data.size
        x_padding + @data[y] + x_padding
      else
        Array.new(self.width + 2 * padding, false)
      end
    }
  end

  def enhance(lookup)
    result = Array.new(self.height) { Array.new(self.width) }
    (0...self.height).each { |y|
      (0...self.width).each { |x|
        val = 0
        i = 0b1_0000_0000
        (-1..1).each { |dy|
          (-1..1).each { |dx|
            if self[y + dy, x + dx]
              val |= i
            end
            i >>= 1
          }
        }
        result[y][x] = lookup[val]
      }
    }
    Img.new result
  end

  def cut_out(margin)
    Img.new Array.new(self.height - 2 * margin) { |i| @data[i+margin][margin..self.width-margin] }
  end
end

img = Img.new img
img.print
puts

case part
when "part01"
  puts img.pad(12).enhance(enhancement).enhance(enhancement).cut_out(10).count_light
when "part02"
  img = img.pad(100)
  (1..50).each { |i|
    puts "step #{i}"
    img = img.enhance(enhancement)
  }
  puts img.cut_out(50).count_light
else
  puts "unknown subcommand"
end
