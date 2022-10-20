# migrate using db:migrate

class CreateUsers < ActiveRecord::Migration[7.0]
  # method that determines the changes to be made to the database
  def change
    # rails method to create a table in the db with columns specified in the block
    create_table :users do |t|
      t.string :name
      t.string :email

      # creates two columns - created_at and updated_at
      t.timestamps
    end
  end
end
