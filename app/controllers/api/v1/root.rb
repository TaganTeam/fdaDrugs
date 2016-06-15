module API
  module V1
    class Root < Grape::API
      version 'v1'
      include API::Concern::Status
      include API::Concern::Session
      include API::Concern::Registration
      include API::Concern::Drugs

      add_swagger_documentation(
          base_path: '/api',
          hide_documentation_path: true,
          api_version: 'v1'
      )
    end
  end
end