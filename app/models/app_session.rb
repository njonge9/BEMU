class AppSession < ApplicationRecord
  belongs_to :user

  has_secure_password :token, validations: false
  before_create { self.token = self.class.generate_unique_secure_token }

  def to_h
    {
      user_id: user.id,
      app_session: id,
      token: self.token
    }
  end

  private

  def authenticate
    Current.app_session = authenticate_using_cookie
    Current.user = Current.app_session&.user
  end

  def authenticate_using_cookie
    app_session = cookies.encrypted[:app_session]
    authenticate_using app_session&.with_indifferent_access
  end

  def authenticate_string(data)
    data => { user_id:, app_session:, token: }

    user = User.find(user_id)
    user.authenticate_app_session(app_session, token)
  rescue NoMatchingPatternError, ActiveRecord::RecordNotFound
    nil
  end
end
