require 'ropucha/parser'
require 'ropucha/compiler'
require 'ropucha/generator'
require 'ropucha/global_context'
require 'ropucha/device_properties'
require 'ropucha/nodes/node'
require 'ropucha/nodes/definitions'
require 'ropucha/nodes/statements'
require 'ropucha/nodes/literals'
require 'ropucha/nodes/variables'
require 'ropucha/nodes/conditions'
require 'ropucha/nodes/devices'

module Ropucha
  def self.compile(program)
    compiler = Ropucha::Compiler.new
    compiler.main_program = program
    compiler.compile
  end
end
