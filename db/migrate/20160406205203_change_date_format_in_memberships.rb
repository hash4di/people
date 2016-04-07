class ChangeDateFormatInMemberships < ActiveRecord::Migration
  def change
    change_column :memberships, :starts_at, :datetime
    change_column :memberships, :ends_at, :datetime
  end
end
