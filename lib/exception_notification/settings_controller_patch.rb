require_dependency 'settings_controller'

module SettingsControllerPatch

  def self.included(base)
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
    
    base.class_eval do
      def plugin_with_exception_notification
        plugin_without_exception_notification
        if request.post? && params[:id] == 'exception_notification'
          ExceptionNotificationHelpers.init_exception_notification_from_settings!
        end
      end
      alias_method_chain :plugin, :exception_notification
    end
  end

  module ClassMethods
  end

  module InstanceMethods
  end    

end

SettingsController.send(:include, SettingsControllerPatch)
