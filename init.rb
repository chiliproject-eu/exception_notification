Redmine::Plugin.register :exception_notification do
  name 'Exception Notification'
  author 'ChiliProject.eu'
  description 'Sends email notification to selected users, groups and email addresses when exception is raised'
  version '0.0.1'
  url 'http://www.chiliproject.eu/projects/chiliproject-eu/wiki/Exception_Notification_Plugin'
  author_url 'http://www.chiliproject.eu'

  # if settings table is not present migrations are pending or running
  if ActiveRecord::Base.connection.table_exists? 'settings'
    settings default: {
      'enabled' => '0',
      'email_prefix' => '[ERROR] ',
      'sender_address' => "Exception Notifier <#{Setting['mail_from']}>"
    }, partial: 'settings/exception_notification'
  end
end

Rails.application.config.middleware.use ExceptionNotification::Rack

ActionDispatch::Callbacks.to_prepare do
  require_dependency 'exception_notification/settings_controller_patch'
  require_dependency 'exception_notification/exception_notification_helpers'
  # if settings table is not present migrations are pending or running
  if ActiveRecord::Base.connection.table_exists? 'settings'
    ExceptionNotificationHelpers.init_exception_notification_from_settings!
  end
end
