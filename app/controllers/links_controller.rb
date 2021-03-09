# frozen_string_literal: true

# == Schema Information
#
# Table name: links
#
#  id                   :uuid             not null, primary key
#  log_data             :jsonb
#  number_of_times_used :integer          default(0)
#  slug                 :text             not null
#  url                  :text             not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  user_id              :uuid             not null
#
# Indexes
#
#  index_links_on_slug     (slug) UNIQUE
#  index_links_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_005e9b2a6a  (user_id => users.id)
#
class LinksController < ApplicationController
  before_action :set_link, only: %i[show edit update destroy]
  before_action :skip_authorization, only: :short

  # GET /links or /links.json
  def index
    @links = Link.all
    authorize @links # Ensure the user is allowed to perform this action.
  end

  # GET /l/:slug
  def short
    @link = Link.find_by(slug: params[:slug])
    render 'public/404', status: :not_found if @link.nil?
    @link.increment!(:number_of_times_used)
    redirect_to @link.url
  end

  # GET /links/1 or /links/1.json
  def show
    authorize @link # Ensure the user is allowed to perform this action.
  end

  # GET /links/new
  def new
    @link = Link.new
    authorize @link # Ensure the user is allowed to perform this action.
  end

  # GET /links/1/edit
  def edit
    authorize @link # Ensure the user is allowed to perform this action.
  end

  # POST /links or /links.json
  def create
    @link = Link.new(link_params)
    authorize @link # Ensure the user is allowed to perform this action.
    @link.user = current_user unless current_user.nil?

    respond_to do |format|
      if @link.save
        format.html { redirect_to @link, notice: 'Link was successfully created.' }
        format.json { render :show, status: :created, location: @link }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /links/1 or /links/1.json
  def update
    authorize @link # Ensure the user is allowed to perform this action.

    respond_to do |format|
      if @link.update(link_params)
        format.html { redirect_to @link, notice: 'Link was successfully updated.' }
        format.json { render :show, status: :ok, location: @link }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /links/1 or /links/1.json
  def destroy
    @link.destroy
    authorize @link # Ensure the user is allowed to perform this action.

    respond_to do |format|
      format.html { redirect_to links_url, notice: 'Link was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_link
    @link = Link.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def link_params
    params.require(:link).permit(:user_id, :url, :slug, :number_of_times_used)
  end
end
