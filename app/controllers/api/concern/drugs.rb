module API
  module Concern::Drugs
    extend ActiveSupport::Concern
    included do

     segment :drugs do
       desc 'Return all drugs list'
       params do
         optional :access_token, type: String, desc: 'User access token'
         optional :page, type: Integer, desc: 'page number for drugs list', default: 1
         optional :per_page, type: Integer, desc: 'specify how many drugs in a page, default to 25', default: 25
       end

       get do
         drugs = Drug.all
         drugs = drugs.page(page).per(per_page)
         success! drugs.as_api_response(:basic), 200, 'success', {all_count: Drug.count}
       end
     end
    end
  end
end