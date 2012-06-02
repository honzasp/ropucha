module Ropucha
  module Nodes

    class SubroutineDef < Node
      def initialize(syntax_node, name, params, block)
        super(syntax_node)
        @name = name
        @params = params
        @block = block
      end

      attr_reader :name
      attr_reader :block
      attr_reader :params

      attr_accessor :faddr

      def context(ctx)
        ctx.register_subroutine(self)
        @block_context = SubroutineContext.new(ctx, self)
        block.context(@block_context)
      end

      def compile(g)
        @params.each_with_index do |param,i|
          tsk = g.arg_var(faddr, i)
          @block_context.register_tsk_var(param, tsk)
        end

        g.function(faddr) do
          block.compile(g)
        end
      end
    end

    class ProcedureDef < SubroutineDef
      def to_sexp
        [:procedure_def, name, params, block.to_sexp]
      end
    end

    class FunctionDef < SubroutineDef
      def to_sexp
        [:function_def, name, params, block.to_sexp]
      end

      def return_tsk_var
        # TODO: HACK!!! should implement more than just context/compile
        # passes!!!
        "var:#{Generator::RETURN_VAR_PREFIX}#{faddr}"
      end

      def compile(g)
        #@return_tsk_var = g.return_var(faddr)
        super(g)
      end
    end

    class Call < Node
      include HasValue

      def initialize(syntax_node, name, arguments)
        super(syntax_node)
        @name = name
        @arguments = arguments
      end

      attr_reader :name
      attr_reader :arguments

      def to_sexp
        [:call, name, arguments.map(&:to_sexp)]
      end

      def context(ctx)
        @context = ctx
        arguments.each { |a| a.context(ctx) }
      end

      def compile(g)
        subr = @context.subroutine_def(name)
        load_arguments(g, subr)
        g.call(subr.faddr)
      end

      def to_param_src(g)
        subr = @context.subroutine_def(name)
        load_arguments(g, subr)
        g.call(subr.faddr)
        yield subr.return_tsk_var
      end

      def load_arguments(g, subr)
        if subr.params.size == arguments.size
          arguments.each_with_index do |arg, i|
            arg.load_to(g, "var:#{g.arg_var(subr.faddr, i)}")
          end
        else
          raise CompileError, "Subroutine '#{name}' expects #{subr.params.size} arguments, got #{arguments.size}"
        end
      end
    end

    class Return < Node
      def initialize(syntax_node, return_value = nil)
        super(syntax_node)
        @return_value = return_value
      end

      attr_reader :return_value

      def has_return_value?
        !!return_value
      end
      
      def to_sexp
        if has_return_value?
          [:return, return_value.to_sexp]
        else
          [:return]
        end
      end

      def context(ctx)
        @context = ctx
        return_value.context(ctx) if has_return_value?
      end

      def compile(g)
        subr = @context.subroutine_def

        if has_return_value?
          return_value.load_to(g, subr.return_tsk_var)
        else
          if subr.respond_to? :return_tsk_var
            raise CompileError, "Subroutine '#{subr.name}' expects a return value"
          end
        end
        g.return
      end
    end

  end
end
