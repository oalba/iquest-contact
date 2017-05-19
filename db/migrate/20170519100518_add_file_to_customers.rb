class AddFileToCustomers < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :file, :string
  end
end
