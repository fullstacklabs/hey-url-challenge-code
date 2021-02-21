# frozen_string_literal: true

class CreateUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :urls do |t|
      t.timestamps
      t.string :short_url
      t.string :original_url
      t.integer :clicks_count, default: 0
    end
  end
end
