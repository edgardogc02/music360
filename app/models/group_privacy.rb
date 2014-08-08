class GroupPrivacy < ActiveRecord::Base

  has_many :groups

  def self.public
    GroupPrivacy.where(name: "Public").first
  end

  def self.closed
    GroupPrivacy.where(name: "Closed").first
  end

  def self.secret
    GroupPrivacy.where(name: "Secret").first
  end

end
