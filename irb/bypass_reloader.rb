module IRB
  module BypassReloader
    def self.setup
      rails_version  = Rails::VERSION::STRING
      reloader_class = if rails_version[0..2] =~ /3\.[^0]/
                         ActionDispatch::Reloader
                       else
                         ActionDispatch::Callbacks
                       end

      reloader_class.class_eval do
        def call(env)
          @app.call(env)
        end
      end

      if defined?(RailsDevTweaks::GranularAutoload::Middleware)
        RailsDevTweaks::GranularAutoload::Middleware.class_eval do
          def call(env)
            @app.call(env)
          end
        end
      end
    end
    setup if defined?(::Rails)
  end
end

