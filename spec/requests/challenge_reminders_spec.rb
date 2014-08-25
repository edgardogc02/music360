require 'spec_helper'

describe "ChallengeReminders" do

  context "user is sign in" do
    before(:each) do
      @song = create(:song, cost: 0)
    end

    it "should not display remind button for challenges that user is not involved" do
      @user = login
      challenge = create(:challenge)
      visit challenge_path(challenge)
      page.should_not have_link "Remind on facebook", new_facebook_friend_message_modal_path(challenge_id: challenge.id)
    end

    it "should not display remind button if user is not connected with fb" do
      @user = login
      challenge = create(:challenge, challenger: @user)
      should_not_dispay_remind_button(challenge)
    end

    context "challenger connected with facebook" do
      before(:each) do
        signin_with_facebook
        @challenger = User.first
      end

      context "challenged not connected with facebook" do
        before(:each) do
          @challenged = create(:user)
          @challenge = create(:challenge, challenger: @challenger, challenged: @challenged)
        end

        context "challenger already played the challenge" do
          it "should not display the remind button if challenged didn't play the challenge" do
            @challenge.score_u1 = 100
            @challenge.save
            should_not_dispay_remind_button(@challenge)
          end

          it "should not display the remind button if challenged already played the challenge" do
            @challenge.score_u1 = 100
            @challenge.score_u2 = 100
            @challenge.save
            should_not_dispay_remind_button(@challenge)
          end
        end

        context "challenger didnt play the challenge" do
          it "should not display the remind button if challenged didn't played the challenge" do
            should_not_dispay_remind_button(@challenge)
          end

          it "should not display the remind button if challenged already played the challenge" do
            @challenge.score_u2 = 100
            @challenge.save
            should_not_dispay_remind_button(@challenge)
          end
        end
      end

      context "challenged connected with facebook" do
        context "challenger and challenged are not facebook friends" do

          before(:each) do
            click_on "Sign out"
            visit login_path
            new_mock_facebook_auth_hash
            click_link "facebook_signin"
            @challenged = User.last
            click_on "Sign out"
            signin_with_facebook
            @challenge = create(:challenge, challenger: @challenger, challenged: @challenged)
          end

          context "challenger already played challenge" do
            before(:each) do
              @challenge.score_u1 = 102
              @challenge.save
            end
            it "should not display remind button if challenged already played challenge" do
              @challenge.score_u2 = 132
              @challenge.save
              should_not_dispay_remind_button(@challenge)
            end

            it "should not display remind button if challenged didn't played challenge" do
              should_not_dispay_remind_button(@challenge)
            end
          end

          context "challenger didnt play the challenge yet" do
            it "should not display remind button if challenged already played the challenge" do
              @challenge.score_u2 = 102
              @challenge.save
              should_not_dispay_remind_button(@challenge)
            end

            it "should not display remind button if challenged didnt play the challenge yet" do
              should_not_dispay_remind_button(@challenge)
            end
          end

        end

        context "challenger and challenged are facebook friends" do

          before(:each) do
            create_facebook_omniauth_credentials(@challenger)
            UserFacebookFriends.new(@challenger, UserFacebookAccount.new(@challenger).top_friends).save

            click_on "Sign out"
            visit login_path
            mock_facebook_friend_auth_hash
            click_link "facebook_signin"
            @challenged = User.last
            click_on "Sign out"
            signin_with_facebook

            @challenged = User.last
            @challenge = create(:challenge, challenger: @challenger, challenged: @challenged)
          end

          context "challenger already played the challenge" do
            before(:each) do
              @challenge.score_u1 = 123
              @challenge.save
            end

            context "challenge is older than one day" do
              before(:each) do
                @challenge.created_at = 25.hours.ago
                @challenge.save
              end

              it "should display the remind button if challenged didn't play the challenge yet" do
                pending "this has changed"
                visit challenge_path(@challenge)
                page.should have_link "Remind on facebook", new_facebook_friend_message_modal_path(challenge_id: @challenge.id)
              end

              it "should not display the remind button if challenged already played the challenge" do
                @challenge.score_u2 = 1231
                @challenge.save
                should_not_dispay_remind_button(@challenge)
              end
            end

            context "challenge is not older than one day" do
              it "should not display the remind button if challenged didn't play the challenge yet" do
                should_not_dispay_remind_button(@challenge)
              end

              it "should not display the remind button if challenged already played the challenge" do
                @challenge.score_u2 = 12
                @challenge.save
                should_not_dispay_remind_button(@challenge)
              end
            end
          end

          context "challenger didn't play the challenge yet" do
            it "should not display the remind button if challenged already played the challenge" do
              @challenge.score_u2 = 12
              @challenge.save
              should_not_dispay_remind_button(@challenge)
            end

            it "should not display the remind button if challenged didn't playe the challenge yet" do
              should_not_dispay_remind_button(@challenge)
            end
          end

        end
      end
    end

    context "challenger not connected with facebook" do
      it "should not display the remind button" do
        @user = login
        challenge = create(:challenge, challenger: @user)
        should_not_dispay_remind_button(challenge)
      end
    end
  end

  context "user is not signed in" do
    it "should not display remind button" do
      challenge = create(:challenge)
      should_not_dispay_remind_button(challenge)
    end
  end

  def should_not_dispay_remind_button(challenge)
    visit challenge_path(challenge)
    page.should_not have_link "Remind on facebook", new_facebook_friend_message_modal_path(challenge_id: challenge.id)
  end

end
