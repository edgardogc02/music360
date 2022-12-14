class UserPersonalActivityFeed

  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def self.limit
    10
  end

  def feeds
    @activity_feeds ||= PublicActivity::Activity.where(id: groups_feeds.ids + friends_groups_activity_feeds.ids + friends_activity_feeds.ids +
                                                            followers_groups_activity_feeds.ids + followers_activity_feeds.ids + one_to_one_challenge_feeds.ids +
                                                            one_to_one_proposed_challenge_feeds.ids + personal_feeds.ids).
                                                  order('created_at DESC').
                                                  limit(UserPersonalActivityFeed.limit)
  end

	private

  def groups_feeds
    @groups_feeds ||= PublicActivity::Activity.where(group_id: user.groups.map{|g| g.id}).
                                                order('created_at DESC').
                                                limit(UserPersonalActivityFeed.limit)
  end

  def one_to_one_challenge_feeds
     @one_to_one_challenge_feeds ||= PublicActivity::Activity.where(challenge_id: user.challenges.ids).
                                                              where("group_id IS NULL OR group_id = 0").
                                                              order('created_at DESC').
                                                              limit(UserPersonalActivityFeed.limit)
  end

  def one_to_one_proposed_challenge_feeds
    @one_to_one_proposed_challenge_feeds ||= PublicActivity::Activity.where(challenge_id: user.proposed_challenges.ids).
                                                                      where("group_id IS NULL OR group_id = 0").
                                                                      order('created_at DESC').
                                                                      limit(UserPersonalActivityFeed.limit)
  end

  def personal_feeds
    @personal_feeds ||= PublicActivity::Activity.where.not(id: one_to_one_challenge_feeds.ids).
                                                  where.not(id: one_to_one_proposed_challenge_feeds.ids).
                                                  where(owner_id: user.id).where("group_id IS NULL OR group_id = 0").
                                                  order('created_at DESC').
                                                  limit(UserPersonalActivityFeed.limit)
  end

  def friends_groups_activity_feeds
    @friends_groups_activity_feeds ||= PublicActivity::Activity.where(owner_id: user.facebook_friends.ids).
                                                                where(group_id: user.facebook_friends_groups.public.map{|g| g.id}).
                                                                where.not(group_id: user.groups.map{|g| g.id}).
                                                                order('created_at DESC').
                                                                limit(UserPersonalActivityFeed.limit)
  end

  def friends_activity_feeds
    @friends_activity_feeds ||= PublicActivity::Activity.where(owner_id: user.facebook_friends.ids).
                                                                where(group_id: nil).
                                                                order('created_at DESC').
                                                                limit(UserPersonalActivityFeed.limit)
  end

  def followers_groups_activity_feeds
    @followers_groups_activity_feeds ||= PublicActivity::Activity.where(owner_id: user.followers.ids).
                                                                  where(group_id: user.followers_groups.public.map{|g| g.id}).
                                                                  where.not(group_id: user.groups.map{|g| g.id}).
                                                                  order('created_at DESC').
                                                                  limit(UserPersonalActivityFeed.limit)
  end

  def followers_activity_feeds
    @followers_activity_feeds ||= PublicActivity::Activity.where(owner_id: user.followers.ids).
                                                                  where(group_id: nil).
                                                                  order('created_at DESC').
                                                                  limit(UserPersonalActivityFeed.limit)
  end

end
