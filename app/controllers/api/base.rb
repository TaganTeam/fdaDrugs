module API
  class Base < Grape::API
    include API::Helpers::ApiHelper
    mount API::V1::Root

    helpers do
      def declared_api_params
        declared(params).except(:access_token)
      end
    end
  end
end