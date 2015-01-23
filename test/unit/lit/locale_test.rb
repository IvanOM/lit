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
                                        :tier => "standard",
                                        :auto_approve => "1"
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
      assert_equal new_language.send_to_gengo["opstat"], "ok"
    end

    test "should insert a localization from a gengo job" do
      reference_language = lit_locales(:en)
      new_language = lit_locales(:pl)
      lk = lit_localization_keys(:string)
      reference_localization = Lit::Localization.create(locale: reference_language,localization_key: lk,default_value: "value")
      new_localization = Lit::Localization.create(locale: new_language,localization_key: lk,default_value: nil.to_yaml)
      job = {"job_id"=>"1235761", "order_id"=>"325426", "body_src"=>"value", "slug"=>"scopes.string", "lc_src"=>"en", "lc_tgt"=>"pl", "unit_count"=>"1", "tier"=>"standard", "credits"=>"0.05", "currency"=>"USD", "status"=>"approved", "eta"=>-1, "ctime"=>1422313047, "callback_url"=>"http://requestb.in/1hm623f1", "auto_approve"=>"1", "body_tgt"=>"wartość"}
      new_language.create_localization_from_gengo(job)
      new_localization.reload
      assert_equal new_localization.translated_value,"wartość"
    end

  end
end
