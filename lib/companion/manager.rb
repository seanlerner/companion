class Companion::Manager
  class << self
    def update_program_output(filename)
      previous_file = Companion::Data.current_file
      Companion::Data.current_file = File.read(filename)
      Companion::Data.reset
      Companion::Data.current_line = line_numer_of_first_modified_line(previous_file, Companion::Data.current_file)
      $stdout = StringIO.new
      begin
        @tracer.trace_point.enable
        load filename
        @tracer.trace_point.disable
      rescue Exception => error
        @tracer.trace_point.disable
        Companion::Data.current_error = error
        Companion.logger.debug "Program raised error: #{error}".red
      end
      Companion::Frame.update
      $stdout.close
    end

    def line_numer_of_first_modified_line(previous_file, current_file)
      file = new_file_diffed_as_separate_lines(new_file_diffed(previous_file, current_file))
      file ? first_diffed_line_of_new_file_diffed(file) + 1 : no_line_number
    end

    def new_file_diffed(previous_file, current_file)
      Diffy::SplitDiff.new(previous_file, current_file).right
    end

    def new_file_diffed_as_separate_lines(file)
      file.split("\n")
    end

    def first_diffed_line_of_new_file_diffed(file)
      file.find_index { |line| line[0] =~ /\-|\+/ } || no_line_number
    end

     def no_line_number
      -1
    end

  end

  @tracer = Companion::Tracer.new

  update_program_output Companion.file_to_watch
  FileWatcher.new(Companion.file_to_watch).watch do |file_to_watch|
    Companion.logger.debug 'File changed.'
    update_program_output(file_to_watch)
  end
end