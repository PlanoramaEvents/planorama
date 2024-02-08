class RedoPeopleIndexes < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  # GIN indexes are a lot faster for text search etc
  # a bit slower to create, but search with ilike etc is orders
  # of magnitude faster
  def change
    if ActiveRecord::Migration.connection.index_exists? :people, [:name]
      remove_index :people, :name
    end
    if ActiveRecord::Migration.connection.index_exists? :people, [:pseudonym]
      remove_index :people, :pseudonym
    end
    if ActiveRecord::Migration.connection.index_exists? :people, [:published_name]
      remove_index :people, :published_name
    end
    if ActiveRecord::Migration.connection.index_exists? :people, [:bio]
      remove_index :people, :bio
    end
    if ActiveRecord::Migration.connection.index_exists? :email_addresses, [:email]
      remove_index :email_addresses, :email
    end
    if ActiveRecord::Migration.connection.index_exists? :registration_sync_data, [:email]
      remove_index :registration_sync_data, :email
    end
    if ActiveRecord::Migration.connection.index_exists? :registration_sync_data, [:name]
      remove_index :registration_sync_data, :name
    end
    if ActiveRecord::Migration.connection.index_exists? :sessions, [:title]
      remove_index :sessions, :title
    end
    if ActiveRecord::Migration.connection.index_exists? :sessions, [:description]
      remove_index :sessions, :description
    end

    add_index :people, :name, using: :gin, opclass: :gin_trgm_ops
    add_index :people, :pseudonym, using: :gin, opclass: :gin_trgm_ops
    add_index :people, :published_name, using: :gin, opclass: :gin_trgm_ops
    add_index :people, :bio, using: :gin, opclass: :gin_trgm_ops
    add_index :email_addresses, :email, using: :gin, opclass: :gin_trgm_ops

    add_index :registration_sync_data, :email, using: :gin, opclass: :gin_trgm_ops
    add_index :registration_sync_data, :name, using: :gin, opclass: :gin_trgm_ops

    add_index :sessions, :title, using: :gin, opclass: :gin_trgm_ops
    add_index :sessions, :description, using: :gin, opclass: :gin_trgm_ops
    add_index :sessions, :item_notes, using: :gin, opclass: :gin_trgm_ops
    add_index :sessions, :participant_notes, using: :gin, opclass: :gin_trgm_ops
    add_index :sessions, :instructions_for_interest, using: :gin, opclass: :gin_trgm_ops
    add_index :sessions, :updated_by, using: :gin, opclass: :gin_trgm_ops
    add_index :sessions, :interest_opened_by, using: :gin, opclass: :gin_trgm_ops
    add_index :sessions, :tech_notes, using: :gin, opclass: :gin_trgm_ops
    add_index :sessions, :room_notes, using: :gin, opclass: :gin_trgm_ops
  end
end
