Given(/^I am on the NDTV web app$/) do
visit ("https://www.ndtv.com/")
  using_wait_time 5 do
	page.find("a[id='h_sub_menu']").click
	page.find("a", :text => 'WEATHER').click
  end
end

When (/^I enable the checkbox of the (.+)? city from the list$/) do |variable|
page.find('input[id="searchBox"]').set(variable)
	unless page.has_checked_field?('Hyderabad')
    	   page.find_by_id('Hyderabad').click
    end
end

When (/^I select the city (.+)? from the map$/) do |city|
   @city_map = find(:xpath, "//div[@class='cityText' and text()='Hyderabad']").click
   using_wait_time 2 do
     expect(page).to have_xpath("//div[@class='leaflet-popup-content-wrapper']") 
   end
end

Then (/^I should be able to see the weather conditions of the selected city$/) do
@temp_in_degrees = find(:xpath, "//div[@class='leaflet-popup-content']/div/span[4]").native.text
@temp_val = @temp_in_degrees.split(':')
$temp_value = @temp_val[1].to_i
log "Temperature on web app is: #{$temp_value}"

@humidity = find(:xpath, "//div[@class='leaflet-popup-content']/div/span[3]").native.text
val = @humidity.split(':')
$humidity_val = val[1].chomp('%').to_i
log "Humidity on web app is: #{$humidity_val}"
end

Given (/^I have the API key and endpoint of NDTV weather$/) do
@api_key = "7fe67bf08c80ded756e598d6f8fedaea"
end

When (/^I run a GET method to get the weather condiiton of the (.+)? city$/) do |city|
@addURI = "http://api.openweathermap.org/data/2.5/weather?q=#{city}&appid=#{@api_key}"
headers = {
	:apiKey => @api_key
}
@response = RestClient.get @addURI, headers
end

Then (/^I should get the response of the weather for selected city$/) do
body = JSON.parse(@response,symbolize_names:true)
	temp = body[:main][:temp]
	@temp_api = temp - 273.15
	log "Temperature from API is: #{@temp_api}"
	@humidity_api = body[:main][:humidity]
	log "Humidity from API is: #{@humidity_api}"
end

Then (/^I compare the api response and the web app response with "([^"]*)" variance for temperature and "([^"]*)" variance for humidity$/) do |temp_variance,humidity_variance|
	temp_diff = $temp_value - @temp_api
		raise RuntimeError.new("Failed. Temperature values don't match.") unless (temp_diff.abs.to_i <= temp_variance.to_i)
		
		log "Passed. Temperature difference fall within the specified range."	
		
	humidity_diff = $humidity_val - @humidity_api	

		raise RuntimeError.new("Failed. Humidity values don't match.") unless (humidity_diff.abs.to_i <= humidity_variance.to_i)
		
		log "Passed. Humidity difference fall within the specified range."
end