ActiveAdmin.register Drug do

  config.batch_actions = false

  permit_params :brand_name, :generic_name

  index do
    selectable_column
    id_column
    column :brand_name
    column :generic_name
    actions
  end

  filter :brand_name
  filter :brand_name
  filter :created_at

  form do |f|
    f.inputs "Drugs" do
      f.input :brand_name
      f.input :generic_name
    end
    f.actions
  end

end