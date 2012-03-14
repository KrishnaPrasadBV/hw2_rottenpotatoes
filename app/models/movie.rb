class Movie < ActiveRecord::Base
    def self.get_ratings
	ratings = ['G','PG','PG-13','R']
	return ratings
    end
end
