class UserCategory < ActiveRecord::Base
  has_many :users, as: :people
end
