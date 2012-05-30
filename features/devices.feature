Feature: Devices

  Program can communicate with devices using special "variables" which can be
  read and written to.

  Devices can be accessed either by name defined in the program or directly by
  id.

  Scenario Outline: Setting a controller's parameter
    Given a program
    """
    devices
      board = cm
    end

    main
      board:<parameter> = 0
    end
    """
    When I compile the program
    Then the TSK should contain line "o load param_dest:cm:<id> param_src:dec_num:0"

    Examples:
      | parameter        | id |
      | remocon txd      | 26 |
      | aux led          | 31 |
      | timer            | 33 |
      | remocon id       | 34 |
      | print            | 37 |
      | print with line  | 38 |
      | buzzer index     | 54 |
      | buzzer time      | 55 |
      | sound count      | 56 |
      | rc100 channel    | 59 |

  Scenario Outline: Getting a controller's parameter
    Given a program
    """
    devices
      board = cm
    end

    main
      x = board:<parameter>
    end
    """
    When I compile the program
    Then the TSK should contain line "o load param_dest:var:x param_src:cm:<id>"

    Examples:
      | parameter        | id |
      | remocon rxd      | 28 |
      | remocon arrived  | 30 |
      | button           | 32 |
      | my id            | 36 |
      | voltage          | 53 |
      | current sound count | 58 |

  Scenario Outline: Setting a motor's parameter
    Given a program
    """
    devices
      wheel = motor 3
    end

    main
      wheel:<parameter> = 0
    end
    """
    When I compile the program
    Then the TSK should contain line "o load param_dest:motor:3:<id> param_src:dec_num:0"

    Examples:
      | parameter        | id |
      | torque enable    | 24 |
      | led              | 25 |
      | cw margin        | 26 |
      | ccw margin       | 27 |
      | cw slope         | 28 |
      | ccw slope        | 29 |
      | goal position    | 30 |
      | moving speed     | 32 |
      | torque limit     | 34 |

  Scenario Outline: Getting a motor's parameter
    Given a program
    """
    devices
      wheel = motor 3
    end

    main
      x = wheel:<parameter>
    end
    """
    When I compile the program
    Then the TSK should contain line "o load param_dest:var:x param_src:motor:3:<id>"

    Examples:
      | parameter        | id |
      | present position | 36 |
      | present speed    | 38 |
      | present load     | 40 |
      | voltage          | 42 |
      | temperature      | 43 |
      | moving           | 46 |

  Scenario Outline: Setting an S1 sensor parameter
    Given a program
    """
    devices
      sensor = s1 100
    end

    main
      sensor:<parameter> = 0
    end
    """
    When I compile the program
    Then the TSK should contain line "o load param_dest:s1:100 param_src:dec_num:0"

    Examples:
      | parameter        | id |
      | sound max data   | 36 |
      | sound count      | 37 |
      | sound time       | 38 |
      | buzzer index     | 40 |
      | buzzer time      | 41 |
      | ir com txd       | 50 |
      | object detection threshold | 52 |
      | light detection threshold  | 53 |

  Scenario Outline: Getting an S1 sensor parameter
    Given a program
    """
    devices
      sensor = s1 100
    end

    main
      x = sensor:<parameter>
    end
    """
    When I compile the program
    Then the TSK should contain line "o load param_dest:var:x param_src:s1:100:<id>"

    Examples:
      | parameter        | id |
      | ir left          | 26 |
      | ir center        | 27 |
      | ir right         | 28 |
      | light left       | 29 |
      | light center     | 30 |
      | light right      | 31 |
      | object detected  | 32 |
      | light detected   | 33 |
      | sound data       | 35 |
      | ir com arrived   | 46 |
      | ir com rxd       | 48 |
