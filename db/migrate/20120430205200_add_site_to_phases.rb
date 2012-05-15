class AddSiteToPhases < ActiveRecord::Migration
  def change
     add_column :phases, :site, :string
  end
end
