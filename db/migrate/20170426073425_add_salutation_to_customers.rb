class AddSalutationToCustomers < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :salutation, :string
  end
end
