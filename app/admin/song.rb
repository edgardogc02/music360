ActiveAdmin.register Song do

  menu priority: 2

  filter :title
  filter :category
  filter :artist
  filter :cost
  filter :length
  filter :difficulty
  filter :status
  #filter :onclient
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
      f.input :midi, as: :file, :label => "Midi (Same name as title)"
      f.input :length, :label => "Length(sec)"
      f.input :difficulty, :label => "Difficulty(3=hard,2=medium,1=easy)"
      f.input :status, :label => "Status(3=hard,2=medium,1=easy)"
      #f.input :onclient
      f.input :writer
      f.input :arranger_userid, :label => "Arranger(1243=Mauro, 0=Magnus)"
      f.input :published_at, :label => "Published at(leave blank->NOW)"
      f.input :publisher
      f.input :cost
    end
    f.actions
  end

  action_item only: :index do
    link_to "New midi song", new_midi_admin_songs_path
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
      @song.length = 60
      @song.difficulty = 1
      @song.artist_id = 0
      @song.arranger_userid = 1243
      @song.uploader_user_id = current_user.id
      @song.status = "playable"
      @song.published_at = Time.now
      @song.user_created = 0
      @song.onclient = 0
    end

    if @song.save
      redirect_to admin_songs_path, notice: "The song was successfully created"
    else
      flash.now[:warning] = "Something went wrong, please try again. Don't forget to upload a mid file."
      render "new_midi"
    end
  end

end
