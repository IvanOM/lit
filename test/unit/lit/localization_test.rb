require 'test_helper'

module Lit
  class LocalizationTest < ActiveSupport::TestCase
    fixtures 'lit/localization_keys'
    fixtures 'lit/locales'

    test 'does not create version upon creation' do
      I18n.locale = :en
      assert_no_difference 'Lit::LocalizationVersion.count' do
        Lit.init.cache.reset
        assert_equal 'English translation', I18n.t('scope.text_with_translation_in_english')
      end
    end

    test 'does create new version upon update via model' do
      I18n.locale = :en
      assert_difference 'Lit::LocalizationVersion.count' do
        Lit.init.cache.reset
        assert_equal 'English translation', I18n.t('scope.text_with_translation_in_english')
        lang = Lit::Locale.find_by_locale('en')
        lk = Lit::LocalizationKey.find_by_localization_key('scope.text_with_translation_in_english')
        l = Lit::Localization.where('localization_key_id=?', lk).where('locale_id=?', lang).first
        assert_not_nil l
        l.update_attribute :is_changed, false
        l.reload
        l.translated_value = 'test'
        l.save!
        l.reload
        assert_equal true, l.is_changed?
      end
      Lit.init.cache.reset
      assert_equal 'test', I18n.t('scope.text_with_translation_in_english')
    end

    test 'returns the correct reference language' do
      reference_language = lit_locales(:en)
      new_language = lit_locales(:pl)
      lk = lit_localization_keys(:string)
      reference_localization = Lit::Localization.create(locale: reference_language,localization_key: lk,default_value: "value")
      new_localization = Lit::Localization.create(locale: new_language,localization_key: lk,default_value: nil.to_yaml)
      assert_equal new_localization.reference_value, "value"
    end
  end
end
