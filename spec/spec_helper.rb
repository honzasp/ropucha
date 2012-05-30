$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'ropucha'

shared_context "parser" do
  let(:parser) { Ropucha::Parser.new(@program) }

  def sexp
    parser.parse
    parser.root_node.to_sexp
  end
end
