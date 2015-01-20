module Lit
  class Locale < ActiveRecord::Base
    ## SCOPES
    scope :ordered, proc { order('locale ASC') }
    scope :visible, proc { where(is_hidden: false) }

    ## ASSOCIATIONS
    has_many :localizations, dependent: :destroy

    ## VALIDATIONS
    validates :locale,
              presence: true,
              uniqueness: true

    ## BEFORE & AFTER
    after_save :reset_available_locales_cache
    after_destroy :reset_available_locales_cache

    unless defined?(::ActionController::StrongParameters)
      ## ACCESSIBLE
      attr_accessible :locale
    end

    def to_s
      locale
    end

    def get_translated_percentage
      total = get_all_localizations_count
      total > 0 ? (get_changed_localizations_count * 100 / total) : 0
    end

    def get_changed_localizations_count
      localizations.changed.count(:id)
    end

    def get_all_localizations_count
      localizations.count(:id)
    end

    def gengo_package
      localizations = self.localizations.without_translation
      package = {jobs:{}}
      localizations.each_with_index do |localization,i|
        package[:jobs].merge! "job_#{i}".to_sym => {type:"text",
          slug: localization.localization_key.localization_key,
          body_src: localization.default_value,
          lc_src:"en",
          lc_tgt: locale.downcase,
          tier: "standard"
        }
      end
      package
    end

    def send_to_gengo
      $gengo.postTranslationJobs(gengo_package)
    end

    private

    def reset_available_locales_cache
      return unless I18n.backend.respond_to?(:reset_available_locales_cache)
      I18n.backend.reset_available_locales_cache
    end
  end
end
