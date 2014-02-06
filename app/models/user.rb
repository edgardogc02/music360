class User < ActiveRecord::Base
	has_many :challenges
end
