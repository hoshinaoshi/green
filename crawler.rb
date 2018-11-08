require "selenium/webdriver"
require "json"
require "pry"

credential_file = File.read("./credential.json")
credential = JSON.parse(credential_file)

GREEN_CLIENT_ID = credential["client_id"]
GREEN_PASSWORD =  credential["password"]

class Crawler
  include Selenium::WebDriver
  attr_accessor :driver

  def initialize
    @driver = Selenium::WebDriver.for :chrome
    @acceptable_universities = File.read("./universities.csv").split
  end

  def login
    @driver.navigate.to("https://www.green-japan.com/client/login?target_url=%2Fclient%2Fsearch%2F57995")

    @driver.find_element(:name, "client[cd]").send_keys(GREEN_CLIENT_ID)
    @driver.find_element(:name, "client[password]").send_keys(GREEN_PASSWORD)

    @driver.find_element(:name, "commit").click
    sleep 5
  end

  def find_candidates
    table = @driver.find_element(:class, "mdl-data-table--client-search")
    tbodies = table.find_elements(:class, "mdl-data-table--clickable")
      tbodies.each do |tbody|
        candidate_info = tbody.find_elements(:xpath, "tr")[0]

        candidate_univ = candidate_info.find_elements(:xpath, "td")[-1].text
        candidate_job = candidate_info.find_elements(:xpath, "td")[4].text
        candidate_check_button = candidate_info.find_elements(:xpath, "td")[0]

        candidate_check_button.click if
          acceptable_university?(candidate_univ) && engineer?(candidate_job)
      end

    driver.find_elements(:class, "mdl-data-table__actions")[0]
      .find_elements(:class, "mdl-button")[1] # list button
      .find_element(:xpath, "i")              # show pulldown menu
      .click

    driver.find_elements(:class, "mdl-data-table__actions")[0]
      .find_elements(:class, "mdl-button")[1] # list button
      .find_element(:xpath, "ul")
      .find_elements(:xpath, "li")[1] # エンジニア_2018採用チーム
      .click
  rescue => e
    puts e
    sleep 3
    retry
  end

  private
  def acceptable_university?(univ)
    @acceptable_universities.include?(univ)
  end

  def engineer?(job)
    /開発/.match(job) && /Web/.match(job) ? true : false
  end
end

crawler = Crawler.new
crawler.login
crawler.find_candidates

puts "Ending..."
crawler.driver.quit;
