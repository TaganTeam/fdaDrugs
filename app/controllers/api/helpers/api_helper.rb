module API
  module Helpers
    module ApiHelper
      extend ActiveSupport::Concern

      included do
        format :json
        # common Grape settings
        helpers API::Helpers::RenderHelper
        helpers API::Helpers::AuthHelper

        helpers do
          def stub_params(params, upload_attr='', nested_attr='')
            if nested_attr.present? && params[nested_attr].present? && params[nested_attr][upload_attr].present?
              params[nested_attr][upload_attr] = dispatch_file(params[nested_attr][upload_attr])
            elsif params[upload_attr].present?
              params[upload_attr] = dispatch_file(params[upload_attr])
            end if upload_attr.present?
            return params
          end

          def dispatch_file(file_params)
            file_hash = {
                filename: file_params[:filename],
                type:     file_params[:type],
                headers:  file_params[:head],
                tempfile: file_params[:tempfile]
            }
            ActionDispatch::Http::UploadedFile.new(file_hash)
          end

          def template_type
            params[:template] || :default
          end

          def page
            params[:page] || 1
          end

          def per_page
            params[:per_page] || 25
          end

          def permit_params(key, attributes)
            ActionController::Parameters.new(params).require(key).permit(attributes)
          end
        end

        rescue_from ActiveRecord::RecordNotFound do |e|
          Rack::Response.new({
                                 'code' => 404,
                                 "status" => 'not_found',
                                 'error' => e.message.gsub(/\s*\[.*\Z/, '')
                             }.to_json, 404)
        end

        rescue_from ActiveRecord::RecordInvalid do |e|
          Rack::Response.new({
                                 'code' => 403,
                                 "status" => 'record_invalid',
                                 'error' => e.message.downcase.capitalize
                             }.to_json, 403)
        end

        rescue_from Grape::Exceptions::ValidationErrors do |e|
          Rack::Response.new({
                                 'code' => 400,
                                 "status" => 'error',
                                 'error' => e.message.downcase.capitalize
                             }.to_json, 400)
        end

        rescue_from :all do |e|
          Rack::Response.new({
                                 'code' => 500,
                                 "status" => 'error',
                                 'error' => e.message.downcase.capitalize
                             }.to_json, 500)
        end

      end
    end
  end
end
