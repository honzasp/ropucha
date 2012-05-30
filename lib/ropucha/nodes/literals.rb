module Ropucha
  module Nodes

    class Literal < Node
      def load_to(g, param_dest)
        g.load(param_dest, param_src)
      end

      def to_param_src(g)
        yield param_src
      end
    end

    class Number < Literal
      def initialize(syntax_node, value)
        super(syntax_node)
        @value = value
      end

      attr_reader :value
    end

    class DecimalNumber < Number
      def to_sexp
        [:number, value]
      end

      def param_src
        "dec_num:#{value}"
      end
    end

    class BinaryNumber < Number
      def to_sexp
        [:binary, value]
      end

      def param_src
        "bin_num:#{value}"
      end
    end

    class Boolean < Literal
      def initialize(syntax_node, value)
        super(syntax_node)
        @value = !!value
      end

      attr_reader :value

      def to_sexp
        [:boolean, @value]
      end

      def param_src
        "bool_num:#{value ? "1" : "0"}"
      end
    end

    class DirectionNumber < Literal
      def initialize(syntax_node, number, direction)
        super(syntax_node)
        @number = number
        @direction = direction
      end

      attr_reader :number
      attr_reader :direction

      def to_sexp
        [:direction_number, @number, @direction]
      end

      def value
        if @direction == :ccw
          @number
        else
          @number + 1024
        end
      end

      def param_src
        "dir_num:#{value}"
      end
    end

    class PositionNumber < Literal
      def initialize(syntax_node, number)
        super(syntax_node)
        @number = number
      end

      attr_reader :number

      def to_sexp
        [:position_number, @number]
      end

      def param_src
        "position_num:#{number}"
      end
    end

    class GenericButtons < Literal
      def initialize(syntax_node, buttons)
        super(syntax_node)
        @buttons = buttons
      end

      attr_reader :buttons

      def value
        @buttons.map{|b| self.class::BUTTON_VALUES[b]}.inject{|a,b| a+b}
      end
    end

    class Buttons < GenericButtons
      BUTTON_NAMES = {}
      %w{up left down right start}.each do |button_name|
        BUTTON_NAMES[button_name] = button_name.to_sym
        BUTTON_NAMES[button_name[0..0]] = button_name.to_sym
      end

      BUTTON_VALUES = {
        :up => 8,
        :right => 1,
        :down => 4,
        :left => 2,
        :start => 16
      }

      def to_sexp
        [:buttons, @buttons]
      end

      def param_src
        "button_num:#{value}"
      end
    end

    class RC100Buttons < GenericButtons
      BUTTON_NAMES = {}
      %w{up left down right 1 2 3 4 5 6}.each do |button_name|
        BUTTON_NAMES[button_name] = button_name.to_sym
        BUTTON_NAMES[button_name[0..0]] = button_name.to_sym
      end

      BUTTON_VALUES = {
        :up => 1,
        :left => 4,
        :down => 2,
        :right => 8,
        :"1" => 16,
        :"2" => 32,
        :"3" => 64,
        :"4" => 128,
        :"5" => 256,
        :"6" => 512,
      }

      def to_sexp
        [:rc100_buttons, @buttons]
      end

      def param_src
        "rc100z_num:#{value}"
      end
    end

    class TimerSeconds < Literal
      TICKS_PER_SECOND = 1.0 / 0.128

      def initialize(syntax_node, seconds)
        super(syntax_node)
        @seconds = seconds
      end

      attr_reader :seconds

      def timer_number
        (@seconds * TICKS_PER_SECOND).round
      end

      def param_src
        "timer_num:#{timer_number}"
      end
    end
  end
end
