class AddMinorsParticipation < ActiveRecord::Migration[6.1]
  def change
    add_column :sessions, :minors_participation, :jsonb
  end
end
