require "selenium/webdriver"
require "json"
require "pry"

credential_file = File.read("./credential.json")
credential = JSON.parse(credential_file)

GREEN_CLIENT_ID = credential["client_id"]
GREEN_PASSWORD =  credential["password"]

crawler = Selenium::WebDriver.for :chrome

crawler.navigate.to "https://www.green-japan.com/client/login?target_url=%2Fclient%2Fsearch%2F57995"

crawler.find_element(:name, "client[cd]").send_keys(GREEN_CLIENT_ID)
crawler.find_element(:name, "client[password]").send_keys(GREEN_PASSWORD)
