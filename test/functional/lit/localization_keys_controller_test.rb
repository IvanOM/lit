require 'test_helper'

module Lit
  class LocalizationKeysControllerTest < ActionController::TestCase
    
    before do
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
    
    describe Lit::LocalizationKeysController do
      it 'index should not assign localization_keys with translations when
        a locale was specified' do
        get :index, current_locale: :en, key_prefix: "hello_world"
        assert_includes assigns(:localization_keys), @lk_hello_world
        get :index, current_locale: :pl, key_prefix: "hello_world"
        refute_includes assigns(:localization_keys), @lk_hello_world
      end
      
      it 'index should assign localization_keys with translations when listing 
        all' do
        get :index, all: true, current_locale: :pl, key_prefix: "hello_world"
        assert_includes assigns(:localization_keys), @lk_hello_world
      end
      
      it 'index should assign localization_keys with translations when 
        searching' do
        get :index, current_locale: :pl, key: "hello_world"
        assert_includes assigns(:localization_keys), @lk_hello_world
      end
      
      it 'index should not assign ignored localization_keys when not asked 
        to' do
        @lk_hello_world.ignore = true
        @lk_hello_world.save
        get :index, key_prefix: "hello_world", include_ignored: false
        refute_includes assigns(:localization_keys), @lk_hello_world
      end
      
      it 'should assign ignored localization_keys when asked to' do
        @lk_hello_world.ignore = true
	@lk_hello_world.save
        get :index, key_prefix: "hello_world", include_ignored: true
        assert_includes assigns(:localization_keys), @lk_hello_world
      end
      
      describe "GET export_to_gengo_rails" do
        it "should export scope to gengo_rails" do
          skip("do this after this feature is finished")
        end
      end
    end
  end
end
