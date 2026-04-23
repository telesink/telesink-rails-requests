# frozen_string_literal: true

module Telesink
  module Rails
    module Requests
      class Railtie < ::Rails::Railtie
        initializer "telesink.rails.requests.subscribe" do
          ActiveSupport.on_load(:action_controller) do
            Telesink::Rails::Requests.install!
          end
        end
      end
    end
  end
end
