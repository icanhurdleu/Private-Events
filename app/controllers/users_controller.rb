class UsersController < ApplicationController
	before_action :current_user, except: [:sign_in, :user_session, :new, :create]
	before_action :set_user, only: [:edit, :update, :destroy, :user_session]

	def index
		@users = User.all 
	end

	def show
		@user = User.find(params[:id])
		@upcoming_attended_events = @user.upcoming_attended_events
		@previous_attended_events = @user.previous_attended_events
	end

	def new
		@user = User.new
	end

	def edit
	end

	def create
		@user = User.new(user_params)
			if @user.save
				cookies[:user_id] = @user.id 
				redirect_to events_paths, flash: { info: 'User was successfully created' }
			else
				render :new
			end
	end

	def update
		respond_to do |format|
			if @user.update(user_params)
				format.html { redirect_to @user, info: 'User was successfully updated' }
				format.json { render :show, status: :ok, location: @user}
			else
				format.html { render :edit }
				format.json { render json: @user.errors, status: :unprocesses_entity }
			end
		end
	end

	def destroy
		@user.destroy
		respond_to do |format|
			format.html { redirect_to users_url, info: 'User was successfully deleted' }
			format.json { head :no_content }
		end
	end

	# GET /users/sign_in
	def sign_in
		@test_user_name = User.first.name 
	end

	# POST /users/sign_in/:user_id
	def user_session
		cookies[:user_id] = @user.id 
		redirect_to events_paths, flash: { info: "Welcome back #{@user.name}!" }
	end

	# DELETE /users/:id/logout
	def destroy_session!
		cookies.delete(:user_id)
		redirect_to sign_in_users_path, flash: { info: "Successfully logged out."}
	end

	private 

	def set_user
		@user = User.find_by name: params[:name]
		unless @user 
			redirect_to sign_in_users_path, flash: { warning: "User not found, please try again." }
		end
	end

	def user_params
		params.require(:user).permit(:name)
	end

end
