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
    if @sort == nil and @ratings == nil and commit != 'Refresh'
	if session[:sort] != nil and session[:ratings] != nil
		redirect_to movies_path(:sort => session[:sort],:ratings => session[:ratings])
	elsif session[:sort] == nil and session[:ratings] != nil
		redirect_to movies_path(:sort => session[:sort],:ratings => session[:ratings])
	elsif session[:sort] != nil and session[:ratings] == nil
		redirect_to movies_path(:sort => session[:sort])
	end
    end
    if @ratings == nil and commit != 'Refresh'
	@ratings = session[:ratings]
    end
    if @sort == nil
	@sort = session[:sort]
    end
    if commit == 'Refresh' and @ratings != nil
	session[:ratings] = @ratings
	if @sort == nil
            @movies = Movie.where(:rating => @ratings.keys)
	elsif @sort == "title"
	    @movies = Movie.where(:rating => @ratings.keys).order("title")
	elsif @sort == "date"
	    @movies = Movie.where(:rating => @ratings.keys).order("release_date")
	end
	return
    end
    if commit == 'Refresh' and @ratings == nil
	if @sort == nil
            @movies = Movie.find(:all)
	elsif @sort == "title"
	    @movies = Movie.find(:all,:order => "title")
	elsif @sort == "date"
	    @movies = Movie.find(:all,:order => "release_date")
	end
	session[:ratings] = nil
	return
    end
    if @sort == "title" and @ratings != nil
	@movies = Movie.where(:rating => @ratings.keys).order("title")
	session[:sort] = "title"
	session[:ratings] = @ratings
    elsif @sort == "title" and @ratings == nil
	if (session[:ratings] == nil)
		@movies = Movie.find(:all,:order => "title")
		session[:sort] = "title"
	else
		@movies = Movie.where(:rating => session[:ratings].keys).order("title")
		session[:sort] = "title"
		@ratings = session[:ratings]
	end
    elsif @sort == "date" and @ratings != nil
	@movies = Movie.where(:rating => @ratings.keys).order("release_date")
	session[:sort] = "date"
	session[:ratings] = @ratings	
    elsif @sort == "date" and @ratings == nil
	if (session[:ratings] == nil)
		@movies = Movie.find(:all,:order => "release_date")
		session[:sort] = "date"
	else
		@movies = Movie.where(:rating => session[:ratings].keys).order("release_date")
		session[:sort] = "date"
		@ratings = session[:ratings]
	end
    elsif @sort == nil and @ratings != nil
	@movies = Movie.where(:rating => @ratings.keys)
    else
	if (session[:sort] != nil and session[:ratings] == nil)
		redirect_to movies_path(:sort => session[:sort])
	elsif (session[:sort] == nil and session[:ratings] != nil)
		redirect_to movies_path(:ratings => session[:ratings])
	elsif (session[:sort] != nil and session[:ratings] != nil)
		redirect_to movies_path(:sort => session[:sort],:ratings => session[:ratings])
	else
    		@movies = Movie.all
		session[:sort] = nil
		session[:ratings] = nil
	end
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
