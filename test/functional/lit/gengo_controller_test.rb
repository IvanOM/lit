require 'test_helper'
require 'fakeweb'

module Lit
  class GengoControllerTest < ActionController::TestCase
    fixtures 'lit/locales'
    fixtures 'lit/localization_keys'

    setup do
      Lit.authentication_function = nil
      @routes = Lit::Engine.routes
      @reference_language = lit_locales(:en)
      @new_language = lit_locales(:pl)
      @lk = lit_localization_keys(:string)
      @reference_localization = Lit::Localization.new()
      @reference_localization.locale = @reference_language
      @reference_localization.localization_key = @lk
      @reference_localization.default_value = "value"
      @reference_localization.save
      @new_localization = Lit::Localization.new()
      @new_localization.locale = @new_language
      @new_localization.localization_key = @lk
      @new_localization.default_value = nil
      @new_localization.save
    end
    
    test 'should create source' do 
      assert_routing({method: "post", path: "/gengo"},{controller: "lit/gengo", action: "create"})
      post :create, job: {slug: @lk.localization_key, ob_id:"1235761",body_src:"value",lc_src:"en",lc_tgt:"pl",unit_count:"1",tier:"standard",credits:"0.05",status:"approved",eta:-1,ctime:1422313047,callback_url:"http:\/\/requestb.in\/1hm623f1",auto_approve:"1",body_tgt:"warto\u015b\u0107"}
      assert_equal "warto\u015b\u0107", @new_localization.reload.translated_value
    end
    
    test '#new should render a form' do
      assert_routing({method: "get", path: "/gengo/new"}, {controller: "lit/gengo", action: "new"})
      get :new
      assert_template :new
    end
    
    test '#new should assing locales' do
      get :new
      assert_equal Locale.ordered.all, assigns(:locales)
    end
  end
end
