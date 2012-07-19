require 'rubygems'
require 'mechanize'


agent = Mechanize.new
base = agent.get "http://ocw.mit.edu/courses/"
course_links = base.links_with(:href => /courses\//)
course_page = course_links.first.click
course_links.each do |link|
  
  
end