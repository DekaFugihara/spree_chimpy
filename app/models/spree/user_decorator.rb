if Spree.user_class
  Spree.user_class.class_eval do
    attr_accessible :subscribed

    after_create  :subscribe
    around_update :resubscribe
    after_destroy :unsubscribe2
    after_initialize :assign_subscription_default

    delegate :subscribe, :resubscribe, :unsubscribe, to: :subscription

  # def subscribe2(user_type)
  #   subscriber = Spree::Chimpy::Subscriber.where(email:self.email).first_or_create
  #   subscriber.nome ||= self.firstname
  #   subscriber.profile ||= user_type

  #   retrieve_utm_cookies

  #   subscriber.utm_source ||= self.utm_source
  #   subscriber.utm_medium ||= self.utm_medium
  #   subscriber.utm_campaign ||= self.utm_campaign
  #   subscriber.utm_term ||= self.utm_term
  #   if subscriber.save
  #     Spree::Chimpy::Subscription.new(subscriber).subscribe
  #   end
  # end

  # def resubscribe2(user_type)
  #   subscriber = Spree::Chimpy::Subscriber.where(email:self.email).first_or_create
  #   if subscriber
  #     subscriber.nome = self.firstname
  #     subscriber.profile = user_type
  #     subscriber.ubdate ||= Date.today

  #     retrieve_utm_cookies
  #     subscriber.utm_source ||= self.utm_source
  #     subscriber.utm_medium ||= self.utm_medium
  #     subscriber.utm_campaign ||= self.utm_campaign
  #     subscriber.utm_term ||= self.utm_term

  #     if subscriber.save
  #       Spree::Chimpy::Subscription.new(subscriber).subscribe
  #     end
  #   end
  # end

  def unsubscribe2
    if Spree::Chimpy::Subscriber.where(email:self.email).first
      self.unsubscribe
    end
  end

  private
    def subscription
      Spree::Chimpy::Subscription.new(self)
    end

    def assign_subscription_default
      self.subscribed = Spree::Chimpy::Config.subscribed_by_default if new_record? && self.subscribed.nil?
    end

    # def retrieve_utm_cookies
    #   cookies.permanent[:utm_source] = cookies[:original_utm_source] if cookies[:original_utm_source]
    #   cookies.permanent[:utm_campaign] = cookies[:original_utm_campaign] if cookies[:original_utm_campaign]
    #   cookies.permanent[:utm_medium] = cookies[:original_utm_medium] if cookies[:original_utm_medium]
    #   cookies.permanent[:utm_term] = cookies[:original_utm_term] if cookies[:original_utm_term]
    # end
  end
end
