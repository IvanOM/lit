require 'test_helper'

module Lit
  class LocaleTest < ActiveSupport::TestCase
    fixtures 'lit/locales'
    fixtures 'lit/localization_keys'

    test 'uniqueness checking' do
      l = lit_locales(:pl)
      locale = Lit::Locale.new(locale: l.locale)
      assert (!locale.valid?)
    end

    test 'generating a gengo package' do
      reference_language = lit_locales(:en)
      new_language = lit_locales(:pl)
      lk = lit_localization_keys(:string)
      reference_localization = Lit::Localization.create(locale: reference_language,localization_key: lk,default_value: "value")
      new_localization = Lit::Localization.create(locale: new_language,localization_key: lk,default_value: nil.to_yaml)
      assert_equal new_language.gengo_package ,{
                                    :jobs => {
                                      :job_0 => {
                                        :type => "text",
                                        :slug => "scopes.string",
                                        :body_src => "value",
                                        :lc_src => "en",
                                        :lc_tgt => "pl",
                                        :tier => "standard"
                                      }
                                    }
                                  } 
    end

    test 'posting a gengo package' do
      reference_language = lit_locales(:en)
      new_language = lit_locales(:pl)
      lk = lit_localization_keys(:string)
      reference_localization = Lit::Localization.create(locale: reference_language,localization_key: lk,default_value: "value")
      new_localization = Lit::Localization.create(locale: new_language,localization_key: lk,default_value: nil.to_yaml)
      p new_language.gengo_package
      assert_equal new_language.send_to_gengo["opstat"], "ok"
    end


  end
end
