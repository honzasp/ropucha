Feature: Conditions

  Conditions are used in loops and if/elseif/else, and can be created from
  comparsions or expressions connected by logical and or or.

  Scenario: If with one comparsion
    Given a program
    """
    main
      if x <= 3
        y = 1
      end
    end
    """
    When I compile the program
    Then the TSK should contain lines
    """
    o if param_src:var:x lop:<= param_src:dec_num:3 rop:then
    """

  Scenario: If with two comparsions with AND
    Given a program
    """
    main
      if x <= 3 and y == 3
        y = 1
      end
    end
    """
    When I compile the program
    Then the TSK should contain lines
    """
    o if param_src:var:x lop:<= param_src:dec_num:3 rop:&& param_src:var:y lop:== param_src:dec_num:3 rop:then
    """

  Scenario: If with three comparsions, OR has smaller precedence
    Given a program
    """
    main
      if x < b and b < y or f == 3
        y = 1
      end
    end
    """
    When I compile the program
    Then the TSK should contain lines
    """
    o if param_src:var:x lop:< param_src:var:b rop:&& param_src:var:b lop:< param_src:var:y rop:|| param_src:var:f lop:== param_src:dec_num:3 rop:then
    """

  Scenario: Complex condition with parenthesis
    Given a program
    """
    main
      if (x < a and g >= f) or (a == 3 and z < y)
        x = 0
      end
    end
    """
    When I compile the program
    Then the TSK should contain lines
    """
    o if param_src:var:a lop:== param_src:dec_num:3 rop:&& param_src:var:z lop:< param_src:var:y rop:then
    o begin
    o load param_dest:var:_tmp_1 param_src:bool_num:1
    o end
    o else
    o begin
    o load param_dest:var:_tmp_1 param_src:bool_num:0
    o end
    o if param_src:var:x lop:< param_src:var:a rop:&& param_src:var:g lop:>= param_src:var:f rop:|| param_src:var:_tmp_1 lop:!= param_src:bool_num:0 rop:then
    o begin
    o load param_dest:var:x param_src:dec_num:0
    o end
    """

  Scenario: A variable used as a condition
    Given a program
    """
    main
      if use wireless and x == 3
        z = 0
      end
    end
    """
    When I compile the program
    Then the TSK should contain lines
    """
    o if param_src:var:use_wireless lop:!= param_src:bool_num:0 rop:&& param_src:var:x lop:== param_src:dec_num:3 rop:then
    """

  Scenario: A computation used as a condition
    Given a program
    """
    main
      if a + b
        z = 0
      end
    end
    """
    When I compile the program
    Then the TSK should contain lines
    """
    o compute param_dest:var:_tmp_1 param_src:var:a aop:+ param_src:var:b
    o if param_src:var:_tmp_1 lop:!= param_src:bool_num:0 rop:then
    o begin
    o load param_dest:var:z param_src:dec_num:0
    o end
    """

  Scenario: A function call used as a condition
    Given a program
    """
    main
      if using wireless()
        z = 0
      end
    end

    function using wireless()
      return false
    end
    """
    When I compile the program
    Then the TSK should contain lines
    """
    o call faddr_dest:using_wireless
    o if param_src:var:_return_using_wireless lop:!= param_src:bool_num:0 rop:then
    o begin
    o load param_dest:var:z param_src:dec_num:0
    o end
    """

  Scenario: Elseif with condition that needs a temporary variable
    Given a program
    """
    main
      if a > b
        x = 1
      elseif a + 3 > b
        x = 2
      else
        x = 3
      end
    end
    """
    When I compile the program
    Then the TSK should contain lines
    """
    o if param_src:var:a lop:> param_src:var:b rop:then
    o begin
    o load param_dest:var:x param_src:dec_num:1
    o end
    o else
    o begin
    o compute param_dest:var:_tmp_1 param_src:var:a aop:+ param_src:dec_num:3
    o if param_src:var:_tmp_1 lop:> param_src:var:b rop:then
    o begin
    o load param_dest:var:x param_src:dec_num:2
    o end
    o else
    o begin
    o load param_dest:var:x param_src:dec_num:3
    o end
    o end
    """
