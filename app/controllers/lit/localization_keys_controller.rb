module Lit
  class LocalizationKeysController < ::Lit::ApplicationController
    before_filter :get_localization_scope, except: [:destroy]

    def index
      get_localization_keys
    end

    def update
      @localization_key = LocalizationKey.find params[:id]
      @localization_key.ignore = !@localization_key.ignore
      @localization_key.save
      respond_to :js
    end
    
    def ignore_all
      @scope.update_all(ignore: true)
      redirect_to localization_keys_path(params.except(:action, :controller, :authenticity_token))
    end

    def starred
      @scope = @scope.where(is_starred: true)

      if defined?(Kaminari) and @scope.respond_to?(Kaminari.config.page_method_name)
        @scope = @scope.send(Kaminari.config.page_method_name, params[:page])
      end
      get_localization_keys
      render action: :index
    end

    def star
      @localization_key = LocalizationKey.find params[:id].to_i
      @localization_key.is_starred = ! @localization_key.is_starred?
      @localization_key.save
      respond_to :js
    end

    def destroy
      @localization_key = LocalizationKey.find params[:id].to_i
      @localization_key.destroy
      I18n.backend.available_locales.each do |l|
        Lit.init.cache.delete_key "#{l}.#{@localization_key.localization_key}"
      end
      respond_to :js
    end

    private

    def get_current_locale
      @current_locale = params[:current_locale]
    end

    def get_all
      return params[:all]
    end

    def localizations_without_value
      localizations = Lit::Localization.within(@scope).without_value
      return localizations.for_locale(@current_locale) if @current_locale and @current_locale != ''
      return localizations
    end

    def get_localization_scope
      get_current_locale
      @include_ignored = params[:include_ignored]
      @search_options = params.slice(*valid_keys)
      @search_options[:include_completed] = '1' if @search_options.empty?
      @scope = LocalizationKey.uniq.preload(localizations: :locale)
        .search(@search_options)
      if @current_locale and @current_locale != '' and !get_all and
         (!@search_options[:key] or @search_options[:key].empty?)
        @scope = @scope.nulls_for(@current_locale)
      end
      
      unless @include_ignored
        @scope = @scope.not(:ignored)
      end
      return @scope
    end

    def get_localization_keys
      key_parts = @search_options[:key_prefix].to_s.split('.').length
      @prefixes = @scope.reorder(nil).uniq.pluck(:localization_key).map { |lk| 
        lk.split('.').shift(key_parts + 1).join('.')
      }.uniq.sort
      if @search_options[:key_prefix].present?
        parts = @search_options[:key_prefix].split('.')
        @parent_prefix = parts[0, parts.length - 1].join('.')
      end
      if defined?(Kaminari) and @scope.respond_to?(Kaminari.config.page_method_name)
        @localization_keys = @scope.send(Kaminari.config.page_method_name, params[:page])
      else
        @localization_keys = @scope.all
      end
    end

    def valid_keys
      %w( key include_completed key_prefix order )
    end

    def grouped_localizations
      @_grouped_localizations ||= begin
        {}.tap do |hash|
          @localization_keys.each do |lk|
            hash[lk] = {}
            lk.localizations.each do |l|
              hash[lk][l.locale.locale.to_sym] = l
            end
          end
        end
      end
    end

    def localization_for(locale, localization_key)
      @_localization_for ||= {}
      key = [locale, localization_key]
      ret = @_localization_for[key]
      if ret == false
        nil
      elsif ret.nil?
        ret = grouped_localizations[localization_key][locale]
        unless ret
          Lit.init.cache.refresh_key("#{locale}.#{localization_key.localization_key}")
          ret = localization_key.localizations.where(locale_id: Lit.init.cache.find_locale(locale).id).first
        end
        @_localization_for[key] = ret ? ret : false
      else
        ret
      end
    end

    helper_method :localization_for
    helper_method :localizations_without_value

    def has_versions?(localization)
      @_versions ||= begin
        ids = grouped_localizations.values.map(&:values).flatten.map(&:id)
        Lit::Localization.where(id: ids).joins(:versions).group("#{Lit::Localization.quoted_table_name}.id").count
      end
      @_versions[localization.id].to_i > 0
    end

    helper_method :has_versions?
  end
end
