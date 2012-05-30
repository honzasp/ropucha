require 'spec_helper'

describe Ropucha::Compiler do

  let(:compiler) { Ropucha::Compiler.new(root_node) }

  describe "#compile" do
    let(:root_node) { stub("root node").as_null_object }

    it "calls #compile on the root node with a Generator object" do
      root_node.should_receive(:compile).with(an_instance_of(Ropucha::Generator))
      compiler.compile
    end

    context "when the program has not errors" do
      it "makes the resulting TSK accessible via #tsk" do
        compiler.compile
        compiler.tsk.should be_a(String)
      end
    end

    context "when an exception happens during the compilation" do
      before do
        root_node.stub(:compile).and_raise(Ropucha::CompileError)
      end

      it "reraises the exception" do
        expect { compiler.compile }.to raise_error(Ropucha::CompileError)
      end

      it "makes #tsk return nil" do
        compiler.compile rescue nil
        compiler.tsk.should be_nil
      end
    end
  end
end
