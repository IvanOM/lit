module Lit
  class GengoTranslationJob
    def self.retrieve_and_process_jobs(timestamp)
      job_ids = get_job_ids(timestamp)
      jobs = get_jobs(job_ids)
      for job in jobs
        insert_job(job)
      end
    end

    def self.get_job_ids timestamp
      response = $gengo.getTranslationJobs({status:"approved", count: 200,timestamp_after:timestamp})
      if response and response["opstat"] == "ok"
        job_ids = response["response"].map{|job| job["job_id"]}
        return job_ids
      else
        return []
      end
    end

    def self.get_jobs job_ids
      jobs = $gengo.getTranslationJobs({ids: job_ids})
      if jobs and jobs["opstat"] == "ok" and jobs["response"] and jobs["response"]["jobs"]
        return jobs["response"]["jobs"]
      else
        return []
      end
    end

    def self.insert_job(job)
      locale = Lit::Locale.find_by_locale(job["lc_tgt"])
      locale.create_localization_from_gengo(job) if locale
    end
  end
end

