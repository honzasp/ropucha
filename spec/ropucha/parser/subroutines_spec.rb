require 'spec_helper'

describe Ropucha::Parser do
  include_context "parser"

  describe "subroutine definitions and calls" do

    it "parses a no-parameter procedure definition" do
      @program = <<-END
      procedure do()
        x = y
      end
      END

      sexp.should == [:ropucha, [
        [:procedure_def, "do", [], [
          [:assign, [:var, "x"], [:var, "y"]]
        ]]
      ]]
    end

    it "parses a many-parameter procedure definition" do
      @program = <<-END
      procedure do(x,y,z)
        a = 1
      end
      END

      sexp.should == [:ropucha, [
        [:procedure_def, "do", ["x", "y", "z"], [
          [:assign, [:var, "a"], [:number, 1]]
        ]]
      ]]
    end

    it "parses a no-parameter function definition" do
      @program = <<-END
      function time()
        return 2012
      end
      END

      sexp.should == [:ropucha, [
        [:function_def, "time", [], [
          [:return, [:number, 2012]]
        ]]
      ]]
    end

    it "parses a many-parameter function definition" do
      @program = <<-END
      function count(a, b, c, d)
        return a
      end
      END

      sexp.should == [:ropucha, [
        [:function_def, "count", ["a", "b", "c", "d"], [
          [:return, [:var, "a"]]
        ]]
      ]]
    end

    it "parses a subroutine call with no arguments" do
      @program = <<-END
      main
        foo()
      end
      END

      sexp.should == [:ropucha, [
        [:main, [
          [:call, "foo", []]
        ]]
      ]]
    end

    it "parses a function call with many arguments" do
      @program = <<-END
      main
        bar(a, 42, b)
      end
      END

      sexp.should == [:ropucha, [
        [:main, [
          [:call, "bar", [[:var, "a"], [:number, 42], [:var, "b"]]]
        ]]
      ]]
    end

    it "parses a function call as an expression" do
      @program = <<-END
      main
        x = a + square(3)
      end
      END

      sexp.should == [:ropucha, [
        [:main, [
          [:assign, [:var, "x"], [:+, [:var, "a"], [:call, "square", [[:number, 3]]]]]
        ]]
      ]]
    end

  end
end
