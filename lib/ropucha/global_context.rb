require 'set'

module Ropucha
  class GlobalContext
    def initialize
      @global_vars = {}
      @used_tsk_vars = Set.new
      @device_names = {}
      @subroutine_defs = {}
      @used_faddrs = Set.new
      @main = nil
    end

    attr_accessor :main

    def variable_to_tsk(name)
      unless @global_vars.has_key? name
        var_base = Generator.identifier_to_tsk_var(name)
        tsk_var = generate_tsk_var(var_base)
        use_tsk_var(tsk_var)
        @global_vars[name] = tsk_var
      else
        @global_vars[name]
      end
    end

    def register_subroutine(subroutine)
      unless @subroutine_defs.has_key? subroutine.name
        faddr_base = Generator.identifier_to_faddr(subroutine.name)
        unless used_faddr? faddr_base
          faddr = faddr_base
        else
          counter = 1
          while used_faddr? (faddr = "#{faddr_base}_#{counter}")
            counter += 1
          end
        end

        use_faddr(faddr)
        subroutine.faddr = faddr
        @subroutine_defs[subroutine.name] = subroutine
      else
        @subroutine_defs[subroutine.name]
      end
    end

    def subroutine_defs
      @subroutine_defs.values
    end

    def subroutine_def(name)
      @subroutine_defs[name]
    end

    def used_faddr?(faddr)
      @used_faddrs.include? faddr
    end

    def use_faddr(faddr)
      @used_faddrs.add(faddr)
    end

    def device_name(name, device_id)
      @device_names[name] = device_id
    end

    def device_id_by_name(name)
      @device_names[name]
    end

    def generate_tsk_var(base_name)
      unless used_tsk_var? base_name
        base_name
      else
        counter = 1
        while used_tsk_var? (tsk_var = "#{base_name}_#{counter}")
          counter += 1
        end
        tsk_var
      end
    end

    def used_tsk_var?(var)
      @used_tsk_vars.include? var
    end

    def use_tsk_var(var)
      @used_tsk_vars.add(var)
    end
  end
end


