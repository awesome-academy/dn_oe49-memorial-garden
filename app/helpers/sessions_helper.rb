module SessionsHelper
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t("flash.login.warning_user")
    redirect_to login_url
  end

  def log_in user
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find_by id: session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def current_user? user
    user == current_user
  end

  def redirect_back_or default
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  def correct_user user
    return if current_user?(user)

    flash[:danger] = t("flash.edit.wrong_user")
    redirect_to(root_url)
  end

  def correct_member
    return if @memorial.share? current_user

    flash[:danger] = t("flash.edit.wrong_user")
    redirect_to(root_url)
  end
end
