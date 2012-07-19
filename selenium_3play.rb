require "test/unit"
require "rubygems"
gem "selenium-client"
require "selenium/client"
require 'fastercsv'

@start_time = Time.now
@verification_errors = []
puts "Creating new Selenium Client"
@selenium = Selenium::Client::Driver.new \
  :host => "localhost",
  :port => 4444,
  :browser => "chrome",
  :url => "https://account.3playmedia.com/",
  :timeout_in_second => 60
puts "Opening browser session"
@selenium.start_new_browser_session
puts "Browser session open"
@selenium.open "/user/sessions/new"

puts "Logging In"
@selenium.type "user_session_email", "theowilson@fullbridge.com"
@selenium.type "user_session_password", "river99"
@selenium.click "//button[@type='submit']"
@selenium.wait_for_page_to_load "30000"
puts "Login Successful"