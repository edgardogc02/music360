class AddHtmlIdToPaymentTypes < ActiveRecord::Migration
  def change
    add_column :payment_types, :html_id, :string
  end
end
