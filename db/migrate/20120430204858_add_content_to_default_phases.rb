class AddContentToDefaultPhases < ActiveRecord::Migration
  def change
        add_column :defaultphases, :content, :string
  end
end
