FactoryGirl.define do
  factory :localization, class: Lit::Localization do
    association :localization_key, factory: :localization_key
    association :locale, factory: :locale
    default_value nil
  end
end