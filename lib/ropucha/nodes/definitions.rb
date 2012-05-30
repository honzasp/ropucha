module Ropucha
  module Nodes

    class Program < Node
      def initialize(syntax_node, definitions)
        super(syntax_node)
        @definitions = definitions
      end

      attr_reader :definitions

      def to_sexp
        [:ropucha, definitions.map(&:to_sexp)]
      end

      def compile(g)
        g.version = "2.05"
        g.platform = "bioloid2"
        g.file do |g|
          main.compile(g)
        end
      end

      def main
        found = @definitions.select { |d| d.kind_of? Main }
        if found.size == 1
          found[0]
        else
          raise CompileError, "There are #{found.size} main definitions, but one is needed"
        end
      end
    end

    class Main < Node
      def initialize(syntax_node, block)
        super(syntax_node)
        @block = block
      end

      attr_reader :block

      def to_sexp
        [:main, block.to_sexp]
      end

      def compile(g)
        g.main do
          block.compile(g)
        end
      end
    end
  end
end
