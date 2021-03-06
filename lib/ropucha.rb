require 'ropucha/parser'
require 'ropucha/compiler'
require 'ropucha/generator'
require 'ropucha/global_context'
require 'ropucha/subroutine_context'
require 'ropucha/device_properties'
require 'ropucha/nodes/node'
require 'ropucha/nodes/has_value'
require 'ropucha/nodes/arithmetic'
require 'ropucha/nodes/definitions'
require 'ropucha/nodes/statements'
require 'ropucha/nodes/literals'
require 'ropucha/nodes/variables'
require 'ropucha/nodes/conditions'
require 'ropucha/nodes/devices'
require 'ropucha/nodes/subroutines'

module Ropucha
  def self.compile(program)
    compiler = Ropucha::Compiler.new
    compiler.main_program = program
    compiler.compile
  end
end
