# frozen_string_literal: true

# == Schema Information
#
# Table name: calendars
#
#  id         :uuid             not null, primary key
#  name       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_calendars_on_name     (name)
#  index_calendars_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_d574754a30  (user_id => users.id)
#
class CalendarsController < ApplicationController
  before_action :set_calendar, only: %i[show edit update destroy]

  # GET /calendars or /calendars.json
  def index
    @calendars = Calendar.all
    authorize @calendars # Ensure the user is allowed to perform this action.
  end

  # GET /calendars/1 or /calendars/1.json
  def show
    authorize @calendar # Ensure the user is allowed to perform this action.
  end

  # GET /calendars/new
  def new
    @calendar = Calendar.new
    authorize @calendar # Ensure the user is allowed to perform this action.
  end

  # GET /calendars/1/edit
  def edit
    authorize @calendar # Ensure the user is allowed to perform this action.
  end

  # POST /calendars or /calendars.json
  def create
    @calendar = Calendar.new(calendar_params)
    authorize @calendar # Ensure the user is allowed to perform this action.
    @calendar.user = current_user unless current_user.nil?

    respond_to do |format|
      if @calendar.save
        format.html { redirect_to @calendar, notice: 'Calendar was successfully created.' }
        format.json { render :show, status: :created, location: @calendar }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(@calendar, partial: 'calendars/form',
                                                               locals: { calendar: @calendar })
        end
        format.json { render json: @calendar.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /calendars/1 or /calendars/1.json
  def update
    authorize @calendar # Ensure the user is allowed to perform this action.

    respond_to do |format|
      if @calendar.update(calendar_params)
        format.html { redirect_to @calendar, notice: 'Calendar was successfully updated.' }
        format.json { render :show, status: :ok, location: @calendar }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @calendar.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /calendars/1 or /calendars/1.json
  def destroy
    authorize @calendar # Ensure the user is allowed to perform this action.

    @calendar.destroy
    respond_to do |format|
      format.html { redirect_to calendars_url, notice: 'Calendar was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_calendar
    @calendar = Calendar.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render file: "#{Rails.root}/public/404.html", status: :not_found and return
  end

  # Only allow a list of trusted parameters through.
  def calendar_params
    params.require(:calendar).permit(:user_id, :calendar_events, :name)
  end
end
