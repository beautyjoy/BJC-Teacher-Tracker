# frozen_string_literal: true

class EnablePgTrgm < ActiveRecord::Migration[6.1]
  def change
    enable_extension "pg_trgm"
  end
end
