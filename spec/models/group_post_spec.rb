require 'spec_helper'

describe GroupPost do

  context "Validations" do
    it "should validate username" do
      [:publisher_id, :group_id, :message].each do |attr|
        should validate_presence_of(attr)
      end
    end
  end

  context "Associations" do
    it "should belongs to group" do
      should belong_to(:group)
    end

    it "should belongs to user" do
      should belong_to(:publisher).class_name('User').with_foreign_key("publisher_id")
    end

    it 'should have many likes' do
      should have_many(:likes).class_name('PostLike')
    end

    it 'should have many comments' do
      should have_many(:comments).class_name('PostComment')
    end

    it 'should have many likers' do
      should have_many(:likers).through(:likes).source(:user)
    end
  end

  context "Methods" do
    it "should return if a user likes a group_post" do
      group_post = create(:group_post)
      user = create(:user)

      group_post.liked_by?(user).should_not be_true

      create(:group_post_like, user: user, likeable: group_post)
      group_post.liked_by?(user).should be_true
    end
  end

end
