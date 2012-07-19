require 'mongoid'
require 'mechanize'

class Source
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Versioning
  include Mongoid::Paranoia
  
  field :title
  field :description
  
  field :root_url
  field :course_index_path
  field :course_link_identifier
  field :course_page_fields

  def generate_courses
    agent = Mechanize.new
    course_index = agent.get(root_url)
  end
  
  class << self

  end
  
end