class AddPeopleGeneratedCols < ActiveRecord::Migration[6.0]
  def up
    execute %q(
      ALTER TABLE people ADD published_name varchar(400)
      GENERATED ALWAYS AS
      (
        CASE WHEN pseudonym_last_name IS NOT NULL OR pseudonym_first_name IS NOT NULL
             THEN
               CASE WHEN pseudonym_first_name IS NULL THEN pseudonym_first_name
                    WHEN pseudonym_last_name  IS NULL THEN pseudonym_last_name
                    ELSE pseudonym_first_name || ' ' || pseudonym_last_name
               END
             ELSE
               CASE WHEN first_name IS NULL THEN last_name
                    WHEN last_name  IS NULL THEN first_name
                    ELSE first_name || ' ' || last_name
               END
        END
      )
      STORED
    )

    execute %q(
      ALTER TABLE people ADD published_last_name varchar(400)
      GENERATED ALWAYS AS
      (
        CASE WHEN pseudonym_last_name IS NOT NULL then pseudonym_last_name
             ELSE last_name
        END
      )
      STORED
    )
  end

  def down
    execute %q(ALTER TABLE people DROP column IF EXISTS published_name )
    execute %q(ALTER TABLE people DROP column IF EXISTS published_last_name )
  end
end
