Feature: Loops

  Loops are used to repeat block of code many times.

  Scenario: Simple while loop
    Given a program
    """
    main
      while a < 3
        b = 2
      end
    end
    """
    When I compile the program
    Then the TSK should contain lines
    """
    o while param_src:var:a lop:< param_src:dec_num:3 rop:then
    o begin
    o load param_dest:var:b param_src:dec_num:2
    o end
    """

  Scenario: Simple endless loop
    Given a program
    """
    main
      loop
        b = 3
      end
    end
    """
    When I compile the program
    Then the TSK should contain lines
    """
    o while(1)
    o begin
    o load param_dest:var:b param_src:dec_num:3
    o end
    """

  Scenario: Simple for loop
    Given a program
    """
    main
      for x in 1..z
        m = 3
      end
    end
    """
    When I compile the program
    Then the TSK should contain lines
    """
    o for param_var:x param_src:dec_num:1 param_src:var:z
    o begin
    o load param_dest:var:m param_src:dec_num:3
    o end
    """

  Scenario: Break inside a simple while loop
    Given a program
    """
    main
      while a == 3
        break
      end
    end
    """
    When I compile the program
    Then the TSK should contain lines
    """
    o while param_src:var:a lop:== param_src:dec_num:3 rop:then
    o begin
    o break
    o end
    """
