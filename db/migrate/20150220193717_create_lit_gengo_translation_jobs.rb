class CreateLitGengoTranslationJobs < ActiveRecord::Migration
  def change
    create_table :lit_gengo_translation_jobs do |t|
      t.integer :job_id
      t.text :data

      t.timestamps
    end
  end
end
