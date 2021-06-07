class FixPeopleGeneratedCols < ActiveRecord::Migration[6.0]
  def up
    execute %q(ALTER TABLE people DROP column IF EXISTS published_name )
    execute %q(
      ALTER TABLE people ADD published_name varchar(400)
      GENERATED ALWAYS AS
      (
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
        END
      )
      STORED
    )
  end

  def down
    execute %q(ALTER TABLE people DROP column IF EXISTS published_name )
  end
end
