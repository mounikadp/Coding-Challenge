
How to setup a Windows environment with Cucumber: 
https://www.guru99.com/cucumber-installation.html

Make sure that the Gems mentioned in env.rb are installed using - 
gem install <gem_name> 


Cucumber commands:

cucumber                     -  executes any and all feature file tests in the directory, outputs to screen

cucumber DEBUG=true/false    -  executes test in DEBUG mode. Cucumber is always in DEBUG=true. Only use false when ready to mark Zephyr tests

cucumber -t @<tag_name>      -  executes any tests with the @<tag_name> tag added to them

cucumber -f pretty           -  executes tests with a "pretty" output format (cleans up the execution steps, hides some debugging)

cucumber -f html             -  executes tests with the output in an html format

cucumber -o path/file.html   -  executes tests and outputs to the specified file


Command to run the test cases -
cucumber -t @coding_challenge -f pretty -f html -o report.html


features: where your plain text feature files will go (example: ndtv_weather.feature)
	  
step definitions: where the ruby steps that correspond to the features will go (example: ndtv_weather.rb)


Project Structure - 

features
├── ndtv_weather
    ├── ndtv_weather.feature
├── step_definitions
    ├── ndtv_weather.rb
├── support
    ├── env.rb
readme.txt
