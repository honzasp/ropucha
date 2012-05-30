require 'spec_helper'

describe Ropucha::Parser do
  include_context "parser"

  describe "syntax about devices" do

    it "parses a device name list" do
      @program = <<-END
      devices
        left wheel = motor 1
        right wheel = motor 3
        sensor = s1 100
        board = cm
      end
      END

      sexp.should == [:ropucha, [
        [:devices, [
          [:device_name_def, [:device_name, "left wheel"], [:device_id, "motor", 1]],
          [:device_name_def, [:device_name, "right wheel"], [:device_id, "motor", 3]],
          [:device_name_def, [:device_name, "sensor"], [:device_id, "s1", 100]],
          [:device_name_def, [:device_name, "board"], [:device_id, "cm"]]
        ]]
      ]]
    end

    it "parses an assignment of a number to property of a named device" do
      @program = <<-END
      main
        left wheel:goal position = 3
      end
      END

      sexp.should == [:ropucha, [
        [:main, [
          [:assign, [:device_property, [:device_name, "left wheel"], "goal position"], [:number, 3]]
        ]]
      ]]
    end

    it "parses an assignment of a number to property of a unnamed device" do
      @program = <<-END
      main
        [gun 100]:some property = 9
      end
      END

      sexp.should == [:ropucha, [
        [:main, [
          [:assign, [:device_property, [:device_id, "gun", 100], "some property"], [:number, 9]]
        ]]
      ]]
    end

    it "parses a named device property used as expression" do
      @program = <<-END
      main
        x = mind reader:status
      end
      END

      sexp.should == [:ropucha, [
        [:main, [
          [:assign, [:var, "x"], [:device_property, [:device_name, "mind reader"], "status"]]
        ]]
      ]]
    end

    it "parses an unnamed device property used as expression" do
      @program = <<-END
      main
        x = [cm]:button
      end
      END

      sexp.should == [:ropucha, [
        [:main, [
          [:assign, [:var, "x"], [:device_property, [:device_id, "cm"], "button"]]
        ]]
      ]]
    end

  end
end
