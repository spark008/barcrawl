class EInvitationsController < ApplicationController
  before_action :set_e_invitation, only: [:show, :edit, :update, :destroy]
  before_action :bounce_if_logged_out
  before_action :bounce_if_not_admin, only: [:destroy]

  # GET /e_invitations/new
  def new
    tour = Tour.find(params[:tour_id])
    @e_invitation = EInvitation.new(tour: tour)
    return bounce_if_not_attending unless @current_user.attending? tour
  end

  # POST /e_invitations
  # POST /e_invitations.json
  def create
    @e_invitation = EInvitation.new(e_invitation_params)
    @e_invitation.sender = @current_user
    unless @current_user.attending? @e_invitation.tour
      return bounce_if_not_attending
    end 

    invitation = @e_invitation.to_invitation

    respond_to do |format|
      if invitation && invitation.save # recipient is a user and uninvited
        UserMailer.user_invitation_email(invitation, root_url).deliver
        format.html do
          redirect_to invitation.tour,
                      notice: 'An invitation was successfully created.'
        end
      elsif @e_invitation.save # recipient is a non-user and uninvited
        UserMailer.non_user_invitation_email(@e_invitation, root_url).deliver
        format.html do
          redirect_to @e_invitation.tour,
                      notice: 'An invitation was successfully created.'
        end
      else # recipient has already been invited
        format.html { render :new }
        format.json { render json: @e_invitation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /e_invitations/1
  # DELETE /e_invitations/1.json
  def destroy
    @e_invitation.destroy
    respond_to do |format|
      format.html { redirect_to root_url, notice: 'E invitation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_e_invitation
      @e_invitation = EInvitation.find(params[:id])
    end

    def e_invitation_params
      params.require(:e_invitation).permit(:email, :tour_id)
    end
end
