module Ropucha
  module Nodes

    class Arithmetic < Node
      def initialize(syntax_node, operator, left, right)
        super(syntax_node)
        @operator = operator
        @left = left
        @right = right
      end

      attr_reader :operator
      attr_reader :left
      attr_reader :right

      def to_sexp
        [operator, left.to_sexp, right.to_sexp]
      end

      def context(ctx)
        left.context(ctx)
        right.context(ctx)
      end

      def load_to(g, param_dest)
        left.to_param_src(g) do |left_param_src|
          right.to_param_src(g) do |right_param_src|
            g.compute(param_dest, operator, left_param_src, right_param_src)
          end
        end
      end

      def to_param_src(g)
        g.tmp_var do |tmp|
          load_to(g, tmp)
          yield tmp
        end
      end
    end

  end
end

