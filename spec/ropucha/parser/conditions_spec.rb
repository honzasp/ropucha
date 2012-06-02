require 'spec_helper'

describe Ropucha::Parser do
  include_context "parser"

  describe "conditions and comparsions" do

    it "parses a logical and" do
      @program = <<-END
      main
        if a == 1 and b != 2
          x = 0
        end
      end
      END

      sexp.should == [:ropucha, [
        [:main, [
          [:if, [
            [:branch, [:and, [:==, [:var, "a"], [:number, 1]], [:"!=", [:var, "b"], [:number, 2]]], [
              [:assign, [:var, "x"], [:number, 0]]
            ]]
          ], nil]
        ]]
      ]]
    end

    it "parses a logical or" do
      @program = <<-END
      main
        if a == 1 or b != 2
          x = 0
        end
      end
      END

      sexp.should == [:ropucha, [
        [:main, [
          [:if, [
            [:branch, [:or, [:==, [:var, "a"], [:number, 1]], [:"!=", [:var, "b"], [:number, 2]]], [
              [:assign, [:var, "x"], [:number, 0]]
            ]]
          ], nil]
        ]]
      ]]
    end

    it "parses or with precedence over and" do
      @program = <<-END
      main
        if a and b or c and d
          x = 0
        end
      end
      END

      sexp.should == [:ropucha, [
        [:main, [
          [:if, [
            [:branch, [:or, [:and, [:var, "a"], [:var, "b"]], [:and, [:var, "c"], [:var, "d"]]], [
              [:assign, [:var, "x"], [:number, 0]]
            ]]
          ], nil]
        ]]
      ]]
    end

    it "parses logical operators with parenthesis" do
      @program = <<-END
      main
        if (a or b) and (c or d)
          x = 0
        end
      end
      END

      sexp.should == [:ropucha, [
        [:main, [
          [:if, [
            [:branch, [:and, [:or, [:var, "a"], [:var, "b"]], [:or, [:var, "c"], [:var, "d"]]], [
              [:assign, [:var, "x"], [:number, 0]]
            ]]
          ], nil]
        ]]
      ]]
    end

  end
end
