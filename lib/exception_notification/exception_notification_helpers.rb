module ExceptionNotificationHelpers

  def init_exception_notification_from_settings!
    ExceptionNotifier.notifiers.each do |notifier|
      ExceptionNotifier.unregister_exception_notifier notifier
    end

    if Setting.plugin_exception_notification['enabled'] == '1'
      recipients = []
      
      user_ids = Setting.plugin_exception_notification['users'] || []
      group_ids = Setting.plugin_exception_notification['groups']
      user_ids.concat(
        Group.where(id: group_ids).includes(:users).references(:users).select(:user).pluck(:user_id)
      )

      User.where(id: user_ids).each do |user|
        recipients << user.mail
      end

      recipients.concat Setting.plugin_exception_notification['recipients'].split(',')
  
      if recipients.present?
        ExceptionNotifier.register_exception_notifier('email', {
          email_prefix:          Setting.plugin_exception_notification['email_prefix'],
          sender_address:        Setting.plugin_exception_notification['sender_address'],
          exception_recipients:  recipients
        })
      end
    end
  end

  module_function :init_exception_notification_from_settings!

end
