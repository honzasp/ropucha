require 'spec_helper'

describe Ropucha::Parser do
  include_context "parser"

  describe "all loops" do

    it "parses a single while" do
      @program = <<-END
      main
        while a < 1
          b = 2
        end
      end
      END

      sexp.should == [:ropucha, [
        [:main, [
          [:while, [:<, [:var, "a"], [:number, 1]], [
            [:assign, [:var, "b"], [:number, 2]]
          ]]
        ]]
      ]]
    end

    it "parses a single endless loop" do
      @program = <<-END
      main
        loop
          b = 2
        end
      end
      END

      sexp.should == [:ropucha, [
        [:main, [
          [:loop, [
            [:assign, [:var, "b"], [:number, 2]]
          ]]
        ]]
      ]]
    end

    it "parses a single for loop" do
      @program = <<-END
      main
        for i in a..5
          b = i
        end
      end
      END

      sexp.should == [:ropucha, [
        [:main, [
          [:for, [:var, "i"], [:var, "a"], [:number, 5], [
            [:assign, [:var, "b"], [:var, "i"]]
          ]]
        ]]
      ]]
    end

    it "parses an endless loop with a break" do
      @program = <<-END
      main
        loop
          break
        end
      end
      END

      sexp.should == [:ropucha, [
        [:main, [
          [:loop, [
            [:break]
          ]]
        ]]
      ]]
    end

  end
end
