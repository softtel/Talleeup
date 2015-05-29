class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  skip_before_filter  :verify_authenticity_token

  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"])

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect (@user), :event => :authentication
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end

  end

  def google_oauth2
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_google_oauth2(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      logger.debug "-------------------sign_in-----------------------".inspect
      logger.debug @user.inspect
      sign_in_and_redirect (@user), :event => :authentication
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      logger.debug "--------------------registration----------------------".inspect
      redirect_to new_user_registration_url
    end
  end

  def twitter
    auth = env["omniauth.auth"]

    @user = User.find_for_twitter_oauth(request.env["omniauth.auth"],current_user)
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Twitter"

      logger.debug "-------------------sign_in-----------------------".inspect
      logger.debug @user.inspect

      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.twitter_uid"] = request.env["omniauth.auth"]

      logger.debug "--------------------registration----------------------".inspect

      redirect_to new_user_registration_url
    end
  end
  def github
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_github_oauth(request.env["omniauth.auth"])

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "github"
      logger.debug "-------------------sign_in-----------------------".inspect
      logger.debug @user.inspect
      sign_in_and_redirect (@user), :event => :authentication
    else
      session["devise.github_data"] = request.env["omniauth.auth"]
      logger.debug "--------------------registration----------------------".inspect
      redirect_to new_user_registration_url
    end
    #p env["omniauth.auth"]

   # user = User.from_omniauth(env["omniauth.auth"], current_user)
    #if user.persisted?
     # flash[:notice] = "You are in..!!! Go to edit profile to see the status for the accounts"
     # sign_in_and_redirect(user)
   # else
    #  session["devise.user_attributes"] = user.attributes
     # redirect_to new_user_registration_url
   # end
  end

  # def sign_in
  #   super
  #   @okok="okmen"
  # end

end