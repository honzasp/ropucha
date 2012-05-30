require 'ropucha/parser'
require 'ropucha/compiler'
require 'ropucha/generator'
require 'ropucha/nodes/node'
require 'ropucha/nodes/definitions'
require 'ropucha/nodes/statements'
require 'ropucha/nodes/literals'
require 'ropucha/nodes/variables'
require 'ropucha/nodes/conditions'
require 'ropucha/nodes/devices'

module Ropucha
  def self.compile(program)
    parser = Ropucha::Parser.new(program)
    parser.parse

    compiler = Ropucha::Compiler.new(parser.root_node)
    compiler.compile

    compiler.tsk
  end
end
