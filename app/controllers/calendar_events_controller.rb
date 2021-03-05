# frozen_string_literal: true

# == Schema Information
#
# Table name: calendar_events
#
#  id          :bigint           not null, primary key
#  duration    :daterange
#  name        :text             not null
#  slug        :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  calendar_id :bigint           not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_calendar_events_on_calendar_id  (calendar_id)
#  index_calendar_events_on_name         (name)
#  index_calendar_events_on_slug         (slug) UNIQUE
#  index_calendar_events_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_0011c39cc3  (calendar_id => calendars.id)
#  fk_rails_930e3c0bf4  (user_id => users.id)
#
class CalendarEventsController < ApplicationController
  before_action :set_calendar_event, only: %i[show edit update destroy]

  # GET /calendar_events or /calendar_events.json
  def index
    @calendar_events = CalendarEvent.all
    authorize @calendar_events # Ensure the user is allowed to perform this action.
    @calendar_events = @calendar_events.then(&paginate) # Paginate the results.
  end

  # GET /calendar_events/1 or /calendar_events/1.json
  def show
    authorize @calendar_event # Ensure the user is allowed to perform this action.
  end

  # GET /calendar_events/new
  def new
    @calendar_event = CalendarEvent.new
    authorize @calendar_event # Ensure the user is allowed to perform this action.
  end

  # GET /calendar_events/1/edit
  def edit
    authorize @calendar_event # Ensure the user is allowed to perform this action.
  end

  # POST /calendar_events or /calendar_events.json
  def create
    @calendar_event = CalendarEvent.new(calendar_event_params)
    authorize @calendar_event # Ensure the user is allowed to perform this action.
    @calendar_event.user = current_user unless current_user.nil?

    respond_to do |format|
      if @calendar_event.save
        format.html { redirect_to @calendar_event, notice: 'Calendar event was successfully created.' }
        format.json { render :show, status: :created, location: @calendar_event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(@calendar_event, partial: 'calendar_events/form',
                                                                     locals: { calendar_event: @calendar_event })
        end
        format.json { render json: @calendar_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /calendar_events/1 or /calendar_events/1.json
  def update
    authorize @calendar_event # Ensure the user is allowed to perform this action.

    respond_to do |format|
      if @calendar_event.update(calendar_event_params)
        format.html { redirect_to @calendar_event, notice: 'Calendar event was successfully updated.' }
        format.json { render :show, status: :ok, location: @calendar_event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @calendar_event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /calendar_events/1 or /calendar_events/1.json
  def destroy
    authorize @calendar_event # Ensure the user is allowed to perform this action.

    @calendar_event.destroy
    respond_to do |format|
      format.html { redirect_to calendar_events_url, notice: 'Calendar event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_calendar_event
    @calendar_event = CalendarEvent.friendly.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def calendar_event_params
    params.require(:calendar_event).permit(:user_id, :calendar_id, :name, :duration, :description, attachments: [])
  end
end
