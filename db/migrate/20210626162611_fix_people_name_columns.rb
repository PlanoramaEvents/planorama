class FixPeopleNameColumns < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE people DROP COLUMN IF EXISTS published_last_name;
          ALTER TABLE people DROP COLUMN IF EXISTS published_name;
        SQL
      end
      dir.down do
        execute <<-SQL
          ALTER TABLE people 
          ADD COLUMN published_last_name character varying(400) GENERATED ALWAYS AS (
          CASE
              WHEN (pseudonym_last_name IS NOT NULL) THEN pseudonym_last_name
              ELSE last_name
          END) STORED;
          ALTER TABLE people
          ADD COLUMN published_name character varying(400) GENERATED ALWAYS AS (
          CASE
              WHEN ((pseudonym_last_name IS NOT NULL) OR (pseudonym_first_name IS NOT NULL)) THEN
              CASE
                  WHEN (pseudonym_first_name IS NULL) THEN (pseudonym_last_name)::text
                  WHEN (pseudonym_last_name IS NULL) THEN (pseudonym_first_name)::text
                  ELSE (((pseudonym_first_name)::text || ' '::text) || (pseudonym_last_name)::text)
              END
              ELSE
              CASE
                  WHEN ((first_name IS NULL) AND (last_name IS NOT NULL)) THEN (last_name)::text
                  WHEN ((last_name IS NULL) AND (first_name IS NOT NULL)) THEN (first_name)::text
                  ELSE (((first_name)::text || ' '::text) || (last_name)::text)
              END
          END) STORED;
        SQL
      end
    end

    remove_column :people, :first_name, :string
    remove_column :people, :last_name, :string
    remove_column :people, :suffix, :string
    remove_column :people, :prefix, :string
    remove_column :people, :pseudonym_first_name, :string
    remove_column :people, :pseudonym_last_name, :string
    remove_column :people, :pseudonym_suffix, :string
    remove_column :people, :pseudonym_prefix, :string

    add_column :people, :name, :string, index: true, default: ''
    add_column :people, :pseudonym, :string, index: true
    add_column :people, :sort_by, :string, index: true
    add_column :people, :sort_by_confirmed, :boolean, default: false

  end
end
