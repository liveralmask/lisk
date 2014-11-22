class ListsController < ApplicationController
	def index
		lists = List.where( [ "account_id = ?", @account[ :id ] ] ).order( "id ASC" )
		@lists = lists.page( param_page( lists.page.num_pages ) )
		return redirect_to "/lists/add" if @lists.empty?
		
		@page = @lists
		@contents[ :footer ] = true if ! @lists.empty?
	end
	
	def add
		@errmsgs = []
		begin
			break if ! params?( [ "list", "str" ] )
			
			list = List.new( :account_id => @account[ :id ], :str => params[ "list" ][ "str" ] )
			return redirect_to "/lists?page=0#bottom" if list.save
			
			@errmsgs = list.errors.messages
		end while false
	end
	
	def update
		@errmsgs = []
		begin
			return redirect_to "/lists" if ! params.key?( "id" )
			
			@list = List.find_by_id( params[ "id" ] )
			@back_page = params[ "page" ].to_i
			
			break if ! params?( [ "list", "str" ] )
			
			@list.str = params[ "list" ][ "str" ]
			return redirect_to "/lists?page=#{@back_page}#id_#{@list.id}" if @list.save
			
			@errmsgs = @list.errors.messages
		end while false
	end
	
	def delete
		List.delete( params[ "id" ] ) if params.key?( "id" )
		
		back_page = params[ "page" ].to_i
		return redirect_to "/lists?page=#{back_page}"
	end
end
