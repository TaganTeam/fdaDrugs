ActiveAdmin.register AppProduct do
  menu priority: 4, label: 'Products'

  config.batch_actions = false

  permit_params :strength, :dosage, :market_status, :product_number

  index do
    selectable_column
    id_column
    column :drug_application_id do |product|
      link_to product.drug_application.application_number, admin_drug_application_path(product.drug_application_id)
    end
    column :strength
    column :dosage
    column :market_status
    column :product_number
    actions
  end

  filter :strength
  filter :dosage
  filter :market_status
  filter :product_number

  form do |f|
    f.inputs "AppProduct" do
      f.input :strength
      f.input :dosage
      f.input :market_status
      f.input :product_number
    end
    f.actions
  end

end