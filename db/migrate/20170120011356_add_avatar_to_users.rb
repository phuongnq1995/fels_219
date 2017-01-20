class AddAvatarToUsers < ActiveRecord::Migration
  def change
    add_column :users, :avatar, :string,
     default:"http://wpidiots.com/html/ravan/standard/img/avatar3.png"
  end
end
