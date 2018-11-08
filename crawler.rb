require "selenium/webdriver"

crawler = Selenium::WebDriver.for :chrome

crawler.navigate.to "https://www.green-japan.com/client/login?target_url=%2Fclient%2Fsearch%2F57995"

client_id_input_field = crawler.find_element(:name, "client[cd]")
client_id_input_field.send_keys("C0002341")

crawler.save_screenshot('./test.png')

