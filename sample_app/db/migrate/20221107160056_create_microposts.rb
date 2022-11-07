class CreateMicroposts < ActiveRecord::Migration[7.0]
  def change
    create_table :microposts do |t|
      t.text :content
      # automatically adds a user_id column
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    # creates a multiple key index on the user_id and created_at columns (expect to retrieve all microposts associated with user in reverse order of creation)
    add_index :microposts, [:user_id, :created_at]
  end
end
