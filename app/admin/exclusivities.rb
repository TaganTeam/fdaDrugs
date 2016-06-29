ActiveAdmin.register Exclusivity do
  config.batch_actions = false

  permit_params :number, :patent_expiration, :drug_substance_claim, :drug_product_claim, :delist_requested

  index do
    selectable_column
    id_column
    column :exclusivity_code_id
    column :exclusivity_expiration
    actions
  end

  filter :exclusivity_code_id
  filter :exclusivity_expiration

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