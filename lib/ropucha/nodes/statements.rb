module Ropucha
  module Nodes

    class Block < Node
      def initialize(syntax_node, statements)
        super(syntax_node)
        @statements = statements
      end

      attr_reader :statements

      def to_sexp
        statements.map &:to_sexp
      end

      def compile(g)
        statements.each { |s| s.compile(g) }
      end
    end

    class Assignment < Node
      def initialize(syntax_node, lvalue, rvalue)
        super(syntax_node)
        @lvalue = lvalue
        @rvalue = rvalue
      end

      attr_reader :lvalue
      attr_reader :rvalue

      def to_sexp
        [:assign, lvalue.to_sexp, rvalue.to_sexp]
      end

      def compile(g)
        lvalue.to_param_dest(g) do |param_dest|
          rvalue.load_to(g, param_dest)
        end
      end
    end

    class If < Node
      def initialize(syntax_node, branches, else_branch)
        super(syntax_node)
        @branches = branches
        @else_branch = else_branch
      end

      attr_reader :branches
      attr_reader :else_branch

      def has_else?
        not else_branch.nil?
      end

      def to_sexp
        [:if, branches.map(&:to_sexp), has_else? ? else_branch.to_sexp : nil]
      end

      def if_branch
        branches.first
      end

      def elseif_branches
        branches[1..-1]
      end

      def compile(g)
        if_branch.compile(g, "if")
        elseif_branches.each{|e| e.compile(g, "elseif") }
        else_branch.compile(g) if has_else?
      end

      class Branch < Node
        def initialize(syntax_node, conditions, block)
          super(syntax_node)
          @conditions = conditions
          @block = block
        end

        attr_reader :conditions
        attr_reader :block

        def to_sexp
          [:branch, conditions.to_sexp, block.to_sexp]
        end

        def compile(g, type)
          conditions.to_condition_list(g) do |condition_list|
            g.o_line "#{type} #{condition_list} rop:then"
          end
          g.o_line "begin"
          block.compile(g)
          g.o_line "end"
        end
      end

      class ElseBranch < Node
        def initialize(syntax_node, block)
          super(syntax_node)
          @block = block
        end

        attr_reader :block

        def to_sexp
          [:else_branch, block.to_sexp]
        end

        def compile(g)
          g.o_line "else"
          g.o_line "begin"
          block.compile(g)
          g.o_line "end"
        end
      end
    end

    class While < Node
      def initialize(syntax_node, conditions, block)
        super(syntax_node)
        @conditions = conditions
        @block = block
      end

      attr_reader :conditions
      attr_reader :block

      def to_sexp
        [:while, conditions.to_sexp, block.to_sexp]
      end

      def compile(g)
        conditions.to_condition_list(g) do |condition_list|
          g.o_line "while #{condition_list} rop:then"
        end

        g.o_line "begin"
        block.compile(g)
        g.o_line "end"
      end
    end

    class Loop < Node
      def initialize(syntax_node, block)
        super(syntax_node)
        @block = block
      end

      attr_reader :block

      def to_sexp
        [:loop, block.to_sexp]
      end

      def compile(g)
        g.o_line "while(1)"
        g.o_line "begin"
        block.compile(g)
        g.o_line "end"
      end
    end

    class For < Node
      def initialize(syntax_node, variable, from, to, block)
        super(syntax_node)
        @variable = variable
        @from = from
        @to = to
        @block = block
      end

      attr_reader :variable
      attr_reader :from
      attr_reader :to
      attr_reader :block

      def to_sexp
        [:for, variable.to_sexp, from.to_sexp, to.to_sexp, block.to_sexp]
      end

      def compile(g)
        from.to_param_src(g) do |from_param_src|
          to.to_param_src(g) do |to_param_src|
            var = variable.tsk_variable_name
            g.o_line "for param_var:#{var} param_src:#{from_param_src} param_src:#{to_param_src}"
          end
        end

        g.o_line "begin"
        block.compile(g)
        g.o_line "end"
      end
    end

    class Break < Node
      def initialize(syntax_node)
        super(syntax_node)
      end

      def to_sexp
        [:break]
      end

      def compile(g)
        g.o_line("break")
      end
    end

  end
end
