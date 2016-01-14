if Spree.user_class
  Spree.user_class.class_eval do
    attr_accessible :subscribed

    after_create  :ensure_subscription
    around_update :resubscribe
    # after_destroy :unsubscribe
    after_initialize :assign_subscription_default

    delegate :subscribe, :resubscribe, :unsubscribe, to: :subscription

  def ensure_subscription
    subscriber = Spree::Chimpy::Subscriber.where(email: self.email).first
    Spree::Chimpy::Subscription.new(subscriber).subscribe if subscriber
  end

  private
    def subscription
      Spree::Chimpy::Subscription.new(self)
    end

    def assign_subscription_default
      self.subscribed = Spree::Chimpy::Config.subscribed_by_default if new_record? && self.subscribed.nil?
    end
  end
end
