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

      def context(ctx)
        statements.each { |s| s.context(ctx) }
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

      def context(ctx)
        lvalue.context(ctx)
        rvalue.context(ctx)
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

      def context(ctx)
        if_branch.context(ctx)
        elseif_branches.each{|b| b.context(ctx) }
        else_branch.context(ctx) if has_else?
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

        def context(ctx)
          conditions.context(ctx)
          block.context(ctx)
        end

        def compile(g, type)
          generator_msg = type == "if" ? :if_ : :elseif_
          conditions.to_condition_list(g) do |condition_list|
            g.__send__(generator_msg, condition_list) do |g|
              block.compile(g)
            end
          end
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

        def context(ctx)
          block.context(ctx)
        end

        def compile(g)
          g.else_ do |g|
            block.compile(g)
          end
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

      def context(ctx)
        conditions.context(ctx)
        block.context(ctx)
      end

      def compile(g)
        conditions.to_condition_list(g) do |condition_list|
          g.while_(condition_list) do |g|
            block.compile(g)
          end
        end
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

      def context(ctx)
        block.context(ctx)
      end

      def compile(g)
        g.while_1 do |g|
          block.compile(g)
        end
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

      def context(ctx)
        variable.context(ctx)
        from.context(ctx)
        to.context(ctx)
        block.context(ctx)
      end

      def compile(g)
        from.to_param_src(g) do |from_param_src|
          to.to_param_src(g) do |to_param_src|
            var = variable.tsk_variable_name
            g.for(var, from_param_src, to_param_src) do |g|
              block.compile(g)
            end
          end
        end
      end
    end

    class Break < Node
      def initialize(syntax_node)
        super(syntax_node)
      end

      def to_sexp
        [:break]
      end

      def context(ctx)
      end

      def compile(g)
        g.break
      end
    end

  end
end
