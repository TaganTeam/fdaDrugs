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
         drugs = Drug.all.order('brand_name')
         drugs = drugs.page(page).per(per_page)
         success! drugs.as_api_response(:basic), 200, 'success', {all_count: Drug.count}
       end

       desc "Return drug details"
       params do
         optional :access_token, type: String, desc: 'User access token'
       end

       get '/:id' do
         begin
           drug = Drug.find_by_id params[:id]
           drug_apps = drug.drug_applications

           if drug_apps.length > 1
             success! drug_apps.as_api_response(:basic), 200
           else
             success! drug_apps.first.as_api_response(:full_single), 200
           end

         rescue => e
           throw_error! 403, e.class.to_s, e.message
         end
       end

       desc "Return drug details"
       params do
         optional :access_token, type: String, desc: 'User access token'
       end
       get '/application/:id' do
         begin
           app = DrugApplication.find_by_id params[:id]
           success! app.as_api_response(:full_single), 200

         rescue => e
           throw_error! 403, e.class.to_s, e.message
         end
       end



     end

    end
  end
end