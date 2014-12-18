module Venus
  class Slack < ::Venus::Base

    def generate!
      if (has_gem?("capistrano") || has_gem?("capistrano-rails"))
        cap_version = gem_version("capistrano").to_i
        if cap_version == 3
          capistrano_3
        elsif cap_version == 2
          capistrano_2
        end
      else
        say "You don't have capistrano, please run `rails g venus:capistrano` to install it."
      end
    end


    private

    def ask_for_slack
      @team = ask?("slack team ? (If URL is 'team.slack.com', value is 'team')", '')
      say "go to https://{YOUR TEAM NAME}.slack.com/services/new/incoming-webhook create web hook to get token"
      @webhook = ask?("InComing Web Hook url", '')
      @room = ask?("slack room", "#general")
    end

    def capistrano_3
      ask_for_slack
      add_gem("slackistrano")
      bundle_install
      insert_line_into_file("Capfile", "require 'slackistrano'")
      template("slack.cap.erb", "lib/capistrano/tasks/slack.rake")
      say "to test:"
      say "  cap production slack:deploy:starting"
      say "  cap production slack:deploy:finished"
    end

    def capistrano_2
      ask_for_slack
      add_gem("capistrano-slack")
      bundle_install
      insert_line_into_file("Capfile", "load 'config/deploy/slack'")
      template("slack.rb.erb", "config/deploy/slack.rb")
    end

  end
end