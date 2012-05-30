require 'spec_helper'

describe "Ropucha.compile" do
  it "compiles given program and returns the TSK" do
    program = <<-END
    main
      x = 1
    end
    END
    
    Ropucha.compile(program).should match(/o load param_dest:var:x param_src:dec_num:1/)
  end
end

