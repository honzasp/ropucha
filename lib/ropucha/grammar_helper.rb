require 'ropucha/nodes/node'
require 'ropucha/nodes/conditions'
require 'ropucha/nodes/arithmetic'

module Ropucha
  module GrammarHelper

    module LeftAssocOperation
      def to_node
        tail.elements.inject(first.to_node) do |acc, operation|
          node_class.new(operation, operation.operator.to_sym, acc, operation.operand.to_node)
        end
      end
    end

    module ArithmeticOperation
      include LeftAssocOperation
      def node_class; Nodes::Arithmetic; end
    end

    module LogicOperation
      include LeftAssocOperation
      def node_class; Nodes::Logic; end
    end

    module Operator
      def to_sym
        text_value.to_sym
      end
    end
  end
end
