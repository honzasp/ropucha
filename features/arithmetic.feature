Feature: Arithmetic

  Expressions can contain arithmetic (+, -, *, /) or bit (&, |) operators, which
  can operate on another expressions.

  Scenario Outline: An operation on two variables assigned to a variable
    Given a program
    """
    main
      x = a <op> b
    end
    """
    When I compile the program
    Then the TSK should contain line "o compute param_dest:var:x param_src:var:a aop:<op> param_src:var:b"

    Examples:
      | op |
      | +  |
      | -  |
      | *  |
      | /  |
      | &  |
      | \| |

  Scenario: Two additions on three variables with default associativity
    Given a program
    """
    main
      x = a + b + c
    end
    """
    When I compile the program
    Then the TSK should contain lines
    """
    o compute param_dest:var:_tmp_1 param_src:var:a aop:+ param_src:var:b
    o compute param_dest:var:x param_src:var:_tmp_1 aop:+ param_src:var:c
    """

  Scenario: Two additions on three variables with parenthesis
    Given a program
    """
    main
      x = a + (b + c)
    end
    """
    When I compile the program
    Then the TSK should contain lines
    """
    o compute param_dest:var:_tmp_1 param_src:var:b aop:+ param_src:var:c
    o compute param_dest:var:x param_src:var:a aop:+ param_src:var:_tmp_1
    """

  Scenario: Addition of a number and an addition with default precedence
    Given a program
    """
    main
      x = a + b * c
    end
    """
    When I compile the program
    Then the TSK should contain lines
    """
    o compute param_dest:var:_tmp_1 param_src:var:b aop:* param_src:var:c
    o compute param_dest:var:x param_src:var:a aop:+ param_src:var:_tmp_1
    """
