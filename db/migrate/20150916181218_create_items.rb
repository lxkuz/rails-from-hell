class CreateDataItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.hstore :data
      t.timestamps null: false
    end
  end
end
