ActiveAdmin.register Artist do
  
  filter :title
  filter :bio
  filter :country
  filter :slug
  filter :imagename
  
  permit_params :title, :bio, :country, :slug, :imagename, :model
  
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
    actions
  end
  
  form(html: { multipart: true }) do |f|
    f.inputs "Details" do
      f.input :title
      f.input :bio
      f.input :country, :as => :string
      f.input :slug
      if !f.object.new_record?
        f.input :imagename, as: :file, :hint => f.template.image_tag(f.object.imagename.url, {height: 100, width: 100})
      end      
    end
    f.actions
  end

end
