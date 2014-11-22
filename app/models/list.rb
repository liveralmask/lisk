class List < ActiveRecord::Base
	validates	:str, length: { minimum: 1, maximum: 255 }
	
	paginates_per	10
end
