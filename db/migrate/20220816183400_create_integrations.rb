class CreateIntegrations < ActiveRecord::Migration[6.1]
  def change
    create_table :integrations, id: :uuid do |t|
      t.string :name
      t.jsonb :config, null: false, default: {}

      t.timestamps
    end

    create_table :integration_publishes, id: :uuid do |t|
      t.string :integration_name
      t.jsonb :data, null: false, default: {}
      t.datetime :started_at
      t.datetime :completed_at
      t.string :created_by

      t.timestamps
    end

    # fields to hold the integration information for each session/person/session_assignment/room
    add_column :published_sessions, :integrations, :jsonb, null: false, default: {}
    add_column :people, :integrations, :jsonb, null: false, default: {}
    # todo maybe i don't need this one if the tokens are always the same
    add_column :published_session_assignments, :integrations, :jsonb, null: false, default: {}
    add_column :rooms, :integrations, :jsonb, null: false, default: {}
  end
end
