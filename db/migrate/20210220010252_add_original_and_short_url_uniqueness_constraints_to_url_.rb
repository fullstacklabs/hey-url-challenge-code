class AddOriginalAndShortUrlUniquenessConstraintsToUrl < ActiveRecord::Migration[5.2]
  def change
    add_index :urls, :original_url, unique: true
    add_index :urls, :short_url, unique: true
  end
end
