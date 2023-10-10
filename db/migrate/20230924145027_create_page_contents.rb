class CreatePageContents < ActiveRecord::Migration[6.1]
  def change
    create_table :page_contents, id: :uuid do |t|
      t.text :html, null: false
      t.string :name, null: false, index: { unique: true, name: 'unique_page_content' }

      t.integer :lock_version
      t.timestamps
    end
  end
end
