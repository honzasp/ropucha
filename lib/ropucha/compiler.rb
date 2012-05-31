module Ropucha

  class CompileError < ::RuntimeError
  end

  class Compiler
    def initialize
      @loader = nil
      @main_program = nil
    end

    attr_accessor :loader
    attr_accessor :main_program

    def compile
      @generator = Generator.new
      @global_context = GlobalContext.new

      parser = Parser.new(main_program)
      tree = parser.parse

      tree.context(@global_context)
      tree.compile(@generator)
      @generator.tsk
    end
  end
end
