class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name, null: false, collation: "NOCASE"
      t.string :password_digest, null: false

      t.check_constraint "length(name) > 0", name: "name_length_check"

      t.timestamps
    end

    add_index :users, :name, unique: true
  end
end
