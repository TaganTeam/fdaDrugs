ActiveAdmin.register DrugApplication do
  menu priority: 3, label: 'Applications'
  config.batch_actions = false

  permit_params :application_number, :company, :approval_date

  index do
    selectable_column
    id_column
    column :drug_id do |drug|
      link_to drug.drug.brand_name, admin_drug_path(drug.id)
    end
    column :application_number
    column :company
    column :approval_date
    actions
  end

  filter :application_number
  filter :company
  filter :approval_date

  form do |f|
    f.inputs "Plans Details" do
      f.input :application_number
      f.input :company
      f.input :approval_date
    end
    f.actions
  end

end