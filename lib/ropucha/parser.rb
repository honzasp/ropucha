require 'treetop'

Treetop.load(File.expand_path("../grammar.treetop", __FILE__))

module Ropucha
  class ParseError < ::RuntimeError
  end

  class Parser
    def initialize(program)
      @program = program
    end

    def parse
      parser = Ropucha::RopuchaGrammarParser.new
      if syntax_tree = parser.parse(@program)
        @root_node = syntax_tree.to_node
      else
        raise ParseError, "Parse error: #{parser.failure_reason}"
      end
    end

    def root_node
      @root_node
    end
  end
end
