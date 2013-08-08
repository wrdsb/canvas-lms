class AddNotifiedAtToContextModuleProgressions < ActiveRecord::Migration
  tag :predeploy

  def self.up
    add_column :context_module_progressions, :notified_at, :datetime
  end

  def self.down
    remove_column :context_module_progressions, :notified_at
  end
end
