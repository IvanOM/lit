require 'test_helper'

module Gengo
  class GengoTranslationJobTest < ActiveSupport::TestCase
    fixtures 'lit/localization_keys'
    fixtures 'lit/locales'

    test "should run the rake task" do
      Lit::GengoTranslationJob.retrieve_and_process_jobs(Time.now.to_i)
    end
  end
end
