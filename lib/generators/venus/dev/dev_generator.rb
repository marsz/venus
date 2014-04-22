module Venus
  module Generators
    class DevGenerator < Base
      desc "Setup development tools"

      def name
        "development"
      end

      def asks
        @gems = []
        @cmds = []
        @procs = []
        @spring = ask?("install spring ( http://rubygems.org/gems/spring )", true)
        @spring ||= has_gem?('spring')
        @guard = ask?("install guard for any guard-supported gems ( http://rubygems.org/gems/guard )", true)
        @guard_rspec = ask?("install guard for rspec ( http://rubygems.org/gems/guard-rspec ) ") if has_gem?("rspec")
        @better_errors = ask?("install better_errors ( http://rubygems.org/gems/better_errors )", true)
        @pry = ask?("install pry ( http://rubygems.org/gems/pry )", true)
        @xray = ask?("install xray ( http://rubygems.org/gems/xray-rails ) ", true)
        @ap = ask?("install awesome_print ( http://rubygems.org/gems/awesome_print ) ", true)
        @annotate = ask?("install annotate ( http://rubygems.org/gems/annotate ) ", true)
        @rails_panel = ask?("install rails_panel ( http://rubygems.org/gems/meta_request )", true)
        @dev_rake = ask?("initialize dev.rake for generate fake data ") unless has_file?("lib/tasks/dev.rake")
      end

      def spring
        if @spring
          append_gem_into_group("development", "spring")
          if has_gem?("rspec")
            append_gem_into_group("development", "spring-commands-rspec")
          end
          if has_gem?("factory_girl_rails")
            @spring_factory_girl = true
            # append_gem_into_group("development", "listen")
          end
          if has_file?("config/spring.rb")
            insert_template("config/spring.rb", "spring.rb.erb")
          else
            template("spring.rb.erb", "config/spring.rb")
          end
          @cmds << "spring binstub --all"
        end
      end

      def guard
        if @guard
          append_gem_into_group("development", "guard")
          @cmds << "guard init" unless has_gem?("guard")
        end
      end

      def guard_rspec
        if @guard_rspec
          append_gem_into_group("development", "guard-rspec")
          @cmds << "guard init rspec" if has_gem?("guard") && !has_gem?("guard-rspec")
          if @spring || has_gem?("spring")
            @procs << lambda {
              replace_in_file("Guardfile", "guard :rspec", "guard :rspec, :cmd => 'bin/rspec'")
            }
          end
        end
      end

      def better_errors
        if @better_errors
          append_gem_into_group("development", "binding_of_caller")
          append_gem_into_group("development", "better_errors")
        end
      end

      def pry
        if @pry
          append_gem_into_group("development", "pry-remote")
          append_gem_into_group("development", "pry-rails")
          append_gem_into_group("development", "pry")
        end
      end

      def xray
        if @xray
          append_gem_into_group("development", "xray-rails")
        end
      end

      def ap
        if @ap
          append_gem_into_group("development", "awesome_print")
        end
      end

      def annotate
        if @annotate
          append_gem_into_group("development", "annotate")
          if @guard
            append_gem_into_group("development", "guard-annotate")
            @cmds << "guard init annotate" if has_gem?("guard")  && !has_gem?("guard-annotate")
          end
        end
      end

      def rails_panel
        if @rails_panel
          append_gem_into_group("development", "meta_request")
          @procs << lambda {
            say "===================="
            say "rails_panel:"
            say "  Install Chrome extsion for rails_panel: https://chrome.google.com/webstore/detail/railspanel/gjpfobpafnhjhbajcjgccbbdofdckggg"
            say "===================="
          }
        end
      end

      def fake_rake
        if @fake_rake
          template("dev.rake", "lib/tasks/dev.rake")
        end
      end

      def executes
        replace_in_file("Gemfile", "\n\n", "\n") rescue nil
        bundle_install
        ask_bundle_update
        @cmds.each do |cmd|
          bundle_exec(cmd)
        end
        @procs.each do |proc|
          proc.call
        end
      end

    end
  end
end
