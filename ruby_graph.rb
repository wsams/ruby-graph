require "rubygems"
require 'png'

class RubyGraph
    # This is the number of pixels on the positive X-axis.
    attr_accessor :x_pos_offset
    # This is the number of pixels on the positive Y-axis.
    attr_accessor :y_pos_offset
    # This is the number of pixels on the negative X-axis.
    attr_accessor :x_neg_offset
    # This is the number of pixels on the negative Y-axis.
    attr_accessor :y_neg_offset
    attr_accessor :out_file

    def initialize
        @x_pos_offset = 20
        @x_neg_offset = 20
        @y_pos_offset = 200
        @y_neg_offset = 20
        @out_file = "graph.png"
    end

    # Internal: This method is responsible for filling in the gaps between plotted points
    #           to produce a smooth continous curve.
    def fill_empty_y(x, x_end, y_start, y_end, canvas)
        if x < x_end
            if x <= 0
                y_fill_start = yield(x) + 1
                y_fill_end = yield(x - 1) - 1
            else
                y_fill_start = yield(x) + 1
                y_fill_end = yield(x + 1) - 1
            end
            y_fill_mid = y_fill_start + ((y_fill_end - y_fill_start) / 2)
            y_fill_start.upto(y_fill_end) do |y_fill|
                if y_fill >= y_start && y_fill <= y_end
                    canvas[x + @x_neg_offset, y_fill + @y_neg_offset] = PNG::Color.new(255, 0, 0)
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

                if y == yield(x)
                    # 255,0,0:red
                    r = 255
                    g = 0
                    b = 0
                end

                canvas[x + @x_neg_offset, y + @y_neg_offset] = PNG::Color.new(r, g, b)
            end

            fill_empty_y(x, x_end, y_start, y_end, canvas) { |x| yield(x) }
        end
        png = PNG.new(canvas)
        png.save(@out_file)
    end
end

rg = RubyGraph.new
rg.graph { |x| (x ** 2).round }
