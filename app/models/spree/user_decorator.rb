if Spree.user_class
  Spree.user_class.class_eval do
    attr_accessible :subscribed

    # after_create  :subscribe2
    around_update :resubscribe
    # after_destroy :unsubscribe
    after_initialize :assign_subscription_default

    delegate :subscribe, :resubscribe, :unsubscribe, to: :subscription

  def subscribe2(user_type)
    subscriber = Spree::Chimpy::Subscriber.where(email:self.email).first_or_create
    subscriber.nome ||= self.firstname
    subscriber.profile ||= user_type
    subscriber.utm_source ||= self.utm_source
    subscriber.utm_medium ||= self.utm_medium
    subscriber.utm_campaign ||= self.utm_campaign
    if subscriber.save
      Spree::Chimpy::Subscription.new(subscriber).subscribe
    end
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
