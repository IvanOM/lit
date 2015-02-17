namespace :lit do
  desc 'Exports translated strings from lit to config/locales/lit.yml file.'
  task export: :environment do
    if yml = Lit.init.cache.export
      PATH = 'config/locales/lit.yml'
      File.new("#{Rails.root}/#{PATH}", 'w').write(yml)
      puts "Successfully exported #{PATH}."
    end
  end

  desc 'Insert all locales to the database.'
  task load: :environment do
    logger = Logger.new(STDOUT)
    logger.info "Loading all existing locales, keys and translations..."
    I18n.backend.send(:load_translations)
    logger.info "Inserting all missing translations in the database..."
    for locale in Lit::Locale.all
      logger.info locale.locale
      for key in Lit::LocalizationKey.all
        I18n.translate(locale.locale,key.localization_key)
      end
    end
  end
end
