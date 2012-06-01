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

      def context(ctx)
        definitions.each { |d| d.context(ctx) }
        @main = ctx.main
        @subroutine_defs = ctx.subroutine_defs
      end

      def compile(g)
        g.version = "2.05"
        g.platform = "bioloid2"
        g.file do |g|
          @main.compile(g)
          @subroutine_defs.each {|d| d.compile(g) }
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

      def context(ctx)
        ctx.main = self
        block.context(ctx)
      end

      def compile(g)
        g.main do
          block.compile(g)
        end
      end
    end

    class Devices < Node
      def initialize(syntax_node, device_name_defs)
        super(syntax_node)
        @device_name_defs = device_name_defs
      end

      attr_reader :device_name_defs

      def context(ctx)
        @device_name_defs.each { |d| d.context(ctx) }
      end

      def to_sexp
        [:devices, device_name_defs.map(&:to_sexp)]
      end
    end
  end
end
