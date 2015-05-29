class CustomFailure < Devise::FailureApp
  def redirect_url
    '/index'
  end

  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end

  def failure
    respond_to do |format|
      format.html {super}
      format.json do
        warden.custom_failure!
        render :json => {:success => false, :errors => ["Login Failed"]}
      end
    end
  end

end