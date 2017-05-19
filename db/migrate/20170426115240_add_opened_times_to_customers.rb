class AddOpenedTimesToCustomers < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :opened_times, :integer
  end
end
