require_relative 'requires'

class Companion::Setup
  Thread.abort_on_exception = true
  Companion.main_window = Curses::Window.new(0, 0, 0, 0)

  class << self
    def setup_logger
      Companion.logger = Logger.new('logs/companion.log')
      Companion.logger.level = Logger::DEBUG
      Companion.logger.info('Companion started.'.green)
    end

    def setup_timer
      Thread.new do
        loop do
          Companion::Frame.find(:time).update
          sleep 1
        end
      end
    end

    def setup_initial_file
      file_to_watch = ARGV.first
      file_to_watch ? Companion.file_to_watch = file_to_watch : Companion::Teardown.execute("#{'Please enter filename to monitor. (i.e. '.red}#{'companion your_app_name.rb'.yellow}#{')'.red}")
    end
  end

  setup_logger
  setup_initial_file
  Companion::Frame.setup
  setup_timer
  Curses.curs_set(0)
  require_relative 'manager'
end
