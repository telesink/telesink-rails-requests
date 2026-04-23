# frozen_string_literal: true

module Telesink
  module Rails
    module Requests
      SKIP_PATHS = %w[/up /health /healthz /ping /favicon.ico].freeze
      SKIP_PREFIXES = %w[/assets /packs /cable].freeze

      class << self
        def install!
          ActiveSupport::Notifications.subscribe("process_action.action_controller") do |event|
            track_event(event)
          end
        end

        private

        def track_event(event)
          payload = event.payload
          path = payload[:path]&.split("?")&.first

          return if skip?(path)

          status = payload[:status] || (payload[:exception_object] ? 500 : 200)

          Telesink.track(
            event: payload[:method],
            text:"#{payload[:path]} → #{status}",
            emoji: status_emoji(status),
            properties: build_properties(event, payload, status),
            endpoint: resolve_endpoint
          )
        rescue => e
          ::Rails.logger.error("[Telesink] Failed to track request: #{e.message}")
        end

        def build_properties(event, payload, status)
          {
            method: payload[:method],
            path: payload[:path],
            controller: payload[:controller],
            action: payload[:action],
            status: status,
            duration_ms: event.duration.round(2),
            db_ms: payload[:db_runtime]&.round(2),
            view_ms: payload[:view_runtime]&.round(2),
            ip: payload[:request].remote_ip,
            user_agent: payload[:request].user_agent&.slice(0, 200),
            referer: payload[:request].referer,
            host: payload[:request].host,
            request_id: payload[:request].request_id,
            params: payload[:params],
            exception: payload[:exception]&.first
          }.compact
        end

        def skip?(path)
          return true if path.nil?
          SKIP_PATHS.include?(path) ||
            SKIP_PREFIXES.any? { |prefix| path.start_with?(prefix) }
        end

        def status_emoji(status)
          case status.to_i
          when 200..299 then "✅"
          when 300..399 then "🔄"
          when 400..499 then "⚠️"
          when 500..599 then "❌"
          else
            "📡"
          end
        end

        def resolve_endpoint
          ENV["TELESINK_REQUESTS_ENDPOINT"] || ENV["TELESINK_ENDPOINT"]
        end
      end
    end
  end
end
