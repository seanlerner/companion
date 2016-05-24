class Companion
  class Teardown
    def self.execute(error_message = nil)
      Companion.main_window.close
      if error_message
        message = "Companion Stopping: #{error_message}".red
        puts message
        Companion.logger.debug message
      else
        puts 'Goodbye.'
        Companion.logger.debug 'Companion Stopping.'.green
      end
      exit
    end
  end
end
