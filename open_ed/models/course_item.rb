require 'mongoid'

class CourseItem
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Versioning
  include Mongoid::Paranoia

  belongs_to :course

  field :title
  feild :url
  field :media_type
  
  def method_missing(name, *args)
    return super unless name =~ /\=$/
    write_attribute(name.gsub(/\=$/,""), args[0])
  end

end