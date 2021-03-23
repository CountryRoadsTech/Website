# frozen_string_literal: true

class SearchController < ApplicationController
  def index
    authorize :search, :index? # Ensure the user is allowed to perform this action.

    @results = if params[:search].present?
                 PgSearch.multisearch(params[:search])
               else
                 PgSearch.multisearch('')
               end
  end
end
