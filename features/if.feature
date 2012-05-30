Feature: If

  If/elseif/else is used to execute some code depending on some conditions.

  Scenario: If condition with an equality compare
    Given a program
    """
    main
      if a == 3
        b = 4
      end
    end
    """
    When I compile the program
    Then the TSK should contain lines 
    """
    o if param_src:var:a lop:== param_src:dec_num:3 rop:then
    o begin
    o load param_dest:var:b param_src:dec_num:4
    o end
    """

  Scenario: If condition with else
    Given a program
    """
    main
      if a == 3
        b = 4
      else
        b = 5
      end
    end
    """
    When I compile the program
    Then the TSK should contain lines
    """
    o if param_src:var:a lop:== param_src:dec_num:3 rop:then
    o begin
    o load param_dest:var:b param_src:dec_num:4
    o end
    o else
    o begin
    o load param_dest:var:b param_src:dec_num:5
    o end
    """

  Scenario: If condition with elseif and else
    Given a program
    """
    main
      if a == 3
        b = 4
      elseif a == 6
        b = 3
      else
        b = 5
      end
    end
    """
    When I compile the program
    Then the TSK should contain lines
    """
    o if param_src:var:a lop:== param_src:dec_num:3 rop:then
    o begin
    o load param_dest:var:b param_src:dec_num:4
    o end
    o elseif param_src:var:a lop:== param_src:dec_num:6 rop:then
    o begin
    o load param_dest:var:b param_src:dec_num:3
    o end
    o else
    o begin
    o load param_dest:var:b param_src:dec_num:5
    o end
    """

  Scenario: If condition with many elseifs and no else
    Given a program
    """
    main
      if a == 3
        b = 1
      elseif b == 2
        a = 2
      elseif c == 4
        d = 5
      elseif f == 2
        g = 3
      end
    end
    """
    When I compile the program
    Then the TSK should contain lines
    """
    o if param_src:var:a lop:== param_src:dec_num:3 rop:then
    o begin
    o load param_dest:var:b param_src:dec_num:1
    o end
    o elseif param_src:var:b lop:== param_src:dec_num:2 rop:then
    o begin
    o load param_dest:var:a param_src:dec_num:2
    o end
    o elseif param_src:var:c lop:== param_src:dec_num:4 rop:then
    o begin
    o load param_dest:var:d param_src:dec_num:5
    o end
    o elseif param_src:var:f lop:== param_src:dec_num:2 rop:then
    o begin
    o load param_dest:var:g param_src:dec_num:3
    o end
    """
