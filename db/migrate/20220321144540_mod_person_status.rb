class ModPersonStatus < ActiveRecord::Migration[6.1]
  def change
    reversible do |change|
      change.down do
        remove_column :people, :con_state

        execute <<-SQL
          DROP TYPE person_status_enum;
        SQL
      end
      change.up do
        execute <<-SQL
          CREATE TYPE person_status_enum AS ENUM ('not_set', 'applied', 'vetted', 'invite_pending', 'invited', 'probable', 'accepted', 'declined', 'rejected');
        SQL

        add_column :people, :con_state, :person_status_enum, default: 'not_set'
      end
    end

    remove_column :people, :invite_status, :invite_status_enum
    remove_column :people, :acceptance_status, :acceptance_status_enum

    remove_column :mailings, :transiton_invite_status, :invite_status_enum
    add_column :mailings, :transiton_person_status, :person_status_enum

    remove_column :surveys, :transition_accept_status, :acceptance_status_enum
    add_column :surveys, :transition_accept_status, :person_status_enum
    remove_column :surveys, :transition_decline_status, :acceptance_status_enum
    add_column :surveys, :transition_decline_status, :person_status_enum
  end
end
