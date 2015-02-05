require_dependency 'lit/application_controller'

module Lit
  class GengoController < ApplicationController
    def create
      if params[:job] and params[:job][:lc_tgt]
        locale = Locale.find_by_locale params[:job][:lc_tgt]
        locale.create_localization_from_gengo(params[:job])
      end
      render text:"ok"
    end
    
    def new
      @locales = Locale.ordered.all
    end
  end
end
