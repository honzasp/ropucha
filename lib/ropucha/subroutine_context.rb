module Ropucha
  class SubroutineContext
    def initialize(parent_context, subroutine)
      @parent = parent_context
      @subroutine = subroutine
      @local_vars = {}
    end

    attr_reader :parent
    attr_reader :subroutine

    def subroutine_def(name)
      parent.subroutine_def(name)
    end

    def register_tsk_var(name, tsk_var)
      @local_vars[name] = tsk_var
    end

    def variable_to_tsk(name)
      if @local_vars.has_key? name
        @local_vars[name]
      else
        @parent.variable_to_tsk(name)
      end
    end

    def device_id_by_name(name)
      @parent.device_id_by_name(name)
    end
  end
end
