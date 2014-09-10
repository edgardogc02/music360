PublicActivity::Activity.class_eval do

  has_many :likes, class_name: 'ActivityLike'
  has_many :comments, class_name: 'ActivityComment'

end
