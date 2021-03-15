# frozen_string_literal: true

# == Schema Information
#
# Table name: pages
#
#  id           :uuid             not null, primary key
#  log_data     :jsonb
#  published_at :datetime
#  slug         :text             not null
#  subtitle     :text             default("")
#  title        :text             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :uuid             not null
#
# Indexes
#
#  index_pages_on_slug     (slug) UNIQUE
#  index_pages_on_title    (title) UNIQUE
#  index_pages_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_84a58494eb  (user_id => users.id)
#
class PagesController < ApplicationController
  before_action :set_page, only: %i[show edit update destroy]

  # GET /pages or /pages.json
  def index
    @pages = Page.all
    authorize @pages # Ensure the user is allowed to perform this action.
  end

  # GET /pages/1 or /pages/1.json
  def show
    authorize @page # Ensure the user is allowed to perform this action.
  end

  # GET /pages/new
  def new
    @page = Page.new
    authorize @page # Ensure the user is allowed to perform this action.
  end

  # GET /pages/1/edit
  def edit
    authorize @page # Ensure the user is allowed to perform this action.
  end

  # POST /pages or /pages.json
  def create
    @page = Page.new(page_params)
    authorize @page # Ensure the user is allowed to perform this action.
    @page.user = current_user unless current_user.nil?

    respond_to do |format|
      if @page.save
        format.html { redirect_to @page, notice: 'Page was successfully created.' }
        format.json { render :show, status: :created, location: @page }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(@page, partial: 'pages/form', locals: { page: @page })
        end
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pages/1 or /pages/1.json
  def update
    authorize @page # Ensure the user is allowed to perform this action.

    respond_to do |format|
      if @page.update(page_params)
        format.html { redirect_to @page, notice: 'Page was successfully updated.' }
        format.json { render :show, status: :ok, location: @page }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1 or /pages/1.json
  def destroy
    authorize @page # Ensure the user is allowed to perform this action.
    @page.destroy

    respond_to do |format|
      format.html { redirect_to pages_url, notice: 'Page was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_page
    @page = Page.friendly.find(params[:id])

    # If an old ID or a numeric ID was used to find the record, then the request path will not match the page's path
    # Do a 301 permanent redirect that uses the current slug.
    redirect_to @page, status: :moved_permanently if request.path != page_path(@page)
  end

  # Only allow a list of trusted parameters through.
  def page_params
    params.require(:page).permit(:user_id, :title, :subtitle, :content, :published_at)
  end
end
