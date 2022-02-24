class Movie < ActiveRecord::Base
    def self.get_ratings
        ratings =[]
        Movie.all.each do |movie|
            ratings.append(movie["rating"])
        end
        ratings.uniq.sort
    end
    
    def self.with_ratings(ratings)
        Movie.where(rating: ratings)
    end
        
end