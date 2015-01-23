namespace :gengo do
  desc 'Retrieves translated strings from gengo and updates the database.'
  task retrieve: :environment do
    Lit::GengoTranslationJob.retrieve_and_process_jobs(ENV['TIMESTAMP_AFTER']||(Time.now.to_i-1.year.to_i))
  end
end

