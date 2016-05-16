class Companion::Frame
  # Class
  @all = []
  @screen_height = IO.console.winsize.first
  @screen_width = IO.console.winsize.last

  class << self
    attr_accessor :all, :screen_width, :screen_height

    def setup
      new(name: :time, title: '', right: 0,   data_width: time_width,
          data: -> { Time.now.strftime('%H:%M:%S') })
      new(name: :class, top: 1,
          data: -> { Companion::Data })
      new(name: :current_error, data_width: screen_width - current_error_title_and_time_width,
          data: -> { Companion::Data.current_error })
      new(name: :trace_data, top: 2, height: third_of_screen,
          data: -> { Companion::Data.trace_data })
      new(name: :variables, top: :next, height: third_of_screen,
          data: -> { Companion::Data.vars_formatted })
      new(name: :program_output, top: :next, height: third_of_screen,
          data: -> { $stdout.string })
    end

    def find(name)
      all.find { |frame| frame.name == name }
    end

    def update
      all.each(&:update)
    end

    def last
      all[all.count - 1]
    end

    def third_of_screen
      screen_height / 3 - 2
    end

    def current_error_title_and_time_width
      'Current Error: '.length + time_width
    end

    def time_width
      8
    end
  end

  # Instance
  attr_accessor :name, :title, :data, :data_width, :height, :width, :top, :left, :title_win, :data_win

  def initialize(args)
    @name = args[:name]
    @title = setup_title(args)
    @data_width = args[:data_width] || Companion::Frame.screen_width - title.length
    @data = args[:data] || setup_data
    @height = args[:height] || 1
    @width = args[:width] || width_from_title_and_data
    @top = setup_top(args)
    @left = args[:left] || setup_left(args)
    setup_title_win
    setup_data_win
  end

  def update
    data_win.clear
    data_win.addstr(obtain_data.to_s)
    data_win.refresh
  end

  private

  def setup_title(args)
    title_arg = args[:title]
    if title_arg
      !title_arg.empty? ? "#{title_arg}: " : ''
    else
      "#{name.to_s.titleize.tr('_', ' ')}: "
    end
  end

  def width_from_title_and_data
    height == 1 ? (title.length + data_width) : Companion::Frame.screen_width
  end

  def setup_top(args)
    if args[:top].class == Fixnum
      args[:top]
    elsif args[:top] == :next
      frame_above = Companion::Frame.last
      frame_above.top + frame_above.height + 2
    else
      0
    end
  end

  def setup_left(args)
    args[:right] ? Companion::Frame.screen_width - width - args[:right] : 0
  end

  def setup_title_win
    title_win = Companion.main_window.subwin(1, title.length, top, left)
    title_win.addstr(title)
    title_win.refresh
  end

  def setup_data_win
    @data_win = Companion.main_window.subwin(data_height, data_width, data_top, data_left)
    Companion::Frame.all << self
  end

  def setup_data
    waiting_for_data_msg = 'waiting for data'
    data_width >= waiting_for_data_msg.length ? waiting_for_data_msg : 0
  end

  def data_height
    height == 1 ? 1 : height - 1
  end

  def data_top
    height == 1 ? top : top + 1
  end

  def data_left
    height == 1 ? left + title.length : left
  end

  def obtain_data
    data.respond_to?(:call) ? data.call : data
  end
end
