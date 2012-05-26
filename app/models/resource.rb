class Resource < ActiveRecord::Base
  has_attached_file :file,:path => ":rails_root/:basename.:extension"
end
