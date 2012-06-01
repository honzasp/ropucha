module Ropucha
  class SubroutineContext
    def initialize(parent_context, subroutine_def)
      @parent = parent_context
      @subroutine_def = subroutine_def
      @local_vars = {}
    end

    attr_reader :parent
    attr_reader :subroutine_def

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
