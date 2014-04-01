require 'spec_helper'

describe User do

  context "Validations" do
    it { should have_secure_password }

    it "should validate username" do
      should validate_presence_of(:username)
      validate_uniqueness_of(:username)
    end

    it "should validate email" do
      should validate_presence_of(:email)
      validate_uniqueness_of(:email)
      should allow_value('test@test.com', 'test@test.com.ar').for(:email)
      should_not allow_value('@test.com', 'test@.com', 'test@sdads@asasd.com', 'test@ad.com.com.com').for(:email)
    end

    it "should validate password" do
      should validate_presence_of(:password)
      should validate_presence_of(:password_confirmation)
    end
  end

  context "Associations" do
#    it { should have_many(:challenges) }
    it { should belong_to(:people_category) }
  end

end