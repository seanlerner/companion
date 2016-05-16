class Companion::Tracer
  attr_accessor :trace_point
  attr_reader :tp_binding, :trace_data

  def initialize
    @trace_point = TracePoint.new do |tp|
      tp.disable
      unless [Companion::Manager, Companion::Data].include? tp.binding.receiver
        @trace_data = tp
        @tp_binding = tp.binding
        capture_data
      end
      tp.enable
    end
  end

  private

  def capture_data
    tpb = @tp_binding
    data = Companion::Data.new
    data.trace_data = extract_trace_data
    data.local_vars = extract_local_vars
    data.instance_vars = extract_instance_vars
    data.global_vars = extract_global_vars
    data.save
  end

  def extract_trace_data
    {
      receiver: trace_data.binding.receiver,
      defined_class: trace_data.defined_class,
      event: trace_data.event,
      lineno: trace_data.lineno,
      method_id: trace_data.method_id,
      path: trace_data.path,
      raised_exception: (trace_data.raised_exception if trace_data.event == :raise),
      return_value: (trace_data.return_value if [:return, :b_return, :c_return].include? trace_data.event)
    }
  end

  def extract_local_vars
    (tp_binding.local_variables - Companion::Data.initial_local_vars).map { |var| { var => tp_binding.local_variable_get(var) } }
  end

  def extract_instance_vars
    (tp_binding.eval('instance_variables') - Companion::Data.initial_instance_vars).map { |var| { var => tp_binding.eval('self').instance_variable_get(var) } }
  end

  def extract_global_vars
    (tp_binding.eval('global_variables') - Companion::Data.initial_global_vars).map { |var| { var => eval(var.to_s) } }
  end
end
