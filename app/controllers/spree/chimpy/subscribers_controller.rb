class Spree::Chimpy::SubscribersController < Spree::BaseController
  # respond_to :html
  layout "spree/layouts/blank"

  def create
    @errors = []
    if params[:chimpy_subscriber][:email].blank?
      @errors << I18n.t("spree.chimpy.subscriber.missing_email")
    elsif params[:chimpy_subscriber][:email] !~ /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/i
      @errors << I18n.t("spree.chimpy.subscriber.missing_email")
    else
      @subscriber = Spree::Chimpy::Subscriber.where(email: params[:chimpy_subscriber][:email]).first
      if @subscriber
        @errors << I18n.t("spree.chimpy.subscriber.already")
      else
        @subscriber = Spree::Chimpy::Subscriber.where(email: params[:chimpy_subscriber][:email]).first_or_initialize
        @subscriber.update_attributes(params[:chimpy_subscriber])
        @subscriber.profile = params[:user_type]
        
        retrieve_utm_cookies

        @subscriber.utm_source ||= cookies[:utm_source]
        @subscriber.utm_campaign ||= cookies[:utm_campaign]
        @subscriber.utm_medium ||= cookies[:utm_medium]
        @subscriber.utm_term ||= cookies[:utm_term]
        if @subscriber.save
          Spree::Chimpy::Subscription.new(@subscriber).subscribe
          # user = Spree::User.where(email:params[:chimpy_subscriber][:email]).first
          # if user
          #   user.subscribed = true
          #   user.save
          # end
          flash[:newsletter_subscription_tracking] = "nothing special"
          # flash[:notice] = I18n.t("spree.chimpy.subscriber.success")
          if params[:show_success_lightbox] == "false"
            @show_success_lightbox = false
            session[:return_user_to] = "/compre?from=landing_cadastro"
          else
            @show_success_lightbox = true
          end
        else
          @errors << I18n.t("spree.chimpy.subscriber.failure")
        end
      end
    end

    respond_to do |format|
      format.js
      format.html
    end
    # respond_with @subscriber, location: request.referer
  end

  def success
    flash[:newsletter_subscription_tracking] = "nothing special"
    render "create"
  end

  private

  def retrieve_utm_cookies
    cookies.permanent[:utm_source] = cookies[:original_utm_source] if cookies[:original_utm_source]
    cookies.permanent[:utm_campaign] = cookies[:original_utm_campaign] if cookies[:original_utm_campaign]
    cookies.permanent[:utm_medium] = cookies[:original_utm_medium] if cookies[:original_utm_medium]
    cookies.permanent[:utm_term] = cookies[:original_utm_term] if cookies[:original_utm_term]
  end
end
