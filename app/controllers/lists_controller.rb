class ListsController < ApplicationController
	def index
		@lists = List.where( [ "account_id = ?", 1 ] ).order( "id ASC" ).page( param_page )
		
		@page = @lists
		
		@contents[ :footer ] = true if ! @lists.empty?
	end
	
	def add
		@errmsgs = []
		begin
			break if ! params?( [ "list", "str" ] )
			
			list = List.new( :account_id => @account[ :id ], :str => params[ "list" ][ "str" ] )
			if list.save
				redirect_to "/lists#listBottom"
				return
			end
			
			@errmsgs = list.errors.messages
		end while false
	end
	
	def update
		@errmsgs = []
		begin
			if ! params.key?( "id" )
				redirect_to "/lists"
				return
			end
			
			@list = List.find_by_id( params[ "id" ] )
			
			break if ! params?( [ "list", "str" ] )
			
			@list.str = params[ "list" ][ "str" ]
			if @list.save
				redirect_to "/lists"
			end
			
			@errmsgs = @list.errors.messages
		end while false
	end
	
	def delete
		List.delete( params[ "id" ] ) if params.key?( "id" )
		
		redirect_to "/lists"
	end
end
