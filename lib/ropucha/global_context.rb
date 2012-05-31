require 'set'

module Ropucha
  class GlobalContext
    def initialize
      @global_vars = {}
      @used_tsk_vars = Set.new
      @device_names = {}
      @main = nil
    end

    attr_accessor :main

    def variable_to_tsk(name)
      unless @global_vars.has_key? name
        var_base = name.
          gsub(/\s/, "_").
          gsub(/[^a-zA-Z_]/, "").
          gsub(/^$/, "g").
          gsub(/^#{Generator::TMP_VAR_PREFIX}/, "g")

        unless used_tsk_var? var_base
          tsk_var = var_base
        else
          counter = 1
          while used_tsk_var? (tsk_var = "#{var_base}_#{counter}")
            counter += 1
          end
        end

        use_tsk_var(tsk_var)
        @global_vars[name] = tsk_var
      else
        @global_vars[name]
      end
    end

    def device_name(name, device_id)
      @device_names[name] = device_id
    end

    def device_id_by_name(name)
      @device_names[name]
    end

    def used_tsk_var?(var)
      @used_tsk_vars.include? var
    end

    def use_tsk_var(var)
      @used_tsk_vars.add(var)
    end
  end
end


