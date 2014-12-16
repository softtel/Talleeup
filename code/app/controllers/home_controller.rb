require 'product_view_models'

class HomeController < ApplicationController
  # before_action :authenticate_user!
  # before_action :authenticate_user!, :except => [:index]

  def index

    # @cityDetected = request.location.city

    city_id = (params[:city_id].nil?) ? 1 : params[:city_id]
    @current_city = City.find_by_id(city_id)

    @cities = City.all
    # country = request.location.country_code

    session[:user_id] = 1

    @products = Product.get_products(city_id, 5)

    @my_user_id = 1

    render layout: "home_layout"
  end

  def userprofile

    ### friend
    friend_id = params[:id]
    @friend = User.find_by_id(friend_id)

    if @friend.nil?
      @friend = User.find_by_id(1)
    end

    @profile = Profile.find(friend_id)
    @products = @friend.get_products_reviewed

    ### user
    user_id = 1 # get from section
    @user = User.find_by_id(user_id)
    @myprofile = Profile.find(user_id)
    @isFollowed = @user.isFollowed(friend_id)


    # layout
    render layout: "userprofile_layout"
  end

  def myprofile
    my_user_id = 1 # get from section
    @user = User.find(my_user_id)
    @myprofile = Profile.find(my_user_id)
    @products = Product.all

    render layout: "myprofile_layout"
  end

  def review
    @product = Product.find_by_id(params[:product_id])
    @my_user_id = session[:user_id] # get from section

    user = User.find(@my_user_id)
    user = User.find(@my_user_id)
    @myprofile = Profile.find(@my_user_id)

    render layout: "review_layout"
  end

  #hungnt
  #login
  def login
      @componant=Component.all
      #citycurrent = request.location.city
      #countrycrrent=request.location.country
      #if countrycrrent.nil?
        #countryid=Country.find_by_name(countrycrrent).id
      #else
        country=Country.all.order("name ASC")
        countryid=country.first().id
     # end
      @location=City.where(country_id:countryid)
      #@location=City.all
      if request.post?

        @city_id=params[:city_id]
        @city = City.find_by_id(@city_id)
        if @city.present?
            @data=Product.joins(:restaurant).select("products.id,products.images_file_name,products.name as productname,restaurants.name as restaurantsname").where(restaurants: {city_id: @city_id})
        else
          @kk=params[:idcomponennt]
          @icomponent=params[:idcomponennt].split(/;/)
          @data=Product.joins(:product_components).joins(:restaurant).select("products.id,products.images_file_name,products.name as productname,restaurants.name as restaurantsname").distinct.where(product_components:{component_value_id: @icomponent})
          @listvalue=ComponentValue.where(id: @icomponent)
            
        end



      else
        #if citycurrent.nil?
          #locationcureent=City.find_by_name(citycurrent)
          #@city_id=locationcureent.id
          #@city = City.find_by_id(@city_id)
         # @data=Product.joins(:restaurant).select("products.id,products.images_file_name,products.name as productname,restaurants.name as restaurantsname").where(restaurants: {city_id: @city_id})
        #else
          @data=Product.joins(:restaurant).select("products.id,products.images_file_name,products.name as productname,restaurants.name as restaurantsname").where(restaurants: {city_id: @location.first().id})
        #end
      end
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
end
