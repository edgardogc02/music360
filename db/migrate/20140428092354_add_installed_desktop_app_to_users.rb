class AddInstalledDesktopAppToUsers < ActiveRecord::Migration
  def change
    add_column :users, :installed_desktop_app, :boolean
  end
end
