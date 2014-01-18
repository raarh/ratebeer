class RatingsController < ApplicationController
  #before_action :set_ratings, only: [:show, :edit, :update, :destroy]
  def index
    @ratings = Rating.all
  end
  def show
  end
  def new
    @rating = Rating.new
    @beers = Beer.all
  end
  def edit
  end
  def create
    Rating.create params.require(:rating).permit(:score, :beer_id)
    redirect_to ratings_path
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_ratings
    @ratings = Rating.find(params[:id])
  end

end
