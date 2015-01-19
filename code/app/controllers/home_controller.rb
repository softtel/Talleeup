require 'product_view_models'

class HomeController < ApplicationController
   #before_action :authenticate_user!
   before_action :authenticate_user!, :except => [:index, :test,:addSession,:BurgerProfile,:CheckEmail]

  def index

    # @cityDetected = request.location.city
    _ip=request.remote_ip
    @getLocation=Location.where(ip: _ip).order("id DESC")

    if !@getLocation.blank? && !request.post?
      _detectcountry=Country.where("lower(name)=?", @getLocation.first().country.downcase)
      _dectechcity=City.where("lower(name)=?",@getLocation.first().city.downcase)
      if !_detectcountry.blank?
        _detectcountryid=_detectcountry.first().id
        @cities=City.where(country_id: _detectcountryid)
        if !_dectechcity.blank?
          city_id=_dectechcity.first().id
        else
          city_id=@cities.first().id
        end

      else
        country=Country.all.order("name ASC")
        countryid=country.first().id
        @cities=City.where(country_id:countryid)
        city_id=@cities.first().id
      end
    else if @getLocation.blank? && request.post?
           city_id=params[:city_id]
           countryid=City.where(id: city_id).first().country_id
           @cities=City.where(country_id:countryid)

         else if !@getLocation.blank? && request.post?
                city_id=params[:city_id]
                countryid=City.where(id: city_id).first().country_id
                @cities=City.where(country_id:countryid)
              else

                country=Country.all.order("name ASC")
                countryid=country.first().id
                @cities=City.where(country_id:countryid)
                city_id=@cities.first().id
              end

         end

    end
    @current_city = City.find_by_id(city_id)

    # country = request.location.country_code
    if user_signed_in?
      @products = Product.get_products(city_id, 99999999)
    else
      @products = Product.get_products(city_id, 5)
    end


    render layout: "home_layout"
  end

  def follow

    Follow.add(current_user.id, params[:friend_id])
    render :json => { :status => true }
  end

   def unfollow

     Follow.delete(current_user.id, params[:friend_id])
     render :json => { :status => true }
   end


  def search

    # @cityDetected = request.location.city
    _ip=request.remote_ip
    @getLocation=Location.where(ip: _ip).order("id DESC")
    if !@getLocation.blank?
      _detectcountry=Country.where("lower(name)=?", @getLocation.first().country.downcase)
      _dectechcity=City.where("lower(name)=?",@getLocation.first().city.downcase)
      if !_detectcountry.blank?
        _detectcountryid=_detectcountry.first().id
        @cities=City.where(country_id: _detectcountryid)
        if !_dectechcity.blank?
          city_id=_dectechcity.first().id
        else
          city_id=@cities.first().id
        end
      end
    else
      country=Country.all.order("name ASC")
      countryid=country.first().id
      @cities=City.where(country_id:countryid)
      city_id=@cities.first().id
    end

    @keyword = params[:keyword]
    @products = Product.search(@keyword,city_id)

    @myprofile = Profile.getProfile(current_user.id)

    render layout: "search_layout"
  end



  def userprofile

    ### friend
    @friend = User.find_by_id(params[:id])

    @isMyprofile = (@friend.id == current_user.id) ? true : false

    if @friend.nil?
      @friend = User.find_by_id(1)
    end

    # profile
    @profile = Profile.getProfile(params[:id])
    @meta = Meta.get_meta

    # product reviewed
    limit = (params[:fulllist].nil?) ? 5 : 1000
    @products = @friend.get_products_reviewed(limit)
    @is_full_list = (params[:fulllist].nil?) ? false : true

    ### user
    @user = User.where(id: params[:id]).first()
    @myprofile = Profile.getProfile(current_user.id)
    @isFollowed = @user.isFollowed(@friend.id)

    # layout
    render layout: "userprofile_layout"
  end

   def news
     ### friend
     @friend = current_user

     @isMyprofile = false

     # profile
     @profile = current_user.profile

     # reviews
     limit = (params[:fulllist].nil?) ? 5 : 1000
     @reviews = @friend.get_news(limit)

     ### user
     @user = current_user
     @myprofile = Profile.getProfile(current_user.id)
     @isFollowed = @user.isFollowed(@friend.id)

     # layout
     render layout: "news_layout"
   end

   def upload_avatar
     @profile = Profile.find(params[:profile][:id])
     @profile.update(avatar: params[:profile][:avatar])
     redirect_to :controller => 'home', :action => 'userprofile', :id => current_user.id
   end



  def myprofile

    @user = current_user
    @myprofile = Profile.getProfile(current_user.id)
    @products = Product.all

    render layout: "myprofile_layout"
  end
  def AddComemnt
    if user_signed_in?
      if (!params[:content].blank?)

        if params[:file].present?
          Review.save(params[:file])

        end
        Comment.create(content:  params[:content],images: params[:file],product_id:params[:productid],user_id:current_user.id)
      end
    end
    redirect_to :controller => 'home', :action => 'BurgerProfile', :id => params[:productid]
  end

  def user_meta
    MetaUser.update_profile(params[:id], params[:value])
    render :json => { :data => true }
  end

  def update_profile
    if params[:column_name] == "address"
      profile = current_user.profile
      profile.update_profile(params[:content])
    else
      current_user.update(fullname: params[:content])
    end
    render :json => { :data => true }
  end

  def review_post
    # parsed_json = ActiveSupport::JSON.decode(params[:_json])

    # add review
    review = Review.add(current_user.id, params[:review][:product_id], params[:review][:totalpoint])

    # add review component
    params[:review_components].each do |component|
      ReviewComponent.add(review.id, component[:review_type_id], component[:point])
      # logger.debug component[:review_type_id].inspect
    end

    # add comment
    if (!params[:comment][:content].blank?)

      #name=params[:comment][:filename].original_filename
      #directory = "public/comment"
      # create the file path
      #path = File.join(directory, name)
      # write the file
      #File.open(path, "wb") { |f| f.write(params[:comment][:filename].read) }
      Commentproduct.add(review.id, params[:comment][:content],params[:comment][:namefile])
    end

    render :json => { :data => true }
  end
def uploadImgaes
  name=params[:file].original_filename
  directory = "public/comment"
  # create the file path
  path = File.join(directory, name)
  # write the file
  File.open(path, "wb") { |f| f.write(params[:file].read) }
  render :json => { :data => true }
end
  def review

    @myprofile = Profile.getProfile(current_user.id)
    @restaurant=Restaurant.all()

    @restaurant_product=Product.where(restaurant_id: @restaurant.first().id)
    if params[:product_id].present?
      @product = Product.find_by_id(params[:product_id])
      @isReviewed = @product.check_reviewed(current_user.id)
      @disbale="disabled"
      if(@isReviewed)
        @reviewed = Review.getReviewed(current_user.id,  @product.id)
        @reviewed_components = @reviewed.get_reviewed_components()
      end
    else
      @product = Product.find_by_id(@restaurant_product.first().id)
      @disbale=""
      @isReviewed = @product.check_reviewed(current_user.id)
      if(@isReviewed)
        @reviewed = Review.getReviewed(current_user.id,  @product.id)
        @reviewed_components = @reviewed.get_reviewed_components()
      end
    end

    @review_type = ReviewType.get_all


    render layout: "review_layout"
  end
  def getchangeproduct
    @restaurant_product=Product.where(restaurant_id: params[:idre])
    render :json => { :data => @restaurant_product }
  end
  #hungnt
  #login
  def ArrayStrign(str)
      #data=Array["a","A","e","E","o","O","u","U","i","I","d","D","y","Y","á","à","ạ","ả","ã","â","ấ","ầ","ậ","ẩ","ẫ","ă","ắ","ằ","ặ","ẳ","ẵ"]
     #data=Array["aAeEoOuUiIdDyY","áàạảãâấầậẩẫăắằặẳẵ","ÁÀẠẢÃÂẤẦẬẨẪĂẮẰẶẲẴ","éèẹẻẽêếềệểễ","ÉÈẸẺẼÊẾỀỆỂỄ","óòọỏõôốồộổỗơớờợởỡ","ÓÒỌỎÕÔỐỒỘỔỖƠỚỜỢỞỠ",
           # "úùụủũưứừựửữ","ÚÙỤỦŨƯỨỪỰỬỮ","íìịỉĩ","ÍÌỊỈĨ","đ","Đ","ýỳỵỷỹ","ÝỲỴỶỸ"]
     #for i=1 in array.length
          #for j =0 in array[i].length
            #str=str.gsub(array[i][j],array[0][i - 1])
          #end
     #end
    return str
   end
  def login

      _ip=request.remote_ip
      @componant=Component.all
      @getLocation=Location.where(ip: _ip).order("id DESC")
      # lay location duoc va khong post
      if !@getLocation.blank? && !request.post?
          _detectcountry=Country.where("lower(name)=?", @getLocation.first().country.downcase)
          _dectechcity=City.where("lower(name)=?",@getLocation.first().city.downcase)
          if !_detectcountry.blank?
            _detectcountryid=_detectcountry.first().id
            @location=City.where(country_id: _detectcountryid)
            if !_dectechcity.blank?
              @city_id=_dectechcity.first().id
            else
              @city_id=@location.first().id
            end
          else
            country=Country.all.order("name ASC")
            countryid=country.first().id
            @location=City.where(country_id:countryid)
            @city_id=@location.first().id
          end
          @data=Product.joins(:restaurant).select("products.id,products.images_file_name,products.name as productname,restaurants.name as restaurantsname").where(restaurants: {city_id: @city_id})
        #end lay location duoc va khong post
      else
        # khong lay location duoc va post
        if @getLocation.blank? && request.post?
          @city_id=params[:city_id]
          @city = City.find_by_id(@city_id)
          if @city.present? && !params[:idcomponennt].present?
            @data=Product.joins(:restaurant).select("products.id,products.images_file_name,products.name as productname,restaurants.name as restaurantsname").where(restaurants: {city_id: @city_id})
            countryid=City.where(id: @city_id).first().country_id
            @location=City.where(country_id:countryid)
          else
            if @city.present? && params[:idcomponennt].present?
              @kk=params[:idcomponennt]
              @icomponent=params[:idcomponennt].split(/;/)
              @data=Product.joins(:product_components).joins(:restaurant).select("products.id,products.images_file_name,products.name as productname,restaurants.name as restaurantsname").distinct.where(restaurants: {city_id: @city_id},product_components:{component_value_id: @icomponent})
              @listvalue=ComponentValue.where(id: @icomponent)

              countryid=City.where(id: @city_id).first().country_id
              @location=City.where(country_id:countryid)

            else
              @kk=params[:idcomponennt]
              @hghhghgh=params[:idcitycureent]
              @city_id=@hghhghgh
              @icomponent=params[:idcomponennt].split(/;/)
              @data=Product.joins(:product_components).joins(:restaurant).select("products.id,products.images_file_name,products.name as productname,restaurants.name as restaurantsname").distinct.where(restaurants: {city_id: params[:idcitycureent]},product_components:{component_value_id: @icomponent})
              @listvalue=ComponentValue.where(id: @icomponent)

              country=Country.all.order("name ASC")
              countryid=country.first().id
              @location=City.where(country_id:countryid)

            end
          end
          # end khong lay location duoc va post
        else
          # lay location duoc va post
          if !@getLocation.blank? && request.post?
            @city_id=params[:city_id]
            @city = City.find_by_id(@city_id)
            if @city.present? && !params[:idcomponennt].present?
              @data=Product.joins(:restaurant).select("products.id,products.images_file_name,products.name as productname,restaurants.name as restaurantsname").where(restaurants: {city_id: @city_id})
              countryid=City.where(id: @city_id).first().country_id
              @location=City.where(country_id:countryid)
            else
              if @city.present? && params[:idcomponennt].present?
                @kk=params[:idcomponennt]
                @icomponent=params[:idcomponennt].split(/;/)
                @data=Product.joins(:product_components).joins(:restaurant).select("products.id,products.images_file_name,products.name as productname,restaurants.name as restaurantsname").distinct.where(restaurants: {city_id: @city_id},product_components:{component_value_id: @icomponent})
                @listvalue=ComponentValue.where(id: @icomponent)

                countryid=City.where(id: @city_id).first().country_id
                @location=City.where(country_id:countryid)
              else
                @kk=params[:idcomponennt]
                @icomponent=params[:idcomponennt].split(/;/)
                @data=Product.joins(:product_components).joins(:restaurant).select("products.id,products.images_file_name,products.name as productname,restaurants.name as restaurantsname").distinct.where(restaurants: {city_id: params[:idcitycureent]},product_components:{component_value_id: @icomponent})
                @listvalue=ComponentValue.where(id: @icomponent)

                _detectcountry=Country.where("lower(name)=?", @getLocation.first().country.downcase)
                _dectechcity=City.where("lower(name)=?",@getLocation.first().city.downcase)
                if !_detectcountry.blank?
                  _detectcountryid=_detectcountry.first().id
                  @location=City.where(country_id: _detectcountryid)
                  if !_dectechcity.blank?
                    @city_id=_dectechcity.first().id
                  else
                    @city_id=@location.first().id
                  end

                end
              end
            end
            # end lay location duoc va post
          else
            # khong lay va khong post
            #if !@getLocation.blank? && !request.post?
              country=Country.all.order("name ASC")
              countryid=country.first().id
              @location=City.where(country_id:countryid)
              @city_id=@location.first().id
              @data=Product.joins(:product_components).joins(:restaurant).select("products.id,products.images_file_name,products.name as productname,restaurants.name as restaurantsname").distinct.where(restaurants: {city_id: @city_id})

            #end

          end

        end

      end

      #citycurrent = request.location.city
      #countrycrrent=request.location.country
      #if countrycrrent.nil?
        #countryid=Country.find_by_name(countrycrrent).id
      #else

     # end

      #@location=City.all
      #if request.post?

        #@city_id=params[:city_id]
        #@city = City.find_by_id(@city_id)
        #if @city.present?
            #@data=Product.joins(:restaurant).select("products.id,products.images_file_name,products.name as productname,restaurants.name as restaurantsname").where(restaurants: {city_id: @city_id})

        #else
          #@kk=params[:idcomponennt]
          #@icomponent=params[:idcomponennt].split(/;/)
          #@data=Product.joins(:product_components).joins(:restaurant).select("products.id,products.images_file_name,products.name as productname,restaurants.name as restaurantsname").distinct.where(product_components:{component_value_id: @icomponent})
          #@listvalue=ComponentValue.where(id: @icomponent)
            
        #end



      #else
        #if citycurrent.nil?
          #locationcureent=City.find_by_name(citycurrent)
          #@city_id=locationcureent.id
          #@city = City.find_by_id(@city_id)
         # @data=Product.joins(:restaurant).select("products.id,products.images_file_name,products.name as productname,restaurants.name as restaurantsname").where(restaurants: {city_id: @city_id})
        #else
          #@data=Product.joins(:restaurant).select("products.id,products.images_file_name,products.name as productname,restaurants.name as restaurantsname").where(restaurants: {city_id: @location.first().id})
        #end
      #end
      @cueeentr=City.find_by_id(@city_id)
      @profile=Profile.where(user_id: current_user.id).first()
      render layout: "homelogin/homelogin"
  end

  def geolocation
    # render layout: "homelogin"
    render :action => "index", layout: "geolocation"
  end

  #hungnt
  #BurgerProfile
  def BurgerProfile
        @avrage=Product.get_socre_average_product_byid(params[:id],1)
        @countreview=Product.get_score_product_groupByuserId(params[:id],999999)
        Product.update_views_product_byid(params[:id])
        @productdetails=Product.get_product_Byid(params[:id])
        @scoreuser=Product.get_score_product_groupByuserId(params[:id],3)
        if user_signed_in?
          @profile=Profile.where(user_id: current_user.id).first()
        end
        @comemntproduct=Comment.where(product_id: params[:id])

      render layout:"BurgerProfile/BurgerProfile"
  end
  #hungnt
  #locations
  def locations
    render layout:"locations/locations"
  end

  def test
    # render layout: "homelogin"
    # redirect_to home_index
    # redirect_to :controller => 'home', :action => 'login'
    render layout: "application"
  end

  def test_ajax
    render json: Restaurant.all
  end
  def getProductByCity
    logger.debug('here')
    @ok="111"

    render layout: "homelogin/homelogin"
  end
  def addSession
    session[:checklogin]=1
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: 1}
    end
  end
   def CheckEmail
     _email=params[:email];
     _data=User.check_issame(_email);
     render :json => { :data => _data }
   end
  def addlike
    logger.debug params[:id].inspect
      Commentproduct.updatelike(params[:id])
      render :json => { :status => true }
  end
  def actionSendMail
    _html="";
    _html+="<p>You just received an invitation from a friend . You can click  here</a> to see details:</p>"+request.host_with_port+params[:link];
    _html+="<p>"+params[:message]+"</p>";
    _email=""
    if user_signed_in?
      _email=User.where(id: current_user.id).first().email
    end
    mail = UserNotifier.send_mail_toshare(params[:email],"You just received an invitation from a friend",_html,_email)
    mail.deliver
    render :json => { :status => true }
  end
  def addlocation
     _city=params[:city]
     _country=params[:country]
     _address=params[:address]
     _ip=params[:ip]
     _check=Location.where(ip: _ip)
     if _check.blank?
       Location.Add(0,_country,_city,_address,_ip)
     end

     render :json => { :status => true }
  end

   private
  # Use callbacks to share common setup or constraints between actions.
   def set_profile
     @profile = Profile.find(params[:id])
   end

   # Never trust parameters from the scary internet, only allow the white list through.
   def profile_params
     params.require(:profile).permit(:id, :avatar)
   end

end
