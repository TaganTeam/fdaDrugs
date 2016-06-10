module API
  module Concern::Status
    extend ActiveSupport::Concern
    included do

      desc "Returns the status of the Base"
      get '/status' do
        { status: 'ok', time: DateTime.now, version: '1.0' }
      end

    end
  end
end
