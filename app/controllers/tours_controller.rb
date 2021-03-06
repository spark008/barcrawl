class ToursController < ApplicationController
  before_action :set_tour, only: [:show, :edit, :update, :destroy]
  before_action :bounce_if_logged_out
  before_action :bounce_if_not_admin, only: [:index, :destroy]

  # GET /tours
  # GET /tours.json
  def index
    @tours = Tour.includes(:organizer).order('users.name').page params[:page]
  end

  # GET /tours/1
  # GET /tours/1.json
  def show
  end

  # GET /tours/new
  def new
    @tour = Tour.new
  end

  # GET /tours/1/edit
  def edit
    unless @tour.organized_by?(@current_user)
      redirect_to root_url, notice: 'You are not the organizer. Step away.'
      return
    end
  end

  # POST /tours
  # POST /tours.json
  def create
    @tour = Tour.new(tour_params)
    @tour.organizer = @current_user

    respond_to do |format|
      if @tour.save
        format.html { redirect_to @tour, notice: "Tour successfully created!" }
        format.json { render :show, status: :created, location: @tour }
      else
        format.html { render :new }
        format.json { render json: @tour.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tours/1
  # PATCH/PUT /tours/1.json
  def update
    unless @tour.organized_by?(@current_user)
      redirect_to root_url, notice: 'You are not the organizer. Step away.'
      return
    end
    
    respond_to do |format|
      if @tour.update(tour_params)
        format.html { redirect_to @tour, notice: 'Tour was successfully updated.' }
        format.json { render :show, status: :ok, location: @tour }
      else
        format.html { render :edit }
        format.json { render json: @tour.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tour
      @tour = Tour.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tour_params
      params.require(:tour).permit(:name, :city_id, :starting_at, :image, :description, :status)
    end
end
