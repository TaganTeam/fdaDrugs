FactoryGirl.define do
  factory :email do
    user_id 1
    from "MyString"
    to "MyString"
    subject "MyString"
    status 1
  end
end
