class User < ActiveRecord::Base
  belongs_to :group
  trigger.after(:insert).where("NEW.name = 'bob'") do
    "UPDATE groups SET bob_count = bob_count + 1"
  end
end