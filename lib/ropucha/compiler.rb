module Ropucha

  class CompileError < ::RuntimeError
  end

  class Compiler
    def initialize(root_node)
      @root_node = root_node
      @generator = Generator.new
    end

    def compile
      @root_node.compile(@generator)
      @tsk = @generator.tsk
    end

    def tsk
      @tsk
    end
  end
end
