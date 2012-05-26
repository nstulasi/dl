class CreateStreams < ActiveRecord::Migration
  def change
    create_table :streams do |t|

      t.timestamps
    end
  end
end
