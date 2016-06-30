ActiveAdmin.register Patent do
  menu priority: 5
  config.batch_actions = false

  permit_params :number, :patent_expiration, :drug_substance_claim, :drug_product_claim, :delist_requested

  index do
    selectable_column
    id_column
    column :drug do |patent|
      app = patent.app_product.drug_application
      link_to app.drug.brand_name, admin_drug_path(app.drug_id)
    end
    column :application do |patent|
      app = patent.app_product.drug_application
      link_to app.application_number, admin_drug_application_path(app.id)
    end
    column :product_no do |patent|
      patent.app_product.product_number
    end
    column :number
    column :patent_expiration
    column :drug_substance_claim
    column :drug_product_claim
    column :delist_requested
    actions
  end

  filter :number
  filter :patent_expiration
  filter :drug_substance_claim
  filter :drug_product_claim

  form do |f|
    f.inputs "Patent" do
      f.input :number
      f.input :patent_expiration
      f.input :drug_substance_claim
      f.input :drug_product_claim
    end
    f.actions
  end
end