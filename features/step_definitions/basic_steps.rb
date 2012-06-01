Given /^a program$/ do |string|
  @program = string
end

When /^I compile the program$/ do
  @tsk = Ropucha.compile(@program)
end

Then /^the TSK should contain line "([^"]*)"$/ do |line|
  @tsk.lines.map(&:chomp).should include(line)
end

Then /^the TSK should contain lines$/ do |lines|
  @tsk.should include(lines)
end
 

Then /^the TSK should begin with bytes (\d+(, \d+)*)$/ do |byte_list, unused|
  bytes = byte_list.split(",").map(&:to_i)
  @tsk.bytes.to_a[0...bytes.size].should == bytes
end

Then /^the TSK should end with bytes (\d+(, \d+)*)$/ do |byte_list, unused|
  bytes = byte_list.split(",").map(&:to_i)
  @tsk.bytes.to_a[-bytes.size..-1].should == bytes
end
