class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception
	
	helper_method		:br
	
	before_filter		:login_account
	
	def initialize
		super
		
		@contents = {
			:header	=> true,
			:footer => false,
			:info	=> "shared/info"
		}
		
		@page = nil
		
		# TEST
#		@account = { :id => 1, :icon_path => "https://www.google.com/images/google_favicon_128.png", :name => "テスト" }
	end
	
	def br( str )
		str.gsub( /\r\n|\r|\n/, "<br />" )
	end
	
	def params?( keys )
		hash = params
		keys.each{|key|
			return false if ! hash.key?( key )
			
			hash = hash[ key ]
		}
		return true
	end
	
	def param( key, default_value )
		return default_value if ! params.key?( key )
		
		params[ key ]
	end
	
	def param_page
		page = param( "page", 1 )
	end
	
	def login_account
		if cookies[ :login_key ].nil?
			redirect_to "/"
			return
		end
		
		account = Account.where( [ "login_key = ?", cookies[ :login_key ] ] ).first
		if account.nil?
			cookies.delete( :login_key )
			redirect_to "/"
			return
		end
		
		@account = {
			:id			=> account.id,
			:icon_path	=> cookies[ :icon_path ],
			:name		=> cookies[ :name ]
		}
	end
end
