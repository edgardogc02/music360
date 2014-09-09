class UserPersonalActivityFeed

  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def self.limit
    10
  end

  def feeds
    @activity_feeds ||= PublicActivity::Activity.where(id: groups_feeds + friends_gruoups_activity_feeds + friends_activity_feeds +
                                                            followers_groups_activity_feeds + followers_activity_feeds + one_to_one_challenge_feeds +
                                                            one_to_one_proposed_challenge_feeds + personal_feeds).
                                                  order('created_at DESC').
                                                  limit(UserPersonalActivityFeed.limit)
  end

	private

  def groups_feeds
    @groups_feeds ||= PublicActivity::Activity.where(group_id: user.groups).
                                                order('created_at DESC').
                                                limit(UserPersonalActivityFeed.limit)
  end

  def one_to_one_challenge_feeds
     @one_to_one_challenge_feeds ||= PublicActivity::Activity.where(challenge_id: user.challenges).
                                                              where("group_id IS NULL OR group_id = 0").
                                                              order('created_at DESC').
                                                              limit(UserPersonalActivityFeed.limit)
  end

  def one_to_one_proposed_challenge_feeds
    @one_to_one_proposed_challenge_feeds ||= PublicActivity::Activity.where(challenge_id: user.proposed_challenges).
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

  def friends_gruoups_activity_feeds
    @friends_groups_activity_feeds ||= PublicActivity::Activity.where(owner_id: user.facebook_friends).
                                                                where(id: user.facebook_friends_groups.public).
                                                                where.not(group_id: user.groups).
                                                                order('created_at DESC').
                                                                limit(UserPersonalActivityFeed.limit)
  end

  def friends_activity_feeds
    @friends_activity_feeds ||= PublicActivity::Activity.where(owner_id: user.facebook_friends).
                                                                where(group_id: nil).
                                                                order('created_at DESC').
                                                                limit(UserPersonalActivityFeed.limit)
  end

  def followers_groups_activity_feeds
    @followers_groups_activity_feeds ||= PublicActivity::Activity.where(owner_id: user.followers).
                                                                  where(id: user.followers_groups.public).
                                                                  where.not(group_id: user.groups).
                                                                  order('created_at DESC').
                                                                  limit(UserPersonalActivityFeed.limit)
  end

  def followers_activity_feeds
    @followers_activity_feeds ||= PublicActivity::Activity.where(owner_id: user.followers).
                                                                  where(group_id: nil).
                                                                  order('created_at DESC').
                                                                  limit(UserPersonalActivityFeed.limit)
  end

end
