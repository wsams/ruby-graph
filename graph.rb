require "rubygems"
require 'png'

class RubyGraph
    # Precision is not functional at this point
    attr_accessor :x_precision
    attr_accessor :y_precision

    # These values determine where the X and Y axis lies.
    attr_accessor :x_pos_offset
    attr_accessor :y_pos_offset
    attr_accessor :x_neg_offset
    attr_accessor :y_neg_offset

    def initialize
        @x_precision = 1
        @y_precision = 1

        @x_pos_offset = 20
        @x_neg_offset = 20
        @y_pos_offset = 200
        @y_neg_offset = 20
    end

    # Internal: This is where you define the equation you want to graph
    def fn x
        x ** 2
    end

    def fill_empty_y(x, x_end, y_start, y_end, canvas)
        if x < x_end
            if x <= 0
                y_fill_start = (fn(x + 1) + 1)
                y_fill_end = (fn(x) - 1)
            else
                y_fill_start = fn(x) + 1
                y_fill_end = fn(x + 1) - 1
            end
            y_fill_mid = y_fill_start + ((y_fill_end - y_fill_start) / 2)
            y_fill_start.upto(y_fill_end) do |y_fill|
                if y_fill >= y_start && y_fill <= y_end
                    if x < 0
                        x_val = x
                    else
                        x_val = x
                    end
                    if y_fill <= y_fill_mid
                        canvas[x_val + @x_neg_offset, y_fill + @y_neg_offset] = PNG::Color.new(255, 0, 0)
                    else
                        canvas[x_val + @x_neg_offset, y_fill + @y_neg_offset] = PNG::Color.new(255, 0, 0)
                    end
                end
            end
        end
    end

    # Public: Call this method to produce graph.png
    def graph
        x_start = -1 * @x_neg_offset;
        x_end = @x_pos_offset;
        y_start = -1 * @y_neg_offset;
        y_end = @y_pos_offset;
        canvas = PNG::Canvas.new(@x_pos_offset + @x_neg_offset + 1, @y_pos_offset + @y_neg_offset + 1);
        x_start.upto(x_end) do |x|
            y_start.upto(y_end) do |y|
                # 255,255,255:white 0,0,0:black
                r = g = b = x == 0 || y == 0 ? 0 : 255

                if y == fn(x)
                    # 255,0,0:red
                    r = 255
                    g = 0
                    b = 0
                end

                canvas[x + @x_neg_offset, y + @y_neg_offset] = PNG::Color.new(r, g, b)
            end

            fill_empty_y(x, x_end, y_start, y_end, canvas)
        end
        png = PNG.new(canvas)
        png.save("graph.png")
    end
end

rg = RubyGraph.new
rg.graph
