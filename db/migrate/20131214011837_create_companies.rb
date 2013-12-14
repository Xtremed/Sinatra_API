class CreateCompanies < ActiveRecord::Migration
  def up
  	  create_table :companies do |t|
      t.string :name
      t.text :address
      t.string :city
      t.string :country
      t.string :owners
      t.string :email
      t.string :phone  

      t.timestamps
  end
end

  def down
  	drop_table :companies
  end
end
