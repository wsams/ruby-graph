require_relative "ruby_graph"
require "test/unit"
require "digest"

class TestSimpleNumber < Test::Unit::TestCase
     
    def test_graph
        rg = RubyGraph.new
        rg.x_pos_offset = 20
        rg.x_neg_offset = 20
        rg.y_pos_offset = 200
        rg.y_neg_offset = 20
        rg.out_file = "graph-test.png"
        rg.graph

        assert_equal(Digest::SHA256.file("graph.png"), Digest::SHA256.file("graph-test.png"))
    end
       
end
