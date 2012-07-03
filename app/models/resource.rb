class Resource < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  has_attached_file :file,:path => ":rails_root/:basename.:extension"
  belongs_to :resourceable, :polymorphic => true
  attr_accessible :resourcer
  mount_uploader :resourcer, ResourcerUploader
  
  def to_jq_upload
    {
      "name" => read_attribute(:resourcer),
      "size" => resourcer.size,
      "url" => resourcer.url,
      "delete_url" => resource_path(:id => id),
      "delete_type" => "DELETE" 
    }
  end
end
