class Spree::Chimpy::Subscriber < ActiveRecord::Base
  self.table_name = "spree_chimpy_subscribers"

  attr_accessible :email, :nome, :subscribed, :utm_source, :utm_medium, :utm_campaign, :utm_term, :profile, :ubdate
  validates :email, presence: true
end
