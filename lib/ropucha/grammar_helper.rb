module Ropucha
  module GrammarHelper
    module ArithmeticOperation
      def to_node
        tail.elements.inject(first.to_node) do |acc, operation|
          Nodes::Arithmetic.new(operation, operation.operator.to_sym, acc, operation.operand.to_node)
        end
      end
    end

    module ArithmeticOperator
      def to_sym
        text_value.to_sym
      end
    end
  end
end
