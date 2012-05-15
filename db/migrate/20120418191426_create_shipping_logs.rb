class CreateShippingLogs < ActiveRecord::Migration
  def change
    create_table :shipping_logs do |t|
      t.string :title
      t.string :description
      t.datetime :shipped_on

      t.timestamps
    end
  end
end
