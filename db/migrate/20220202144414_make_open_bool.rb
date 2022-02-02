class MakeOpenBool < ActiveRecord::Migration[6.0]
  def up
    execute %q(
      ALTER TABLE sessions ALTER COLUMN open_for_interest DROP DEFAULT;
      ALTER TABLE sessions ALTER open_for_interest TYPE boolean USING CASE WHEN open_for_interest=0 THEN FALSE ELSE TRUE END;
      ALTER TABLE sessions ALTER COLUMN open_for_interest SET DEFAULT FALSE;
    )
  end
end
