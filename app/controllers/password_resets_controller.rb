class PasswordResetsController < ApplicationController

  before_action :authorize, only: [:edit, :update]
  before_action :not_authorized, only: [:change, :reset, :new, :create]

  public

    def edit
      @user = current_user
      render layout: 'side_bar_logged_in_user_general'
    end # end edit action

    def change
      @user = User.find_by_password_reset_token!(params[:id])

      if @user.password_reset_sent_at < 2.hours.ago
        #flash[:warning] = t('reset_password_link_expired_label')
        redirect_to new_password_reset_path
      end
    end # end change action

    def new
    end # end new action

    def update
      @user = current_user

      if params[:user][:password].to_s != params[:user][:password_confirmation].to_s
        #flash.now[:warning] = t('reset_password_passwords_dont_match_label')
        render :edit
      elsif !User.authenticate(@user.username, params[:user][:old_password])
        #flash.now[:warning] = t('reset_password_old_password_incorrect_label')
        render :edit
      elsif @user.change_password(params[:user][:password])
        #flash[:notice] = t('user_data_successfully_updated_label')
        redirect_to @user
      else
        #flash.now[:warning] = t('error_please_retry_label')
        render :edit
      end
    end # end update action

    def create
      if params[:email].empty?
        #flash.now[:warning] = t('password_reset_email_empty_label')
        render 'new'
      else
        user = User.where("lower(email) = ?", params[:email].downcase).first

        user.send_password_reset if user
        redirect_to root_url, notice: t('reset_password_success_email_sent_label')
      end
    end # end create action

    def reset
      @user = User.find_by_password_reset_token!(params[:id])
      if @user.password_reset_sent_at < 2.hours.ago
        #flash[:warning] = t('reset_password_link_expired_label')
        redirect_to new_password_reset_path
      elsif params[:user][:password] != params[:user][:password_confirmation]
        #flash.now[:warning] = t('reset_password_passwords_dont_match_label')
        render :change
      elsif @user.change_password(params[:user][:password])
        login_user(@user)
        #flash[:notice] = t("reset_password_success_reset_label")
        redirect_to users_path
      else
        #flash.now[:warning] = t('error_please_retry_label')
        render :change
      end
    end # end reset action

end # end PasswordResetsController class
