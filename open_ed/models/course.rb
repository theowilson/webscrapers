require 'mongoid'

class Course
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Versioning
  include Mongoid::Paranoia

  belongs_to :source
  has_many :course_items


  field :title
  
  def method_missing(name, *args)
    return super unless name =~ /\=$/
    write_attribute(name.gsub(/\=$/,""), args[0])
  end

end