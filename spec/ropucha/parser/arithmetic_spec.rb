require 'spec_helper'

describe Ropucha::Parser do
  include_context "parser"

  describe "arithmetic expression" do

    def self.simple_operation(operator, name)
      it "parses assignment of a #{name} to a variable" do
        @program = <<-END
        main
          x = a #{operator} 1
        end
        END

        sexp.should == [:ropucha, [
          [:main, [
            [:assign, [:var, "x"], [operator, [:var, "a"], [:number, 1]]]
          ]]
        ]]
      end
    end

    simple_operation :+, "addition"
    simple_operation :-, "subtraction"
    simple_operation :*, "multiplication"
    simple_operation :/, "division"
    simple_operation :&, "bit and"
    simple_operation :|, "bit or"

    def self.left_associativity(first_op, second_op, name)
      it "parses #{name} with left associativity" do
        @program = <<-END
        main
          x = a #{first_op} b #{second_op} c
        end
        END

        sexp.should == [:ropucha, [
          [:main, [
            [:assign, [:var, "x"], [second_op, [first_op, [:var, "a"], [:var, "b"]], [:var, "c"]]]
          ]]
        ]]
      end
    end

    left_associativity :+, :+, "two additions"
    left_associativity :-, :-, "two subtractions"
    left_associativity :+, :-, "addition and subtraction"

    left_associativity :*, :*, "two multiplications"
    left_associativity :/, :/, "two divisions"
    left_associativity :/, :*, "division and multiplication"

    left_associativity :&, :&, "two logical ands"
    left_associativity :|, :|, "two logical ors"
  end
end
    
