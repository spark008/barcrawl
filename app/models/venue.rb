class Venue < ActiveRecord::Base
  belongs_to :city
  
  before_destroy :ensure_not_referenced_by_any_tour_stop
  
  validates :name, :city, :latitude, :longitude, :address, :phone_number, :rating_count, :image_url, presence: true
  
  validates :stars, inclusion: { in: [1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0] }
  validates :stars, presence: true
  
  validates :yelp_id, uniqueness: true
  validates :yelp_id, presence: true
  
  def self.unproposed_for(tour)
    Venue.where(city: tour.city).where.not(id: tour.venues)
  end
    
  private
  
    def ensure_not_referenced_by_any_tour_stop
      TourStop.where(venue: self).empty?
    end
end
