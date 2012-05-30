module Ropucha
  module Nodes

    class Variable < Node
      def initialize(syntax_node, name)
        super(syntax_node)
        @name = name
      end

      attr_reader :name

      def to_sexp
        [:var, @name]
      end

      def to_param_dest(g)
        yield "var:#{tsk_variable_name}"
      end

      def to_param_src(g)
        yield "var:#{tsk_variable_name}"
      end

      def tsk_variable_name
        name
      end
    end

  end
end