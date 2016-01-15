class Spree::Chimpy::Subscriber < ActiveRecord::Base
  self.table_name = "spree_chimpy_subscribers"

  attr_accessible :email, :nome, :subscribed, :utm_source, :utm_medium, :utm_campaign, :profile, :ubdate
  validates :email, presence: true
end
