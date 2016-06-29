ActiveAdmin.register User do
  config.batch_actions = false

  permit_params :email

  index do
    selectable_column
    id_column
    column :email
    column :created_at
    actions
  end

  filter :email
  filter :created_at

  form do |f|
    f.inputs "Users" do
      f.input :email
    end
    f.actions
  end
end