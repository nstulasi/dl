class CreateMeta < ActiveRecord::Migration
  def change
    create_table :meta do |t|
      t.string :stream_xml
      t.string :structure_xml
      t.string :space_xml
      t.string :scenario_xml
      t.string :society_xml

      t.timestamps
    end
  end
end
