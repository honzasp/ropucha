Feature: Comments

  Scenario: Comments in between the definitions
    Given a program
    """
    // at the top
    // is longer comment
    devices
      wheel = motor 4
    end// hey!
    //continues

    main // foo
      x = 1
    end// bar
    //baz
    """
    When I compile the program
    Then the TSK should contain line "o load param_dest:var:x param_src:dec_num:1"

  Scenario: Comments in devices definition
    Given a program
    """
    devices
      // do
      wheel = motor 4// you
      // see me?
      // haha!
    end

    main
      wheel:goal position = 1
    end
    """
    When I compile the program
    Then the TSK should contain line "o load param_dest:motor:4:30 param_src:dec_num:1"

  Scenario: Comments in subroutine
    Given a program
    """
    main
      foo(1,2)
    end

    function foo(x, y) // does foo
      // (in fact, no)
      // yes
      return x
      // bye, my little function!
    end
    """
    When I compile the program
    Then the TSK should contain line "o call faddr_dest:foo"
