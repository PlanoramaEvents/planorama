class SessionNillFields < ActiveRecord::Migration[6.1]
  def up
    # Ensure that none of the fields that should be null have empty strings
    execute "update Sessions set title = null where title = ''"
    execute "update Sessions set description = null where description = ''"
    execute "update Sessions set item_notes = null where item_notes = ''"
    execute "update Sessions set tech_notes = null where tech_notes = ''"
    execute "update Sessions set participant_notes = null where participant_notes = ''"
    execute "update Sessions set instructions_for_interest = null where instructions_for_interest = ''"
    execute "update Sessions set room_notes = null where room_notes = ''"
  end
end
