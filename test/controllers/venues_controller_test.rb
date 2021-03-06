require 'test_helper'

class VenuesControllerTest < ActionController::TestCase
    
  setup do
    @venue = venues(:cafe)
    @not_admin = users(:peridot)
    @admin = users(:admin)
    login_as @admin
  end

  test "non-admin users can view index" do
    logout
    login_as @not_admin
    
    get :index
    assert_response :success
    assert_not_nil assigns(:venues)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "if yelp id is not in database, create venue" do
    yelp_id = 'pasta-palace'
    
    assert_not Venue.where(yelp_id: yelp_id).exists?
    assert_difference('Venue.count') do
      post :create, venue: { name: 'Pasta Palace',
                             city_id: @venue.city_id,
                             latitude: @venue.latitude,
                             longitude: @venue.longitude,
                             address: @venue.address,
                             phone_number: @venue.phone_number,
                             stars: @venue.stars,
                             rating_count: @venue.rating_count,
                             image_url: @venue.image_url,
                             yelp_id: yelp_id }
    end

    assert_match(/successfully created/, flash[:notice].inspect)
    assert_redirected_to venues_path
  end
  
  test "if yelp id is in database, update venue" do
    yelp_id = @venue.yelp_id
    
    assert Venue.where(yelp_id: yelp_id).exists?
    assert_no_difference('Venue.count') do
      post :create, venue: { name: 'Not the original name',
                             city_id: @venue.city_id,
                             latitude: @venue.latitude,
                             longitude: @venue.longitude,
                             address: @venue.address,
                             phone_number: @venue.phone_number,
                             stars: @venue.stars,
                             rating_count: @venue.rating_count,
                             image_url: @venue.image_url,
                             yelp_id: yelp_id }
    end
    
    updated_venue = Venue.where(yelp_id: yelp_id).first
    assert_match(/Not the original name/, updated_venue.name)
    assert_match(/successfully updated/, flash[:notice].inspect)
    assert_redirected_to updated_venue
  end

  test "non-admin users can view venues" do
    logout
    login_as @not_admin
    
    get :show, id: @venue
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @venue
    assert_response :success
  end

  test "should update venue" do
    patch :update, id: @venue, venue: { name: @venue.name }
    assert_redirected_to venue_path(assigns(:venue))
  end

  test "venue should only be destroyed if not referenced by tour stops" do
    assert TourStop.where(venue: @venue).exists?
    assert_no_difference('Venue.count') do
      delete :destroy, id: @venue
    end
    
    TourStop.where(venue: @venue).destroy_all    
    assert_difference('Venue.count', -1) do
      delete :destroy, id: @venue
    end    

    assert_redirected_to venues_path
  end
end
