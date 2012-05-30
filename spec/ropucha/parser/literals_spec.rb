require 'spec_helper'

describe Ropucha::Parser do
  include_context "parser"

  describe "assignment of a literal to a variable" do
    it "parses assignment of a boolean to a variable" do
      @program = <<-END
      main
        x = true
      end
      END

      sexp.should == [:ropucha, [
        [:main, [
          [:assign, [:var, "x"], [:boolean, true]]
        ]]
      ]]
    end

    it "parses a binary number" do
      @program = <<-END
      main
        x = 0b11101
      end
      END

      sexp.should == [:ropucha, [
        [:main, [
          [:assign, [:var, "x"], [:binary, 0b11101]]
        ]]
      ]]
    end

    it "parses direction numbers" do
      @program = <<-END
      main
        x = 350 cw
        y = 200 ccw
      end
      END

      sexp.should == [:ropucha, [
        [:main, [
          [:assign, [:var, "x"], [:direction_number, 350, :cw]],
          [:assign, [:var, "y"], [:direction_number, 200, :ccw]]
        ]]
      ]]
    end

    it "parses position number" do
      @program = <<-END
      main
        p = position 600
      end
      END

      sexp.should == [:ropucha, [
        [:main, [
          [:assign, [:var, "p"], [:position_number, 600]]
        ]]
      ]]
    end

    it "parses multiple buttons' numbers" do
      @program = <<-END
      main
        bs = buttons left d
      end
      END

      sexp.should == [:ropucha, [
        [:main, [
          [:assign, [:var, "bs"], [:buttons, [:left, :down]]]
        ]]
      ]]
    end

    it "parses a single button number" do
      @program = <<-END
      main
        b = button start
      end
      END

      sexp.should == [:ropucha, [
        [:main, [
          [:assign, [:var, "b"], [:buttons, [:start]]]
        ]]
      ]]
    end

    it "parses multiple RC100 buttons' numbers" do
      @program = <<-END
      main
        rc = rc100 buttons up 1 5
      end
      END

      sexp.should == [:ropucha, [
        [:main, [
          [:assign, [:var, "rc"], [:rc100_buttons, [:up, :"1", :"5"]]]
        ]]
      ]]
    end

    it "parses a single RC100 button number" do
      @program = <<-END
      main
        rc = rc100 buttons 5
      end
      END

      sexp.should == [:ropucha, [
        [:main, [
          [:assign, [:var, "rc"], [:rc100_buttons, [:"5"]]]
        ]]
      ]]
    end

    it "parses a timer seconds number" do
      @program = <<-END
      main
        x = 6.4 timer s
      end
      END

      sexp.should == [:ropucha, [
        [:main, [
          [:assign, [:var, "x"], [:timer_s, 6.4]]
        ]]
      ]]
    end

    it "parses a buzzer seconds number" do
      @program = <<-END
      main
        x = 5.0 buzzer s
      end
      END

      sexp.should == [:ropucha, [
        [:main, [
          [:assign, [:var, "x"], [:buzzer_s, 5.0]]
        ]]
      ]]
    end

    it "parses a buzzer play melody literal" do
      @program = <<-END
      main
        y = buzzer play melody
      end
      END

      sexp.should == [:ropucha, [
        [:main, [
          [:assign, [:var, "y"], [:buzzer_play_melody]]
        ]]
      ]]
    end

    it "parses a melody number literal" do
      @program = <<-END
      main
        z = melody 5
      end
      END

      sexp.should == [:ropucha, [
        [:main, [
          [:assign, [:var, "z"], [:melody_number, 5]]
        ]]
      ]]
    end

    it "parses a scale number literal" do
      @program = <<-END
      main
        f = scale 5
      end
      END

      sexp.should == [:ropucha, [
        [:main, [
          [:assign, [:var, "f"], [:scale_number, 5]]
        ]]
      ]]
    end

  end
end
