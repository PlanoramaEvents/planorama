class AddJtiColumns < ActiveRecord::Migration[6.0]
  def change
    # add_column :people, :jti, :string, null: false
    # add_index :people, :jti, unique: true
    add_column :people, :jti, :string
    Person.all.each { |user| user.update_column(:jti, SecureRandom.uuid) }
    change_column_null :people, :jti, false
    add_index :people, :jti, unique: true
  end
end
