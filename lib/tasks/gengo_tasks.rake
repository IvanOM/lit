namespace :gengo do
  desc 'Retrieves translated strings from gengo and updates the database.'
  task retrieve: :environment do
    response = $gengo.getTranslationJobs({status:"approved", count: 200,timestamp_after:ENV['TIMESTAMP_AFTER']||(Time.now.to_i+1.year.to_i)})
    if response and response["opstat"] == "ok"
      exit if response["response"].empty?
      job_ids = response["response"].map{|job| job["job_id"]}
      jobs = $gengo.getTranslationJobs({ids: job_ids})
      if jobs and jobs["opstat"] == "ok"
        if jobs["response"] and jobs["response"]["jobs"]
          for job in jobs["response"]["jobs"]
            localization_key = Lit::LocalizationKey.find_by_localization_key(job["slug"])
            locale = Lit::Locale.find_by_locale(job["lc_tgt"])
            if localization_key and locale
              localization = Lit::Localization.find_by_locale_and_localization_key(locale,localization_key)
              localization.update_attributes translated_value: job["body_tgt"]
            end
          end
        end
      end
    end
  end
end

