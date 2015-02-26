if Rails.env.production?
  ActionMailer::Base.default_options = {
    from: ENV['EMAIL']
  }

  if ENV['SMTP_HOST'].present?
    ActionMailer::Base.smtp_settings = {
      address: ENV['SMTP_HOST'],
      port: ENV['SMTP_PORT'],
      user_name: ENV['SMTP_USER'],
      password: ENV['SMTP_PASSWORD'],
      domain: ENV['SMTP_DOMAIN'],
      authentication: :plain
    }
    ActionMailer::Base.delivery_method = :smtp
  else
    ActionMailer::Base.delivery_method = :sendmail
  end
end
