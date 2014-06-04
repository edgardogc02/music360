ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Users" do
          link_to User.count, admin_users_path
        end
      end
      column do
        panel "Songs" do
          link_to Song.count, admin_songs_path
        end
      end
      column do
        panel "Payment Types" do
          link_to PaymentType.count, admin_payment_types_path
        end
      end
    end
  end
end