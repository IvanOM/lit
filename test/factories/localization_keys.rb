FactoryGirl.define do
  factory :localization_key, class: Lit::LocalizationKey do
    localization_key "hello_world"
  end
end