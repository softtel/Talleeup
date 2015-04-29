class [scope]::SessionsController < Devise::SessionsController
# before_filter :configure_sign_in_params, only: [:create]
  respond_to :json

  def create
    params[:user][:password_confirmation] = params[:user][:password]
    super
  end

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # You can put the params you want to permit in the empty array.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end
end







# class Users:: SessionsController < Devise::SessionsController
#   def create
#     respond_to do |format|
#       format.html { super }
#       format.json {
#         warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
#         render :json => {:success => true}
#       }
#     end
#   end
#
#   def destroy
#     respond_to do |format|
#       format.html {super}
#       format.json {
#         Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
#         render :json => {}
#       }
#     end
#   end

# end