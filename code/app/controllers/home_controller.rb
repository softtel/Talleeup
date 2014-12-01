class HomeController < ApplicationController
  # before_action :authenticate_user!
  def index
    @products = Product.all
    render layout: "home_layout"
  end

  def userprofile
    @products = Product.all
    render layout: "userprofile_layout"
  end

  def myprofile
    @products = Product.all
    render layout: "myprofile_layout"
  end

  def review
    render layout: "review_layout"
  end

  #hungnt
  #login
  def login
      @product = Product.all
      render layout: "homelogin/homelogin"
  end

  def geolocation
    # render layout: "homelogin"
    render :action => "index", layout: "geolocation"
  end

  #hungnt
  #BurgerProfile
  def BurgerProfile
      render layout:"BurgerProfile/BurgerProfile"
  end
  #hungnt
  #locations
  def locations
    render layout:"locations/locations"
  end

  def test
    # render layout: "homelogin"
    render layout: "application"
  end

end
