class PeopleCategory < ActiveRecord::Base
  has_many :users, as: :people
end
