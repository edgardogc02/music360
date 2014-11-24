ActiveAdmin.register Artist do

  menu priority: 3

  filter :title
  filter :bio
  filter :country
  filter :slug
  filter :imagename
  filter :top

  permit_params :title, :bio, :country, :slug, :imagename, :top, :bio_read_more_link, :model, :cover, :twitter

  index do
    selectable_column
    column :id
    column :title
    column :bio
    column :country
    column :slug
    column :imagename do |song|
      image_tag song.imagename_url, {height: "100", width: "100"}
    end
    column :twitter
    actions
  end

  form(html: { multipart: true }) do |f|
    f.inputs "Details" do
      f.input :title
      f.input :bio
      f.input :country, :as => :string
      f.input :slug
      f.input :top
      f.input :twitter
      f.input :bio_read_more_link
      if !f.object.new_record?
        f.input :imagename, as: :file, :hint => f.template.image_tag(f.object.imagename.url, {height: 100, width: 100})
      end
    end
    f.actions
  end

end
