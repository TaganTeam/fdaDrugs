ActiveAdmin.register Exclusivity do
  menu priority: 6
  config.batch_actions = false

  permit_params :number, :patent_expiration, :drug_substance_claim, :drug_product_claim, :delist_requested

  index do
    selectable_column
    id_column
    column :drug do |exclusivity|
      app = exclusivity.app_product.drug_application
      link_to app.drug.brand_name, admin_drug_path(app.drug_id)
    end
    column :application do |exclusivity|
      app = exclusivity.app_product.drug_application
      link_to app.application_number, admin_drug_application_path(app.id)
    end
    column :product_no do |exclusivity|
      exclusivity.app_product.product_number
    end
    column :exclusivity_code_id do |exclusivity|
      exclusivity.exclusivity_code.code
    end
    column :definition do |exclusivity|
      exclusivity.exclusivity_code.definition
    end
    column :exclusivity_expiration
    actions
  end

  filter :exclusivity_code_id
  filter :exclusivity_expiration

  form do |f|
    f.inputs "exclusivity" do
      f.input :number
      f.input :patent_expiration
      f.input :drug_substance_claim
      f.input :drug_product_claim
    end
    f.actions
  end
end