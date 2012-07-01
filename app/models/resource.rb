class Resource < ActiveRecord::Base
  has_attached_file :file,:path => ":rails_root/:basename.:extension"
  belongs_to :resourceable, :polymorphic => true
end
