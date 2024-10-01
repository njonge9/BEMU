module Authenticate
    extend ActiveSupport::Concern

    included do
        before_action :authenticate
        before_action :require_login, unless: :logged_in?

        helper_method :logged_in?
    end

    protected

    def logged_in?
        Current.user.present?
    end
    
    def log_in(app_session)
        cookies.encrypted.permanent[:app_session] = {
            value: app_session.to_h
        }
    end

    private

    def require-login
        flash.now[:notice] = t("login_required")

        render "sessions/new", status: :unauthorized
    end
end