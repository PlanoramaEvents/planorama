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
    add_column :people, :name_sort_by, :string, index: true
    add_column :people, :name_sort_by_confirmed, :boolean, default: false
    add_column :people, :pseudonym, :string, index: true
    add_column :people, :pseudonym_sort_by, :string, index: true
    add_column :people, :pseudonym_sort_by_confirmed, :boolean, default: false

    reversible do |dir|
      dir.up do
        execute <<-SQL
          ALTER TABLE people
          ADD COLUMN published_name character varying GENERATED ALWAYS AS (
          CASE
            WHEN (pseudonym IS NOT NULL) THEN pseudonym
            ELSE name
          END) STORED;
          ALTER TABLE people
          ADD COLUMN published_name_sort_by character varying GENERATED ALWAYS AS (
          CASE
            WHEN (pseudonym_sort_by IS NOT NULL) THEN pseudonym_sort_by
            ELSE name_sort_by
          END) STORED;
        SQL
      end
      dir.down do
        execute <<-SQL
          ALTER TABLE people DROP COLUMN IF EXISTS published_name;
          ALTER TABLE people DROP COLUMN IF EXISTS published_name_sort_by;
        SQL
      end
    end

  end
end
