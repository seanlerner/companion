#!/usr/bin/env ruby
class Companion
  class << self
    attr_accessor :main_window, :logger, :file_to_watch
  end
end

require_relative 'companion/setup.rb'
