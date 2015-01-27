require 'test_helper'
require 'fakeweb'

module Lit
  class GengoControllerTest < ActionController::TestCase
    fixtures 'lit/locales'
    fixtures 'lit/localization_keys'
    test 'should create source' do
      reference_language = lit_locales(:en)
      new_language = lit_locales(:pl)
      lk = lit_localization_keys(:string)
      reference_localization = Lit::Localization.create(locale: reference_language,localization_key: lk,default_value: "value")
      new_localization = Lit::Localization.create(locale: new_language,localization_key: lk,default_value: nil.to_yaml)

      assert_difference('new_localization.translated_value') do
        post :create, job: {job_id:"1235761",body_src:"value",lc_src:"en",lc_tgt:"pl",unit_count:"1",tier:"standard",credits:"0.05",status:"approved",eta:-1,ctime:1422313047,callback_url:"http:\/\/requestb.in\/1hm623f1",auto_approve:"1",body_tgt:"warto\u015b\u0107"}
        new_localization.reload
      end
    end
  end
end
