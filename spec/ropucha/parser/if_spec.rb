require 'spec_helper'

describe Ropucha::Parser do
  include_context "parser"

  describe "if/elseif/else conditionals" do
    it "parses a single if" do
      @program = <<-END
      main
        if 1 > 2
          a = 3
        end
      end
      END

      sexp.should == [:ropucha, [
        [:main, [
          [:if, [
            [:branch, [:>, [:number, 1], [:number, 2]], [
              [:assign, [:var, "a"], [:number, 3]]
            ]]
          ], nil]
        ]]
      ]]
    end

    it "parses if with else" do
      @program = <<-END
      main
        if 2 > 1
          a = 3
        else
          b = 6
        end
      end
      END

      sexp.should == [:ropucha, [
        [:main, [
          [:if, [
            [:branch, [:>, [:number, 2], [:number, 1]], [
              [:assign, [:var, "a"], [:number, 3]]
            ]]
          ], [:else_branch, [
            [:assign, [:var, "b"], [:number, 6]]
          ]]]
        ]]
      ]]
    end

    it "parses if with elseif and else" do
      @program = <<-END
      main
        if a > 2
          b = 3
        elseif b < 5
          a = 4
        else
          c = 2
        end
      end
      END

      sexp.should == [:ropucha, [
        [:main, [
          [:if, [
            [:branch, [:>, [:var, "a"], [:number, 2]], [
              [:assign, [:var, "b"], [:number, 3]]
            ]],
            [:branch, [:<, [:var, "b"], [:number, 5]], [
              [:assign, [:var, "a"], [:number, 4]]
            ]]
          ], [:else_branch, [
            [:assign, [:var, "c"], [:number, 2]]
          ]]]
        ]]
      ]]
    end

  end
end
