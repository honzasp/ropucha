module Ropucha
  module Nodes

    module HasValue
      def to_condition_list(g, &block)
        to_condition(g, &block)
      end

      def to_condition(g)
        to_param_src(g) do |param_src|
          yield "param_src:#{param_src} lop:!= param_src:bool_num:0"
        end
      end
    end

  end
end
