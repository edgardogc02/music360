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

  permit_params :category_id, :artist_id, :title, :cover, :length, :difficulty, :status, :onclient, :writer, :arranger_userid, :published_at, :publisher, :cost, :midi, :on, :model

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
    column :midi
    column :created_at
    actions
  end

  form(html: { multipart: true }) do |f|
    f.inputs "Details" do
      f.input :title
      f.input :category
      f.input :artist
      if !f.object.new_record?
        f.input :cover, as: :file, :hint => f.template.image_tag(f.object.cover.url, {height: 100, width: 100})
      end
      f.input :midi, as: :file
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

  action_item only: :index do
    link_to "New mini song", new_midi_admin_songs_path
  end

  collection_action :new_midi, method: :get  do
    @song = Song.new
  end

  collection_action :save_new_midi, method: :post do
    @song = Song.new

    if params[:song]
      @song.midi = params[:song][:midi]
      @song.title = params[:song][:midi].original_filename[0..-5]
      @song.writer = "default"
      @song.length = 1
      @song.difficulty = 1
      @song.arranger_userid = 1
      @song.status = "ok"
      @song.onclient = 1
      @song.published_at = Time.now
    end

    if @song.save
      redirect_to admin_songs_path, notice: "The song was successfully created"
    else
      flash.now[:warning] = "Something went wrong, please try again. Don't forget to upload a mid file."
      render "new_midi"
    end
  end

end
