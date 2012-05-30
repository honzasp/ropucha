Feature: Variables

  Variables are places where numbers can be stored and retrieved.

  Scenario: Setting a global variable with a number
    Given a program
    """
    main
      x = 4
    end
    """
    When I compile the program
    Then the TSK should contain line "o load param_dest:var:x param_src:dec_num:4"

  Scenario: Setting a global variable with another variable
    Given a program
    """
    main
      x = y
    end
    """
    When I compile the program
    Then the TSK should contain line "o load param_dest:var:x param_src:var:y"
