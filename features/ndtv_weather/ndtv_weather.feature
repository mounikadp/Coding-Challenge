@coding_challenge

Feature: NDTV - Web Application for weather

@tag_1 @ndtv_web
Scenario: Generate the weather for "Hyderabad" city from NDTV weather app
	Given I am on the NDTV web app
	When I enable the checkbox of the Hyderabad city from the list
	And I select the city Hyderabad from the map
	Then I should be able to see the weather conditions of the selected city

@tag_2 @ndtv_api
Scenario: Generate the weather for "Hyderabad" city from NDTV public api
	Given I have the API key and endpoint of NDTV weather
	When I run a GET method to get the weather condiiton of the Hyderabad city
    Then I should get the response of the weather for selected city
    And I compare the api response and the web app response with "2" variance for temperature and "10" variance for humidity