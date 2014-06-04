ActiveAdmin.register Song do

  filter :title
  filter :category
  filter :artist
  filter :cost
  filter :length
  filter :difficulty
  filter :status
  filter :onclient
  filter :writer
  filter :created_at
  filter :published_at
  filter :user_created

  scope :all
  scope :free
  scope :paid

  permit_params :category_id, :artist_id, :title, :cover, :length, :difficulty, :status, :onclient, :writer, :arranger_userid, :published_at, :publisher, :cost, :on, :model

  index do
    selectable_column
    column :id
    column :cover do |song|
      image_tag song.cover_url, {height: "100", width: "100"}
    end
    column :title
    column :category
    column :cost
    column :artist
    column :length
    column :difficulty
    column :status
    column :onclient
    column :writer
    column :arranger_userid
    column :publisher
    column :published_at
    column :slug
    column :user_created
    column :created_at
    actions
  end

  form(html: { multipart: true }) do |f|
    f.inputs "Details" do
      f.input :title
      f.input :category
      f.input :artist
      if !f.object.new_record?
        f.input :cover, as: :file
      end
      f.input :length
      f.input :difficulty
      f.input :status
      f.input :onclient
      f.input :writer
      f.input :arranger_userid
      f.input :published_at
      f.input :publisher
      f.input :cost
    end
    f.actions
  end

end
