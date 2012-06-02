Feature: Literals

  Literals are just other ways to write numbers with special meaning, like
  booleans, motor values, timer values or buttons.

  Scenario Outline: Assigning a literal to variable
    Given a program
      """
      main
        x = <literal>
      end
      """
    When I compile the program
    Then the TSK should contain line "o load param_dest:var:x param_src:<tsk>"

    Examples:
      | literal            | tsk               |
      | 42                 | dec_num:42        |
      | -3                 | dec_num:-3        |
      | true               | bool_num:1        |
      | 0b1110             | bin_num:14        |
      | 400 ccw            | dir_num:400       |
      | 200 cw             | dir_num:1224      |
      | position 823       | position_num:823  |
      | buttons d l r s    | button_num:23     |
      | button u           | button_num:8      |
      | rc100 buttons d 1  | rc100z_num:18     |
      | rc100 button 5     | rc100z_num:256    |
      | 12.8 timer s       | timer_num:100     |
      | 2.0 buzzer s       | buzzertime_num:20 |
      | buzzer play melody | buzzertime_num:255|
      | melody 19          | melody_num:19     |
      | scale 0            | scale_num:0       |
