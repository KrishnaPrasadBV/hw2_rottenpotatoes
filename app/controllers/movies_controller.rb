class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.get_ratings()
    @sort = params[:sort]
    commit = params[:commit]
    @ratings = (params[:ratings])
    if commit == 'Refresh' and @ratings != nil
	@movies = Movie.where(:rating => @ratings.keys)
	return
    end
    if @sort == "title" and @ratings != nil
	@movies = Movie.where(:rating => @ratings.keys).order("title")
    elsif @sort == "title" and @ratings == nil
	@movies = Movie.find(:all,:order => "title")
    elsif @sort == "date" and @ratings != nil
	@movies = Movie.where(:rating => @ratings.keys).order("release_date")	
    elsif @sort == "date" and @ratings == nil
	@movies = Movie.find(:all,:order => "release_date")
    else
    	@movies = Movie.all
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
