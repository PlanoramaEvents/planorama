class CreateIntegrations < ActiveRecord::Migration[6.1]
  def change
    create_table :integrations, id: :uuid do |t|
      t.string :name
      t.jsonb :config, null: false, default: {}

      t.timestamps
    end

    # fields to hold the integration information for each session/person/session_assignment/room
    add_column :sessions, :integrations, :jsonb, null: false, default: {}
    add_column :people, :integrations, :jsonb, null: false, default: {}
    add_column :session_assignments, :integrations, :jsonb, null: false, default: {}
    add_column :rooms, :integrations, :jsonb, null: false, default: {}
  end
end
