require 'spec_helper'

describe Ropucha::Parser do
  include_context "parser"

  it "parses an empty program" do
    @program = <<-END
    main
    end
    END

    sexp.should == [:ropucha, [
      [:main, []]
    ]]
  end

  it "does not parse an empty program finished with endd" do
    @program = <<-END
    main
    endd
    END

    expect { parser.parse }.to raise_error(Ropucha::ParseError)
  end

  it "parses assignment of a number to a variable" do
    @program = <<-END
    main
      x = 1
    end
    END

    sexp.should == [:ropucha, [
      [:main, [
        [:assign, [:var, "x"], [:number, 1]]
      ]]
    ]]
  end

  it "parses two assignments" do
    @program = <<-END
    main
      a = 1
      b = 2
    end
    END

    sexp.should == [:ropucha, [
      [:main, [
        [:assign, [:var, "a"], [:number, 1]],
        [:assign, [:var, "b"], [:number, 2]]
      ]]
    ]]
  end

end
