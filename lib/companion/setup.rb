class Companion
  class Setup
    Thread.abort_on_exception = true
    Companion.main_window = Curses::Window.new(0, 0, 0, 0)

    def self.run
      setup_logger
      setup_initial_file
      Frame.setup
      setup_timer
      Curses.curs_set(0) # hide cursor on screen
      Companion::Manager.run
    end

    def self.setup_logger
      Dir.mkdir 'logs' unless Dir.exist? 'logs'
      Companion.logger = Logger.new('logs/companion.log')
      Companion.logger.level = Logger::DEBUG
      Companion.logger.info('Companion started.'.green)
    end

    def self.setup_initial_file
      file_to_watch = ARGV.first
      if file_to_watch
        Companion.file_to_watch = file_to_watch
      else
        Teardown.execute("#{'Please enter filename to monitor. (i.e. '.red}#{'companion your_app_name.rb'.yellow}#{')'.red}")
      end
    end

    def self.setup_timer
      Thread.new do
        loop do
          Frame.find(:time).update
          sleep 1
        end
      end
    end
  end
end
