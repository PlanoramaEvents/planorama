class FixSurveyAndAddSocial < ActiveRecord::Migration[6.0]
  def change
    add_column :bios, :tiktok, :string, default: nil

    rename_column :bios, :twitterinfo, :twitter
    rename_column :survey_questions, :radndomize, :randomize
  end
end
