class ListsController < ApplicationController
	def index
		@lists = List.where( [ "account_id = ?", @account[ :id ] ] ).order( "id ASC" ).page( param_page )
		return redirect_to "/lists/add" if @lists.empty?
		
		@page = @lists
		
		@contents[ :footer ] = true if ! @lists.empty?
	end
	
	def add
		@errmsgs = []
		begin
			break if ! params?( [ "list", "str" ] )
			
			list = List.new( :account_id => @account[ :id ], :str => params[ "list" ][ "str" ] )
			return redirect_to "/lists#listBottom" if list.save
			
			@errmsgs = list.errors.messages
		end while false
	end
	
	def update
		@errmsgs = []
		begin
			return redirect_to "/lists" if ! params.key?( "id" )
			
			@list = List.find_by_id( params[ "id" ] )
			
			break if ! params?( [ "list", "str" ] )
			
			@list.str = params[ "list" ][ "str" ]
			return redirect_to "/lists" if @list.save
			
			@errmsgs = @list.errors.messages
		end while false
	end
	
	def delete
		List.delete( params[ "id" ] ) if params.key?( "id" )
		
		return redirect_to "/lists"
	end
end
