class AccountsController < ApplicationController
	def index
	end
	
	def login_account
	end
	
	def login
		provider = params[ :provider ]
		case provider
		when "twitter"
		else
			return redirect_to "/"
		end
		
		return redirect_to "/auth/#{provider}"
	end
	
	def create
		auth = request.env[ "omniauth.auth" ]
		
		provider = auth[ "provider" ]
		uid = auth[ "uid" ]
		name = auth[ "info" ][ "name" ]
		icon_path = auth[ "info" ][ "image" ]
		
		account_key = "#{provider}:#{uid}"
		login_key = create_login_key( name )
		account = Account.where( [ "account_key = ?", account_key ] ).first
		if account.nil?
			account = Account.new(
				:account_key	=> account_key,
				:login_key		=> login_key
			)
		else
			account.login_key = login_key
		end
		
		return redirect_to "/" if ! account.save
		
		expires = 30.days.from_now
		cookies[ :login_id ]	= { :value => create_login_id( name, account_key, login_key ), :expires => expires }
		cookies[ :name ]		= { :value => name, :expires => expires }
		cookies[ :icon_path ]	= { :value => icon_path, :expires => expires }
		
		return redirect_to "/lists"
	end
	
protected
	def create_login_key( name )
		now = Time.now.to_i
		salt = [
			name,
			now,
			rand( now )
		].join( "_" )
		Digest::SHA512::hexdigest( salt )
	end
end
