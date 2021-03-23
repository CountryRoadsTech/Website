class SearchController < ApplicationController
  def index
    @results = PgSearch.multisearch(params[:search]) if params[:search].present?
  end
end
