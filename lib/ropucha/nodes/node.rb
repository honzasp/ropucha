module Ropucha
  module Nodes

    class Node
      def initialize(syntax_node)
        @syntax_interval = syntax_node.interval
      end

      def load_to(g, param_dest)
        to_param_src(g) do |param_src|
          g.load param_dest, param_src
        end
      end
    end

  end
end
