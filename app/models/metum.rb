class Metum < ActiveRecord::Base
  belongs_to :project
  has_many :resources, :as => :resourceable
end
