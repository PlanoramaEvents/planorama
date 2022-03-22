class FieldsForPeople < ActiveRecord::Migration[6.1]
  def change
    reversible do |change|
      change.up do
        execute <<-SQL
          CREATE TYPE yesnomaybe_enum AS ENUM ('yes', 'no', 'maybe');
        SQL

        remove_column :people, :can_record if column_exists?(:people, :can_record)
        remove_column :people, :can_photo if column_exists?(:people, :can_photo)

        add_column :people, :can_stream, :yesnomaybe_enum, default: 'no'
        add_column :people, :can_record, :yesnomaybe_enum, default: 'no'
        add_column :people, :can_photo, :yesnomaybe_enum, default: 'no'
      end
      change.down do
        remove_column :people, :can_record
        remove_column :people, :can_photo
        remove_column :people, :can_stream

        execute <<-SQL
          DROP TYPE yesnomaybe_enum;
        SQL
      end
    end

    add_column :people, :age_at_convention, :string, default: nil
    add_column :people, :romantic_sexual_orientation, :string, default: nil
    add_column :people, :awards, :string, limit: 10000, default: nil
    add_column :people, :needs_accommodations, :boolean, default: false
    add_column :people, :accommodations, :string, limit: 10000, default: nil
    add_column :people, :willing_to_moderate, :boolean, default: false
    add_column :people, :moderation_experience, :string, :limit => 10000, default: nil
    add_column :people, :othered, :string, limit: 10000, default: nil
    add_column :people, :indigenous, :string, limit: 10000, default: nil
    add_column :people, :black_diaspora, :string, :limit => 10000, default: nil
    add_column :people, :non_us_centric_perspectives, :string, :limit => 10000, default: nil
    add_column :people, :demographic_categories, :string, default: nil
    add_column :people, :do_not_assign_with, :string, limit: 10000, default: nil
    add_column :people, :can_stream_exceptions, :string, limit: 10000, default: nil
    add_column :people, :can_record_exceptions, :string, :limit => 10000, default: nil
    add_column :people, :can_photo_exceptions, :string, limit: 10000, default: nil
    add_column :people, :is_local, :boolean, default: false
    add_column :people, :langauges_fluent_in, :string, limit: 10000, default: nil
  end
end
