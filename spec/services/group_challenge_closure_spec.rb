require 'spec_helper'

describe "GroupChallengeClosure" do

  context "close" do

    it 'should close a challenge group' do
      group_challenge = create(:group_challenge)
      GroupChallengeClosure.new(group_challenge).close
      group_challenge.open.should_not be_true
    end

    context 'assign extra xp points to winner' do
      context 'challenge with more than 1000 users' do
        it 'should assign 50000 xp points to winner' do
          check_user_points(10, 50000)
        end
      end

      context 'challenge with more than 500 users and less than 1000' do
        it 'should assign 25000 xp points to winner' do
          check_user_points(7, 25000)
        end
      end

      context 'challenge with more than 100 users and less than 500' do
        it 'should assign 20000 xp points to winner' do
          check_user_points(6, 20000)
        end
      end

      context 'challenge with more than 50 users and less than 100' do
        it 'should assign 15000 xp points to winner' do
          check_user_points(5, 15000)
        end
      end

      context 'challenge with more than 20 users and less than 50' do
        it 'should assign 10000 xp points to winner' do
          check_user_points(4, 10000)
        end
      end

      context 'challenge with more than 5 users and less than 20' do
        it 'should assign 5000 xp points to winner' do
          check_user_points(3, 5000)
        end
      end

      context 'challenge with more than 2 users and less than 5' do
        it 'should assign 2000 xp points to winner' do
          check_user_points(2, 2000)
        end
      end

      context 'challenge with just one user' do
        it 'should not assign any xp points to user' do
          check_user_points(1, 0)
        end
      end

      def check_user_points(total_users, winner_points)
        group_challenge = create(:group_challenge)
        song_scores = (total_users+1).times.inject([]) { |res, i| res << create(:song_score, challenge: group_challenge, score: i) }

        group_challenge_closure = GroupChallengeClosure.new(group_challenge)
        group_challenge_closure.set_ammount_of_users_for_points_level_1(8)
        group_challenge_closure.set_ammount_of_users_for_points_level_2(7)
        group_challenge_closure.set_ammount_of_users_for_points_level_3(6)
        group_challenge_closure.set_ammount_of_users_for_points_level_4(5)
        group_challenge_closure.set_ammount_of_users_for_points_level_5(4)
        group_challenge_closure.set_ammount_of_users_for_points_level_6(3)
        group_challenge_closure.set_ammount_of_users_for_points_level_7(2)
        group_challenge_closure.close

        group_challenge.group_winner.should eq(song_scores[total_users].user)
        song_scores[total_users].user.reload
        song_scores[total_users].user.xp.should eq(winner_points)
      end
    end

    context 'assign extra xp points to challenge creator' do
      context 'challenge with more than 2 players' do
        it 'should assign 1000 xp points to the challenge creator' do
          group_challenge = create(:group_challenge)
          song_scores = 3.times.inject([]) { |res, i| res << create(:song_score, challenge: group_challenge, score: i) }

          GroupChallengeClosure.new(group_challenge).close
          group_challenge.challenger.xp.should eq(1000)
        end
      end

      context 'challenge with less than 3 players' do
        it 'should not assign extra xp points to challenge creator' do
          group_challenge = create(:group_challenge)
          song_scores = 2.times.inject([]) { |res, i| res << create(:song_score, challenge: group_challenge, score: i) }

          GroupChallengeClosure.new(group_challenge).close
          group_challenge.challenger.xp.should eq(0)
        end
      end
    end

    context 'save activity feed' do
      it 'should save an activity feed that the group challenge has finished' do
        group_challenge = create(:group_challenge)
        GroupChallengeClosure.new(group_challenge).close

        activity = PublicActivity::Activity.where(challenge_id: group_challenge.id).order('created_at DESC').last

        activity.trackable.should eq(group_challenge)
        activity.key.should eq('challenge.group_challenge_closed')
      end
    end

    it 'notify_users_about_results' do
      pending
    end
  end

end