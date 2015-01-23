class AddIgnoreToLitLocalizationKey < ActiveRecord::Migration
  def change
    add_column :lit_localization_keys, :ignore, :boolean, default: false
  end
end
