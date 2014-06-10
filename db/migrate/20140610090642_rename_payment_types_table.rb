class RenamePaymentTypesTable < ActiveRecord::Migration
  def self.up
    rename_table :payment_types, :payment_methods
  end

 def self.down
    rename_table :payment_methods, :payment_types
 end
end
