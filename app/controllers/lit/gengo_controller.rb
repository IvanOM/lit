require_dependency 'lit/application_controller'

module Lit
  class GengoController < ApplicationController
    before_filter :get_locales, only: [:new, :translate]
    
    def create
      if params[:job] and params[:job][:lc_tgt]
        locale = Locale.find_by_locale params[:job][:lc_tgt]
        locale.create_localization_from_gengo(params[:job])
      end
      render text:"ok"
    end
    
    def translate
      locales = Locale.just_locale(params[:locales])
      locales.each do |locale|
        locale.send_to_gengo
      end
      render :new
    end
    
    def new
    end
    
    private
    
    def get_locales
      @locales = Locale.ordered.all
    end
  end
end
