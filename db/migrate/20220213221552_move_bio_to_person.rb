class MoveBioToPerson < ActiveRecord::Migration[6.1]
  # We want to move the bio fields into the people table
  def change
    # Create the columns for the data
    add_column :people, :bio, :text, default: nil
    add_column :people, :website, :string, default: nil
    add_column :people, :twitter, :string, default: nil
    add_column :people, :othersocialmedia, :string, default: nil
    add_column :people, :facebook, :string, default: nil
    add_column :people, :linkedin, :string, default: nil
    add_column :people, :twitch, :string, default: nil
    add_column :people, :youtube, :string, default: nil
    add_column :people, :instagram , :string, default: nil
    add_column :people, :flickr, :string, default: nil
    add_column :people, :reddit, :string, default: nil
    add_column :people, :tiktok, :string, default: nil

    # Migrate the data from the old bios table
    # leave bio table for now
    up_only do
      execute %q(
        UPDATE people
          SET bio=subquery.bio,
              website=subquery.website,
              twitter=subquery.twitter,
              othersocialmedia=subquery.othersocialmedia,
              facebook=subquery.facebook,
              linkedin=subquery.linkedin,
              twitch=subquery.twitch,
              youtube=subquery.youtube,
              instagram=subquery.instagram,
              flickr=subquery.flickr,
              reddit=subquery.reddit,
              tiktok=subquery.tiktok
          FROM (
            SELECT
              person_id,
              bio,
              website,
              twitter,
              othersocialmedia,
              facebook,
              linkedin,
              twitch,
              youtube,
              instagram,
              flickr,
              reddit,
              tiktok
            FROM  bios
          ) AS subquery
          WHERE people.id=subquery.person_id;
      )
    end
  end
end
