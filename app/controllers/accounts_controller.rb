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
			redirect_to "/"
			return
		end
		
		redirect_to "/auth/#{provider}"
	end
	
	def create
		auth = request.env[ "omniauth.auth" ]
		
		provider = auth[ "provider" ]
		uid = auth[ "uid" ]
		name = auth[ "info" ][ "name" ]
		icon_path = auth[ "info" ][ "image" ]
		
		account_key = "#{provider}:#{uid}"
		now = Time.now.to_i
		login_key_list = [
			name,
			now,
			rand( now )
		]
		salt = login_key_list.join( "_" )
		login_key = Digest::SHA512::hexdigest( salt )
		account = Account.where( [ "account_key = ?", account_key ] ).first
		if account.nil?
			account = Account.new(
				:account_key	=> account_key,
				:login_key		=> login_key
			)
		else
			account.login_key = login_key
		end
		
		if ! account.save
			redirect_to "/"
			return
		end
		
		expires = 30.days.from_now
		cookies[ :login_key ]	= { :value => login_key, :expires => expires }
		cookies[ :name ]		= { :value => name, :expires => expires }
		cookies[ :icon_path ]	= { :value => icon_path, :expires => expires }
		
		redirect_to "/lists"
	end
end
