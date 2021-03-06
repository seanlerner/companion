class Companion
  class Data
    # Class
    @initial_local_vars = [:filename, :previous_file]
    @initial_instance_vars = [:@all, :@main_window, :@tracer]
    @initial_global_vars = global_variables
    @all = []

    class << self
      attr_reader :initial_local_vars, :initial_instance_vars, :initial_global_vars, :all
      attr_accessor :current_line, :current_error, :previous_file, :current_file
    end

    def self.reset
      @all = []
      @current_error = nil
    end

    def self.all_vars
      return [] unless all[current_line]
      all[current_line].local_vars + all[current_line].instance_vars + all[current_line].global_vars
    end

    def self.vars_formatted
      all_vars.map { |var| "#{var_name(var)}: #{var_value(var)}" }.join("\n")
    end

    def self.var_name(var)
      var.first.first
    end

    def self.var_value(var)
      var.first.last
    end

    def self.current_data
      all.select { |data| data.trace_data[:lineno] == current_line }.last
    end

    def self.current_klass
      current_data.klass if current_data
    end

    def self.current_trace_data
      if current_data
        td = current_data.trace_data
        "#{td[:event]} #{td[:path]}:#{td[:lineno]} #{td[:defined_class]}##{td[:method_id]}\n#{td[:return_value] || td[:raised_exception]}"
      end
    end

    # Instance
    attr_accessor :id, :klass, :trace_data, :local_vars, :instance_vars, :global_vars

    def save
      Data.all << self
    end
  end
end
