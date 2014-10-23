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
		return redirect_to "/" if cookies[ :login_id ].nil?
		
		hash = parse_login_id( cookies[ :name ], cookies[ :login_id ] )
		
		account = Account.where( [ "account_key = ? AND login_key = ?", hash[ "account_key" ], hash[ "login_key" ] ] ).first
		if account.nil?
			cookies.delete( :login_id )
			return redirect_to "/"
		end
		
		@account = {
			:id			=> account.id,
			:icon_path	=> cookies[ :icon_path ],
			:name		=> cookies[ :name ]
		}
	end
	
protected
	def create_login_id_secret( name )
		"#{name}_#{name.size}"
	end
	
	def create_login_id( name, account_key, login_key )
		str = JSON.generate({
			:account_key		=> account_key,
			:login_key			=> login_key
		})
		secret = create_login_id_secret( name )
		ActiveSupport::MessageEncryptor.new( secret, cipher: "bf-cbc" ).encrypt_and_sign( str )
	end
	
	def parse_login_id( name, login_id )
		secret = create_login_id_secret( name )
		JSON.parse( ActiveSupport::MessageEncryptor.new( secret, cipher: "bf-cbc" ).decrypt_and_verify( login_id ) )
	end
end
