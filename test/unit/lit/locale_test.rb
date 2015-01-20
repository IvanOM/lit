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
      l = lit_locales(:pl)
      lk = lit_localization_keys(:string)
      Lit::Localization.create(locale: l,localization_key: lk,default_value: "value")

      assert_equal l.gengo_package ,{
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
      l = lit_locales(:pl)
      lk = lit_localization_keys(:string)
      Lit::Localization.create(locale: l,localization_key: lk,default_value: "value")
      assert_equal l.send_to_gengo["opstat"], "ok"
    end


  end
end
