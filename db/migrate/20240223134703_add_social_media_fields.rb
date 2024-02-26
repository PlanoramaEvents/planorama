class AddSocialMediaFields < ActiveRecord::Migration[6.1]
  def change
    add_column :people, :fediverse, :string, default: nil
    add_column :people, :bsky, :string, default: nil
  end
end
