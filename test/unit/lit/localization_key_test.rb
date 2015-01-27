require 'test_helper'

module Lit
  class LocalizationKeyTest < ActiveSupport::TestCase
    fixtures 'lit/localization_keys'
    fixtures 'lit/locales'

    def setup
      @localization_key = lit_localization_keys(:hello_world)
      locale_pl = lit_locales(:pl)
      locale_en = lit_locales(:en)
      localization = Lit::Localization.new()
      localization.locale = locale_pl
      localization.localization_key = @localization_key
      localization.default_value = nil
      localization.save()

      localization = Lit::Localization.new()
      localization.locale = locale_en
      localization.localization_key = @localization_key
      localization.default_value = "Some text"
      localization.save()
    end

    test 'uniqueness checking' do
      l = lit_localization_keys(:hello_world)
      lk = Lit::LocalizationKey.new(localization_key: l.localization_key)
      assert (!lk.valid?)
    end

    test 'nulls_for scope' do
      assert_equal([@localization_key], Lit::LocalizationKey.nulls_for(:pl))
      assert_equal([], Lit::LocalizationKey.nulls_for(:en))
    end

    test 'not scope' do
      assert_includes Lit::LocalizationKey.not(:completed), @localization_key
      @localization_key.is_completed = true
      @localization_key.save
      refute_includes Lit::LocalizationKey.not(:completed), @localization_key
    end

    test 'ignored scope' do
      refute_includes Lit::LocalizationKey.ignored, @localization_key
      @localization_key.ignore = true
      @localization_key.save
      assert_includes Lit::LocalizationKey.ignored, @localization_key
    end
  end
end
