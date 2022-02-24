class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      @all_ratings = Movie.get_ratings
      @checked = @all_ratings
      selected_ratings = @all_ratings
      id = params[:id]
      
      if params[:ratings]
        selected_ratings = params[:ratings].keys
        @checked = selected_ratings
        session[:ratings] = params[:ratings]
      elsif session[:ratings]
        flash.keep
        redirect_to action: :index, ratings: session[:ratings], id: id and return
      end
      
      if id == "title_header"
        session[:id] = id
        @movies = Movie.with_ratings(selected_ratings).order("title")
        @title_header_class = "hilite bg-warning"
        @release_date_header_class = ""
      elsif id == "release_date_header"
        session[:id] = id
        @movies = Movie.with_ratings(selected_ratings).order("release_date")
        @sort_column = id
        @title_header_class = ""
        @release_date_header_class = "hilite bg-warning"
      elsif session[:id]
        flash.keep
        redirect_to action: :index, ratings: session[:ratings], id: session[:id] and return
      else
        @movies = Movie.with_ratings(selected_ratings)
        @title_header_class = ""
        @release_date_header_class = ""
      end
    end
    
    def new
      # default: render 'new' template
    end
  
    def create
      @movie = Movie.create!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movies_path
    end
  
    def edit
      @movie = Movie.find params[:id]
    end
  
    def update
      @movie = Movie.find params[:id]
      @movie.update_attributes!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully updated."
      redirect_to movie_path(@movie)
    end
    
    def destroy
      @movie = Movie.find(params[:id])
      @movie.destroy
      flash[:notice] = "Movie '#{@movie.title}' deleted."
      redirect_to movies_path
    end
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
end