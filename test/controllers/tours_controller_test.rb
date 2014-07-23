require 'test_helper'

class ToursControllerTest < ActionController::TestCase
  fixtures :tours, :users, :cities
  
  setup do
    @tour = tours(:birthday)
    @user = users(:peridot)
    login_as @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tours)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tour" do
    assert_difference('Tour.count') do
      post :create, tour: { name: '2014 Graduation',
                            city_id: @tour.city_id,
                            starting_at: @tour.starting_at }
    end
    
    assert_match(/Tour successfully created!/, flash[:notice].inspect)
    assert_redirected_to tour_path(assigns(:tour))
  end

  test "should show tour" do
    get :show, id: @tour
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tour
    assert_response :success
  end

  test "should update tour" do
    patch :update, id: @tour, tour: { description: @tour.description, image: @tour.image, name: @tour.name, starting_at: @tour.starting_at }
    assert_redirected_to tour_path(assigns(:tour))
  end

  test "should destroy tour" do
    assert_difference('Tour.count', -1) do
      delete :destroy, id: @tour
    end

    assert_redirected_to tours_path
  end
  
  test "must be logged in to view tours" do
    logout
    get :show, id: @tour
    
    assert_redirected_to root_url
  end
  
end
