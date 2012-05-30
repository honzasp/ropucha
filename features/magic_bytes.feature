Feature: Magic bytes

  Every TSK file has five "magic" bytes:
    3 bytes at the beginning ([239, 187, 191])
    2 bytes at the end (checksum)

    Checksum is counted as follows:
      checksum = bytes.inject(-1) { |ch,b| ch-b }
      byte1 = (checksum >> 8) & 255
      byte2 = checksum & 255

  Scenario: Three magic bytes at the beginning
    Given a program
      """
      main
        x = 1
      end
      """
    When I compile the program
    Then the TSK should begin with bytes 239, 187, 191

  Scenario: The checksum at the end
    Given a program
      """
      main
        x = 1
      end
      """
    When I compile the program
    Then the TSK should end with bytes 220, 76
