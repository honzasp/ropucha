Feature: Subroutines

  Subroutines are functions or procedures, which can be called and can receive
  arguments. The difference is in the return value, functions have one while
  procedures do not return anything.


  Scenario: Simple procedure definition
    Given a program
    """
    main
    end

    procedure do()
      x = 2
    end
    """
    When I compile the program
    Then the TSK should contain lines
    """
    o function faddr_src:do
    o begin
    o load param_dest:var:x param_src:dec_num:2
    o end
    """

  Scenario: Many-parameter procedure definition
    Given a program
    """
    main
    end

    procedure do(a, b, c)
      b = a
    end
    """
    When I compile the program
    Then the TSK should contain lines
    """
    o function faddr_src:do
    o begin
    o load param_dest:var:_arg_do_2 param_src:var:_arg_do_1
    o end
    """

  Scenario: Many-parameter procedure call
    Given a program
    """
    main
      do(1,2,3)
    end

    procedure do(a,b,c)
      x = 1
    end
    """
    When I compile the program
    Then the TSK should contain lines
    """
    o load param_dest:var:_arg_do_1 param_src:dec_num:1
    o load param_dest:var:_arg_do_2 param_src:dec_num:2
    o load param_dest:var:_arg_do_3 param_src:dec_num:3
    o call faddr_dest:do
    """

  Scenario: No-parameter function definition
    Given a program
    """
    main
    end

    function speed()
      return 34
    end
    """
    When I compile the program
    Then the TSK should contain lines
    """
    o function faddr_src:speed
    o begin
    o load param_dest:var:_return_speed param_src:dec_num:34
    o return
    o end
    """

  Scenario: No-parameter function call
    Given a program
    """
    main
      r = speed()
    end

    function speed()
      return 34
    end
    """
    When I compile the program
    Then the TSK should contain lines
    """
    o call faddr_dest:speed
    o load param_dest:var:r param_src:var:_return_speed
    """

  Scenario: One-parameter function definition
    Given a program
    """
    main
    end

    function square(x)
      return x*x
    end
    """
    When I compile the program
    Then the TSK should contain lines
    """
    o function faddr_src:square
    o begin
    o compute param_dest:var:_return_square param_src:var:_arg_square_1 aop:* param_src:var:_arg_square_1
    o return
    o end
    """

  Scenario: One-parameter function call
    Given a program
    """
    main
      a = square(b)
    end

    function square(x)
      return x*x
    end
    """
    When I compile the program
    Then the TSK should contain lines
    """
    o load param_dest:var:_arg_square_1 param_src:var:b
    o call faddr_dest:square
    o load param_dest:var:a param_src:var:_return_square
    """

