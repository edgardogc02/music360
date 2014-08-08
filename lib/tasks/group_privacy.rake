require 'paymill'

namespace :group_privacy do
  desc "Create all group privacies"
  task create_group_privacies: :environment do

    GroupPrivacy.destroy_all

    GroupPrivacy.create name: "Public", description: "Anyone can see the group, it's member and their posts."
    GroupPrivacy.create name: "Closed", description: "Anyone can find the group and see who's in it. Only members can see posts."
    GroupPrivacy.create name: "Secret", description: "Only members can find the group and see posts."
  end
end