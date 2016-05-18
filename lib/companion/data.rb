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

      def reset
        @all = []
        @current_error = nil
      end

      def all_vars
        return [] unless all[current_line]
        all[current_line].local_vars + all[current_line].instance_vars + all[current_line].global_vars
      end

      def vars_formatted
        all_vars.map { |var| "#{var_name(var)}: #{var_value(var)}" }.join("\n")
      end

      def var_name(var)
        var.first.first
      end

      def var_value(var)
        var.first.last
      end

      def trace_data
        if current_line_trace_data
          td = current_line_trace_data.trace_data
          "#{td[:event]} #{td[:path]}:#{td[:lineno]} #{td[:defined_class]}##{td[:method_id]}\n#{td[:return_value] || td[:raised_exception]} AND #{td[:receiver]}"
        end
      end

      def current_line_klass
        all.select { |data| data.trace_data[:lineno] == current_line }.last
      end

      def current_line_trace_data
        all.select { |data| data.trace_data[:lineno] == current_line }.last
      end
    end

    # Instance
    attr_accessor :id, :klass, :trace_data, :local_vars, :instance_vars, :global_vars

    def save
      Data.all << self
    end
  end
end
