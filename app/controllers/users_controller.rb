class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :bounce_if_logged_out, except: [:new, :create]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    unless @current_user == @user || @current_user.admin?
      redirect_to root_url, notice: "You cannot access this person's profile."
      return
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        # set :user_id field HERE, if new account
        session[:user_id] = @user.to_param
        format.html { redirect_to root_url, notice: "Welcome, #{@user.name}!" }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    unless @current_user == @user || @current_user.admin?
      redirect_to root_url, notice: "You cannot access this person's profile."
      return
    end
    
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'Account updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    unless @current_user == @user || @current_user.admin?
      redirect_to root_url, notice: "You cannot access this person's profile."
      return
    end
    
    @user.destroy
    respond_to do |format|
      format.html { redirect_to root_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :avatar_url, :password, :password_confirmation)
    end
end
