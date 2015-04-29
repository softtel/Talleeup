require 'product_view_models'

class HomeController < ApplicationController
   #before_action :authenticate_user!
   before_action :authenticate_user!, :except => [:index, :test,:addSession,:BurgerProfile,:CheckEmail,:reviewuser,:addlocation,:actionSendMailMutile]
   #autocomplete :brand, :name, :display_value => :funky_method
  def index
    if user_signed_in?
      redirect_to "/login"
    else
      # @cityDetected = request.location.city
      _ip=request.remote_ip
      @getLocation=Location.where(ip: _ip).order("id DESC")

      if !@getLocation.blank? && !request.post?
        _detectcountry=Country.where("lower(iso)=?", @getLocation.first().country.downcase)
        _dectechcity=City.where("lower(name)=?",@getLocation.first().city.downcase)
        if !_detectcountry.blank?
          _detectcountryid=_detectcountry.first().id

          @cities=City.where(country_id: _detectcountryid).order(name: :asc)
          if !_dectechcity.blank?
            city_id=_dectechcity.first().id
          else if !@cities.blank?
                 city_id=@cities.first().id
               else
                 country=Country.all.order("name ASC")
                 countryid=country.first().id
                 @cities=City.where(country_id:countryid).order(name: :asc)
                 city_id=@cities.first().id
               end
          end

        else
          country=Country.all.order("name ASC")
          countryid=country.first().id
          @cities=City.where(country_id:countryid).order(name: :asc)
          city_id=@cities.first().id
        end
      else if @getLocation.blank? && request.post?
             city_id=params[:city_id]
             countryid=City.where(id: city_id).first().country_id
             @cities=City.where(country_id:countryid).order(name: :asc)

           else if !@getLocation.blank? && request.post?
                  city_id=params[:city_id]
                  countryid=City.where(id: city_id).first().country_id
                  @cities=City.where(country_id:countryid).order(name: :asc)
                else

                  country=Country.all.order("name ASC")
                  countryid=country.first().id
                  @cities=City.where(country_id:countryid).order(name: :asc)
                  city_id=@cities.first().id
                end

           end

      end


      # country = request.location.country_code
      if user_signed_in?
        ap = Product.get_products(city_id, 99999999)
        if ap.count >0
          @products=ap
        else
          idcountry_pre=@cities.first().country_id
          restaurant_pre=Restaurant.joins(:products).where(restaurants:{country_id: idcountry_pre})
          if restaurant_pre.length>0
            city_id=restaurant_pre.first().city_id
          else
            #//default
            if request.post?
              city_id=params[:city_id]
            else
              country=Country.where(iso: 'US')
              countryid=country.first().id
              @cities=City.where(country_id:countryid).order(name: :asc)
              city_id=@cities.where("lower(name)=?","san francisco").first().id
            end
          end
          @products=Product.get_products(city_id, 99999999)
        end
      else
        if !request.post?
          ap = Product.get_products(city_id, 5)
          if ap.count >0
            @products=ap
          else
            idcountry_pre=@cities.first().country_id
            restaurant_pre=Restaurant.joins(:products).where(restaurants:{country_id: idcountry_pre})
            if restaurant_pre.length>0
              city_id=restaurant_pre.first().city_id
            else
              #//default
              if request.post?
                country=Country.where(iso: 'US')
                countryid=country.first().id
                @cities=City.where(country_id:countryid)
                city_id=city_id=params[:city_id]
              else
                country=Country.where(iso: 'US')
                countryid=country.first().id
                @cities=City.where(country_id:countryid)
                city_id=@cities.where("lower(name)=?","san francisco").first().id
              end
            end
            @products=Product.get_products(city_id, 5)
          end
        else
          city_id=params[:city_id]
          countryid=City.where(id: city_id).first().country_id
          @cities=City.where(country_id:countryid).order(name: :asc)
          @products=Product.get_products(city_id, 5)
        end
      end
      @current_city = City.find_by_id(city_id)
      render layout: "home_layout"
    end

  end

  def follow

    Follow.add(current_user.id, params[:friend_id])
    render :json => { :status => true }
  end
  def getUserFllow
   data= Follow.getUserFllow(current_user.id)
    render :json=>{:data=> data}
  end
   def unfollow

     Follow.delete(current_user.id, params[:friend_id])
     render :json => { :status => true }
   end


  def search

    # @cityDetected = request.location.city
  #  _ip=request.remote_ip
  #  @getLocation=Location.where(ip: _ip).order("id DESC")
  #  if !@getLocation.blank?
  #    _detectcountry=Country.where("lower(iso)=?", @getLocation.first().country.downcase)
    #  _dectechcity=City.where("lower(name)=?",@getLocation.first().city.downcase)
  #    if !_detectcountry.blank?
   #     _detectcountryid=_detectcountry.first().id
  #      @cities=City.where(country_id: _detectcountryid)
  #      if !_dectechcity.blank?
  #        city_id=_dectechcity.first().id
   #     else
   #       if !@cities.blank?
   #         city_id=@cities.first().id
    #      else
     #       country=Country.all.order("name ASC")
    #        countryid=country.first().id
    #        @cities=City.where(country_id:countryid)
    #        city_id=@cities.first().id
    #        end
    #    end
     # else
    #    country=Country.all.order("name ASC")
    #    countryid=country.first().id
    #    @cities=City.where(country_id:countryid)
    #    city_id=@cities.first().id
     # end
   # else
    #  country=Country.all.order("name ASC")
    #  countryid=country.first().id
    #  @cities=City.where(country_id:countryid)
    #  city_id=@cities.first().id
    #end

    @keyword = params[:keyword]
    @products = Product.search(@keyword)#,city_id)

    @myprofile = Profile.getProfile(current_user.id)

    render layout: "search_layout"
  end


  def getcityByIDCountry
    _id=params[:idcountry]
    @cityall=City.where(country_id: _id).order(name: :asc)
    render :json => { :data => @cityall }
  end
  def userprofile

    ### friend
    @friend = User.find_by_id(params[:id])

    @isMyprofile = (@friend.id == current_user.id) ? true : false
    @coutry=CityCountryUser.where(user_id: current_user.id.to_s,type_option: 'country')
    @cityddddd=CityCountryUser.where(user_id: current_user.id.to_s,type_option: 'city')
    if @friend.nil?
      @friend = User.find_by_id(1)
    end
    @countryall=Country.all().order(name: :asc)

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

        #if params[:file].present?
         # Review.save(params[:file])

        #end
        Comment.create(content:  params[:content],images: params[:file],product_id:params[:productid],user_id:current_user.id)
      end
    end
    redirect_to :controller => 'home', :action => 'BurgerProfile', :id => params[:productid]
  end

  def user_meta
    MetaUser.update_profile(params[:id], params[:value])
    render :json => { :data => true }
  end
   def user_meta_country_city
     CityCountryUser.insert_prodile(params[:id], params[:value],current_user.id,params[:type])
     render :json => { :data => true }
   end
   def update_user_meta_country_city
     CityCountryUser.update_prodile(params[:id], params[:value])
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
        @reviewedinfog = Review.getReviewedInfo(current_user.id,  @product.id)
        @date_now=(Time.now - @reviewedinfog.created_at.to_time)/1.day
        @reviewed_components = @reviewed.get_reviewed_components()
        #@reviewscommentproduct=Commentproduct.where(reviewsproductuser_id: @reviewed.getReviewedId(current_user.id,  @product.id))
      end
      @idproduct=params[:product_id]
      idrestaurent=Product.where(id: params[:product_id]).first().restaurant_id
      @namerestaurent=Restaurant.where(id: idrestaurent).first().name
      @nameproduct=Product.where(id: params[:product_id]).first().name

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
    @userall=User.all().select(:fullname)

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
      @componant=Component.joins(:filter)
      @companonetcity=City.joins(:filter_city)
      @getLocation=Location.where(ip: _ip).order("id DESC")
      # lay location duoc va khong post
      if !@getLocation.blank? && !request.post?
          _detectcountry=Country.where("lower(iso)=?", @getLocation.first().country.downcase)
          _dectechcity=City.where("lower(name)=?",@getLocation.first().city.downcase)
          if !_detectcountry.blank?
            _detectcountryid=_detectcountry.first().id
            @location=City.where(country_id: _detectcountryid).order(name: :asc)
            if !_dectechcity.blank?
              @city_id=_dectechcity.first().id
            else if !@location.blank?
                   @city_id=@location.first().id
                 else
                   country=Country.where(iso: 'US')
                   countryid=country.first().id
                   @cities=City.where(country_id:countryid)
                   @city_id=@cities.where("lower(name)=?","san francisco").first().id
                   @location=City.where(country_id: countryid).order(name: :asc)
                   #@cities=City.where(country_id:countryid)
                   #city_id=@cities.where("lower(name)=?","san francisco").first().id

                   #country=Country.all.order("name ASC")
                   #countryid=country.first().id

                 end

            end
          else
            #country=Country.all.order("name ASC")
            #countryid=country.first().id
            #@location=City.where(country_id:countryid).order(name: :asc)
            #@city_id=@location.first().id

            country=Country.where(iso: 'US')
            countryid=country.first().id
            @cities=City.where(country_id:countryid)
            @city_id=@cities.where("lower(name)=?","san francisco").first().id
            @location=City.where(country_id: countryid).order(name: :asc)

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
            @location=City.where(country_id:countryid).order(name: :asc)
          else
            if @city.present? && params[:idcomponennt].present?
              @kk=params[:idcomponennt]
              @icomponent=params[:idcomponennt].split(/;/)
              _idcityfilter=Array.new
              _idcategoryfilter=Array.new
              if @icomponent.length>0

                  for x in @icomponent
                    _c=x.split(/@/)
                    if _c[1]=='city'
                      _idcityfilter.push(_c[0])
                    else
                      _idcategoryfilter.push(_c[0])
                    end
                  end
              end
              #@data=Product.joins(:product_components).joins(:restaurant).select("products.id,products.images_file_name,products.name as productname,restaurants.name as restaurantsname").distinct.where(restaurants: {city_id: @city_id},product_components:{component_value_id: @icomponent})
              #@data=Product.joins(:product_components).joins(:restaurant).select("products.id,products.images_file_name,products.name as productname,restaurants.name as restaurantsname").distinct.where(restaurants: {city_id: _idcityfilter},product_components:{component_value_id: _idcategoryfilter})
              @data=Product.joins(product_components: [{component_value: :component }]).joins(:restaurant).select("products.id,products.images_file_name,products.name as productname,restaurants.name as restaurantsname").distinct
              if _idcityfilter.length>0
                @data=@data.where(restaurants: {city_id: _idcityfilter})
              end
              if _idcategoryfilter.length>0
                @data=@data.where(components:{id: _idcategoryfilter})
              end
              @listvalue=Component.where(id: _idcategoryfilter)
              @listcutyfilter=City.where(id:_idcityfilter)
              countryid=City.where(id: @city_id).first().country_id
              @location=City.where(country_id:countryid).order(name: :asc)

            else
              @kk=params[:idcomponennt]
              @hghhghgh=params[:idcitycureent]
              @city_id=@hghhghgh
              @icomponent=params[:idcomponennt].split(/;/)
              _idcityfilter=Array.new
              _idcategoryfilter=Array.new
              if @icomponent.length>0

                for x in @icomponent
                  _c=x.split(/@/)
                  if _c[1]=='city'
                    _idcityfilter.push(_c[0])
                  else
                    _idcategoryfilter.push(_c[0])
                  end
                end
              end
              #@data=Product.joins(:product_components).joins(:restaurant).select("products.id,products.images_file_name,products.name as productname,restaurants.name as restaurantsname").distinct.where(restaurants: {city_id: params[:idcitycureent]},product_components:{component_value_id: @icomponent})
              @data=Product.joins(product_components: [{component_value: :component }]).joins(:restaurant).select("products.id,products.images_file_name,products.name as productname,restaurants.name as restaurantsname").distinct
              if _idcityfilter.length>0
                @data=@data.where(restaurants: {city_id: _idcityfilter})
              end
              if _idcategoryfilter.length>0
                @data=@data.where(components:{id: _idcategoryfilter})
              end

              #@listvalue=ComponentValue.where(id: @icomponent)
              @listvalue=Component.where(id: _idcategoryfilter)
              @listcutyfilter=City.where(id:_idcityfilter)
              @datatata=@icomponent.length

              country=Country.where(iso: 'US')
              countryid=country.first().id
              @cities=City.where(country_id:countryid)
              @city_id=@cities.where("lower(name)=?","san francisco").first().id
              @location=City.where(country_id: countryid).order(name: :asc)

              #country=Country.all.order("name ASC")
              #countryid=country.first().id
              #@location=City.where(country_id:countryid).order(name: :asc)

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
              @location=City.where(country_id:countryid).order(name: :asc)
              @hung=1;
            else
              if @city.present? && params[:idcomponennt].present?
                @hung=2;
                @kk=params[:idcomponennt]
                @icomponent=params[:idcomponennt].split(/;/)
                _idcityfilter=Array.new
                _idcategoryfilter=Array.new
                if @icomponent.length>0

                  for x in @icomponent
                    _c=x.split(/@/)
                    if _c[1]=='city'
                      _idcityfilter.push(_c[0])
                    else
                      _idcategoryfilter.push(_c[0])
                    end
                  end
                end
                #@data=Product.joins(:product_components).joins(:restaurant).select("products.id,products.images_file_name,products.name as productname,restaurants.name as restaurantsname").distinct.where(restaurants: {city_id: @city_id},product_components:{component_value_id: @icomponent})
                #@data=Product.joins(:product_components).joins(:restaurant).select("products.id,products.images_file_name,products.name as productname,restaurants.name as restaurantsname").distinct.where(restaurants: {city_id: _idcityfilter},product_components:{component_value_id: _idcategoryfilter})
                @data=Product.joins(product_components: [{component_value: :component }]).joins(:restaurant).select("products.id,products.images_file_name,products.name as productname,restaurants.name as restaurantsname").distinct
                if _idcityfilter.length>0
                  @data=@data.where(restaurants: {city_id: _idcityfilter})
                end
                if _idcategoryfilter.length>0
                  @data=@data.where(components:{id: _idcategoryfilter})
                end
                @listvalue=Component.where(id: _idcategoryfilter)
                @listcutyfilter=City.where(id:_idcityfilter)
                countryid=City.where(id: @city_id).first().country_id
                @location=City.where(country_id:countryid).order(name: :asc)
              else
                @hung=3;
                @kk=params[:idcomponennt]
                @icomponent=params[:idcomponennt].split(/;/)
                _idcityfilter=Array.new
                _idcategoryfilter=Array.new
                if @icomponent.length>0

                  for x in @icomponent
                    _c=x.split(/@/)
                    if _c[1]=='city'
                      _idcityfilter.push(_c[0])
                    else
                      _idcategoryfilter.push(_c[0])
                    end
                  end
                end
                #@data=Product.joins(:product_components).joins(:restaurant).select("products.id,products.images_file_name,products.name as productname,restaurants.name as restaurantsname").distinct.where(restaurants: {city_id: params[:idcitycureent]},product_components:{component_value_id: @icomponent})
                #@data=Product.joins(:product_components).joins(:restaurant).select("products.id,products.images_file_name,products.name as productname,restaurants.name as restaurantsname").distinct.where(restaurants: {city_id: _idcityfilter},product_components:{component_value_id: _idcategoryfilter})
                @data=Product.joins(product_components: [{component_value: :component }]).joins(:restaurant).select("products.id,products.images_file_name,products.name as productname,restaurants.name as restaurantsname").distinct
                if _idcityfilter.length>0
                  @data=@data.where(restaurants: {city_id: _idcityfilter})
                end
                if _idcategoryfilter.length>0
                  @data=@data.where(components:{id: _idcategoryfilter})
                end
                #@listvalue=ComponentValue.where(id: @icomponent)
                @listvalue=Component.where(id: _idcategoryfilter)
                @listcutyfilter=City.where(id:_idcityfilter)
                _detectcountry=Country.where("lower(iso)=?", @getLocation.first().country.downcase)
                _dectechcity=City.where("lower(name)=?",@getLocation.first().city.downcase)
                if !_detectcountry.blank?
                  _detectcountryid=_detectcountry.first().id
                  @kkk=_detectcountryid
                  @location=City.where(country_id: _detectcountryid).order(name: :asc)
                  if !_dectechcity.blank?
                    @city_id=_dectechcity.first().id
                  else
                    if !@location.blank?
                        @city_id=@location.first().id
                    else

                      #country=Country.all.order("name ASC")
                      #countryid=country.first().id
                      #@cities=City.where(country_id:countryid)
                     #@city_id=@cities.first().id
                     # @location=City.where(country_id: countryid).order(name: :asc)


                      country=Country.where(iso: 'US')
                      countryid=country.first().id
                      @cities=City.where(country_id:countryid)
                      @city_id=@cities.where("lower(name)=?","san francisco").first().id
                      @location=City.where(country_id: countryid).order(name: :asc)

                      end
                  end

                end
              end
            end
            # end lay location duoc va post
          else
            # khong lay va khong post
            #if !@getLocation.blank? && !request.post?
              #country=Country.all.order("name ASC")
              #countryid=country.first().id
              country=Country.where(iso: 'US')
              countryid=country.first().id
              @cities=City.where(country_id:countryid)
              @city_id=@cities.where("lower(name)=?","san francisco").first().id
              @location=City.where(country_id: countryid).order(name: :asc)

              #@location=City.where(country_id:countryid).order(name: :asc)
              #@city_id=@location.first().id
              @data=Product.joins(:product_components).joins(:restaurant).select("products.id,products.images_file_name,products.name as productname,restaurants.name as restaurantsname").distinct.where(restaurants: {city_id: @city_id})

            #end

          end

        end

      end
      if @data.length<=0
          if !request.post?
            idcountry_pre=@location.first().country_id
            restaurant_pre=Restaurant.joins(:products).where(restaurants:{country_id: idcountry_pre})
            if restaurant_pre.length>0
              @city_id=restaurant_pre.first().city_id
              @data=Product.joins(:product_components).joins(:restaurant).select("products.id,products.images_file_name,products.name as productname,restaurants.name as restaurantsname").distinct.where(restaurants: {city_id: @city_id})
              #@pooooo=2
            else
                #if request.post?
                  #if params[:city_id].present? && !params[:idcomponennt].present?
                    #@city_id=params[:city_id]
                    #@data=Product.joins(:product_components).joins(:restaurant).select("products.id,products.images_file_name,products.name as productname,restaurants.name as restaurantsname").distinct.where(restaurants: {city_id: @city_id})
                    #@pooooo=1
                  #else
                   # if !params[:city_id].present? && params[:idcomponennt].present?
                      #@city_id=params[:city_id]
                      #@data=Product.joins(:product_components).joins(:restaurant).select("products.id,products.images_file_name,products.name as productname,restaurants.name as restaurantsname").distinct.where(restaurants: {city_id: @city_id})
                   # end
                  #end
                #else
                  #default
                  country=Country.where(iso: 'US')
                  countryid=country.first().id
                  @location=City.where(country_id:countryid)
                  @city_id=@location.where("lower(name)=?","san francisco").first().id
                #end

                @data=Product.joins(:product_components).joins(:restaurant).select("products.id,products.images_file_name,products.name as productname,restaurants.name as restaurantsname").distinct.where(restaurants: {city_id: @city_id})
            end
          else
            if params[:city_id].present? && !params[:idcomponennt].present?
                  @city_id=params[:city_id]
                  @data=Product.joins(:product_components).joins(:restaurant).select("products.id,products.images_file_name,products.name as productname,restaurants.name as restaurantsname").distinct.where(restaurants: {city_id: @city_id})
                  @pooooo=1
            else
              # if !params[:city_id].present? && params[:idcomponennt].present?
                  #@city_id=params[:city_id]
                  @icomponent=params[:idcomponennt].split(/;/)
                  _idcityfilter=Array.new
                  _idcategoryfilter=Array.new
                  if @icomponent.length>0

                    for x in @icomponent
                      _c=x.split(/@/)
                      if _c[1]=='city'
                        _idcityfilter.push(_c[0])
                      else
                        _idcategoryfilter.push(_c[0])
                      end
                    end
                  end
                  @data=Product.joins(product_components: [{component_value: :component }]).joins(:restaurant).select("products.id,products.images_file_name,products.name as productname,restaurants.name as restaurantsname").distinct
                  if _idcityfilter.length>0
                    @data=@data.where(restaurants: {city_id: _idcityfilter})
                  end
                  if _idcategoryfilter.length>0
                    @data=@data.where(components:{id: _idcategoryfilter})
                  end
                  @listvalue=Component.where(id: _idcategoryfilter)
                  @listcutyfilter=City.where(id:_idcityfilter)
                #  _detectcountry=Country.where("lower(iso)=?", @getLocation.first().country.downcase)
                 # _dectechcity=City.where("lower(name)=?",@getLocation.first().city.downcase)
                 # if !_detectcountry.blank?
                   # _detectcountryid=_detectcountry.first().id
                   # @kkk=_detectcountryid
                   # @location=City.where(country_id: _detectcountryid)
                   # if !_dectechcity.blank?
                   #   @city_id=_dectechcity.first().id
                   # else
                   #   if !@location.blank?
                     #   @city_id=@location.first().id
                     # else
                      #  country=Country.all.order("name ASC")
                      #  countryid=country.first().id
                      #  @cities=City.where(country_id:countryid)
                     #   @city_id=@cities.first().id
                     #   @location=City.where(country_id: countryid)
                     # end
                   # end

                  #end
               #end
            end
        end
      end
      @cueeentr=City.find_by_id(@city_id)
      @profile=Profile.where(user_id: current_user.id).first()

      render :action => "login", layout: "homelogin/homelogin"
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
   def addlikeComemnt

     Comment.updatelike(params[:id])
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
   def actionSendMailMutile
     _html="";
     _html+="<p>You just received an invitation from a friend . You can click  here</a> to see details:</p>"+params[:link];
     _html+="<p>"+params[:message]+"</p>";
     _email=""
     if user_signed_in?
       _email=User.where(id: current_user.id).first().email
     end
     if params[:email].present?
        result= params[:email].split(/,/);
        listdata=[]
        for hhh in result
          listdata.push(hhh.strip)
        end

        _data=User.where(fullname: listdata);

        for ddd in _data
              mail = UserNotifier.send_mail_toshare(ddd.email,"You just received an invitation from a friend",_html,_email);
              mail.deliver;

        end

        render :json => { :status => true }
     else
       render :json => { :status => false }
      end


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
   def reviewuser

     @myprofile =   Profile.getProfile(current_user.id)
     @profile = Profile.getProfile(current_user.id)
     @user = User.where(id: current_user.id).first()

     limit = (params[:fulllist].nil?) ? 5 : 1000
     @products = User.get_products_reviewedAll(limit)
     @is_full_list = (params[:fulllist].nil?) ? false : true

     render layout: "reviewuser/reviewuser_layout"
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
