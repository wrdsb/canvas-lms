class AddNotifiedAtToContextModuleProgressions < ActiveRecord::Migration

  def self.up
    add_column :notified_at, :context_module_progressions, :datetime
  end

  def self.down
    remove_column :notified_at, :context_module_progressions
  end
end
