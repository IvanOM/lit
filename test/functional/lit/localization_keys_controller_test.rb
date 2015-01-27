require 'test_helper'

module Lit
  class LocalizationKeysControllerTest < ActionController::TestCase
    
    setup do
      Lit.authentication_function = nil
      @routes = Lit::Engine.routes
      @pl_locale = create(:locale, locale: :pl)
      @en_localization = create(:localization,
        default_value: nil
      )
      @lk_hello_world = @en_localization.localization_key
      @pl_localization = create(:localization,
        locale: @pl_locale,
        localization_key: @lk_hello_world,
        default_value: "Hello World"
      )
    end
    
    test 'list for a locale should not assign localization_keys with translations' do
      get :index, current_locale: :en, key_prefix: "hello_world"
      assert_includes assigns(:localization_keys), @lk_hello_world
      get :index, current_locale: :pl, key_prefix: "hello_world"
      refute_includes assigns(:localization_keys), @lk_hello_world
    end
    
    test 'list all should assign localization_keys with translations' do
      get :index, all: true, current_locale: :pl, key_prefix: "hello_world"
      assert_includes assigns(:localization_keys), @lk_hello_world
    end
    
    test 'list search should assign localization_keys with translations' do
      get :index, current_locale: :pl, key: "hello_world"
      assert_includes assigns(:localization_keys), @lk_hello_world
    end
    
    test 'list should not assign ignored localization_keys' do
      @lk_hello_world.ignore = true
      @lk_hello_world.save
      get :index, current_locale: :en, key_prefix: "hello_world"
      refute_includes assigns(:localization_keys), @lk_hello_world
    end
  end
end