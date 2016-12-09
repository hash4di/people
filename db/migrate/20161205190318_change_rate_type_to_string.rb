class ChangeRateTypeToString < ActiveRecord::Migration
  def change
    change_column :skills, :rate_type, :string
  end
end
