class CreateAdmins < ActiveRecord::Migration[5.0]
  def change
    create_table :admins do |t|
      t.string :name
      t.belongs_to :role, foreign_key: true

      t.timestamps
    end
  end
end
