require 'rails_helper'

RSpec.describe Lit::Locale, type: :model do
  describe "when sending keys to gengo" do
    before do
      locale = Lit::Locale.create(locale: :en)
      locale_pt = Lit::Locale.create(locale: "pt-BR")
      localization_key = Lit::LocalizationKey.create(localization_key: 'scope.some_text')
      Lit::Localization.create(
        locale: locale,
        localization_key: localization_key,
        default_value: "Some Text",
        translated_value: "Some Text"
      )
      Lit::Localization.create(
        locale: locale_pt,
        localization_key: localization_key,
        default_value: "Some Text"
      )
    end

    it "should generate a proper translation package" do
      I18n.locale = :'pt-BR'
      Lit.init.cache.reset
      lang = Lit::Locale.find_by_locale('pt-BR')
      lang.gengo_package.should == {
                                    :jobs => {
                                      :job_0 => {
                                        :type => "text",
                                        :slug => "scope.some_text",
                                        :body_src => "Some Text",
                                        :lc_src => "en",
                                        :lc_tgt => "pt-br",
                                        :tier => "standard"
                                      }
                                    }
                                  }
    end

    it "should send the keys package to gengo" do
      I18n.locale = :'pt-BR'
      Lit.init.cache.reset
      lang = Lit::Locale.find_by_locale('pt-BR')
      lang.send_to_gengo["opstat"].should == "ok"
    end
  end
end
