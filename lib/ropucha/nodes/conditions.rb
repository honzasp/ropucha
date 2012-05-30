module Ropucha
  module Nodes

    class Compare < Node
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

      def to_condition_list(g, &block)
        to_condition(g, &block)
      end

      def to_condition(g)
        left.to_param_src(g) do |left_param_src|
          right.to_param_src(g) do |right_param_src|
            yield "param_src:#{left_param_src} lop:#{operator} param_src:#{right_param_src}"
          end
        end
      end
    end

  end
end
