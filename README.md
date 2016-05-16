# Companion

Companion is a tool to aid ruby developers by detailing the insides of their ruby program in line with where they're currently at in their editor. For example, if a developer had `foo.rb` open and was at the `def bar` method, companion woud show the results of the `bar` method and other relevant information (current variables set, etc.). The objective is to reduce the back and forth between editor and debugger by showing the content that would have been requested from the debugger.

## Status

Companion is currently in development and likely isn't useful yet.

## Try it out

1. Clone the git repo: git `clone git@github.com:seanlerner/companion.git`
2. Change into the companion directory `cd companion`
3. Run companion and monitor the test ruby script `bin/companion test_area/test.rb`
4. Modify the `test_area/test.rb` file, save it, and the companion screen will update with new information (note that this isn't fully working properly yet)

## Contributing

If you'd like to help develop Companion, please contact me at sean@smallcity.ca.

