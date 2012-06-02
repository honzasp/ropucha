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

      def context(ctx)
        left.context(ctx)
        right.context(ctx)
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

    class Logic < Node
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

      def tsk_operator
        case operator
        when :and
          "&&"
        else
          "||"
        end
      end

      def to_condition_list(g)
        left.to_condition_list(g) do |left_conditions|
          right.to_condition(g) do |right_condition|
            yield "#{left_conditions} rop:#{tsk_operator} #{right_condition}"
          end
        end
      end

      def to_condition(g)
        g.tmp_var do |tmp|
          to_condition_list(g) do |conds|
            g.if_(conds) do 
              g.load("var:#{tmp}", "bool_num:1")
            end
            g.else_ do
              g.load("var:#{tmp}", "bool_num:0")
            end

            yield "param_src:var:#{tmp} lop:!= param_src:bool_num:0"
          end
        end
      end

    end
  end
end
