class TweakSessions < ActiveRecord::Migration[6.0]
  def change
    remove_column :sessions, :mobile_card_size

    add_column :sessions, :require_signup, :boolean, default: false
    add_column :sessions, :waiting_list_size, :integer, default: 0

    add_column :published_sessions, :require_signup, :boolean, default: false
    add_column :published_sessions, :waiting_list_size, :integer, default: 0

    # Attributes for expression of interest
    add_column :sessions, :open_for_interest, :integer, default: 0

    add_column :session_assignments, :interested, :boolean, default: false
    add_column :session_assignments, :interest_ranking, :integer, default: nil
    add_column :session_assignments, :interest_notes, :text, default: nil
    add_column :session_assignments, :interest_role_type, :uuid, null: true, default: nil

    # state will be used for the workflow ...
    add_column :session_assignments, :state, :string, default: nil
    add_column :session_assignments, :planner_notes, :text, default: nil
  end
end
