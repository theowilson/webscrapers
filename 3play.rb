require "rubygems"
require 'mechanize'
require 'fastercsv'

agent = Mechanize.new

agent.get("https://account.3playmedia.com/user/sessions/new") do |login_page|

  home_page = login_page.form_with(:method => "POST") do |f|
    f.field_with(:name => "user_session[email]").value = "theowilson@fullbridge.com"
    f.field_with(:name => "user_session[password]").value = "river99"  
  end.click_button
  
  agent.get("https://account.3playmedia.com/files") do |page|

    results_page = page.forms.first do |f|

      f.keyword = "ad376256fbd9673407644b62d08b3b55.mp4"
      
    end.click_button
    
    edit_page = results_page.link_with(:href => /https:\/\/account\.3playmedia\.com\/files\/[\d]+\/edit/).click
    
    
    pp edit_page

  end
end
# 
# 

# 
# page = agent.submit(login_form, login_form.buttons.first)
# 
# pp page