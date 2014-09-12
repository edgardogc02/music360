class AddInstaledDesktopAppAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :installed_desktop_app_at, :datetime
  end
end
