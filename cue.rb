require 'rubygems'
require 'mechanize'
require 'logger'

agent = Mechanize.new { |a| a.log = Logger.new("mech.log") }
# agent.user_agent_alias = 'Mac Safari'
# login
agent.get("https://webapps.fas.harvard.edu/course_evaluation_reports/fas/list") do |page|
  if page.title[Regexp.new("Harvard University PIN Login", true)]
    new_page = page.form_with(:action => "/pin/submit-login") do |login_form|
      login_form.__authen_id = "80697953"
      login_form.__authen_password = "Hb5udd+yk"
      puts login_form.fields.collect(&:value)
    end.submit
  end
  puts agent.cookie
  # login_form.__authen_id = ARGV[0]
  # login_form.__authen_password = ARGV[1]
end
puts agent.current_page.title
# agent.get "https://webapps.fas.harvard.edu/course_evaluation_reports/fas/list"
# puts agent.current_page.title