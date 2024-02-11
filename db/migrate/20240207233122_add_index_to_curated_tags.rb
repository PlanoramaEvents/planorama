class AddIndexToCuratedTags < ActiveRecord::Migration[6.1]
  def change
    add_index :curated_tags, [:name, :context], unique: true, name: "idx_tagname_on_context"
  end
end
