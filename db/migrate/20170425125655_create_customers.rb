class CreateCustomers < ActiveRecord::Migration[5.0]
  def change
    create_table :customers, id: :uuid do |t|
      t.string :name
      t.string :surname
      t.string :email
      t.string :phone
      t.text :comment
      t.boolean :locked
      t.string :url

      t.timestamps
    end
  end
end
