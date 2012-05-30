module Ropucha
  module Nodes

    class Node
      def initialize(syntax_node)
        @syntax_interval = syntax_node.interval
      end
    end

  end
end
