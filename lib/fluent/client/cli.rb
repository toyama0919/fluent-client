#! /usr/bin/env ruby
# -*- encoding: UTF-8 -*-
require 'thor'
require 'yajl'
require 'fluent-logger'
require 'active_support/core_ext/string'
require 'fluent/log'
require 'fluent/config'
require 'fluent/engine'
require 'fluent/parser'

module Fluent
  module Client
    class CLI < Thor
      map '--post' => :post
      map '-i' => :stdin
      map '-l' => :stdin_line
      map '-j' => :post_json

      class_option :host, type: :string, default: 'localhost', aliases: '-h', desc: 'config file'
      class_option :port, type: :numeric, default: 24_224, aliases: '-p', desc: 'config file'
      def initialize(args = [], options = {}, config = {})
        super(args, options, config)
        @global_options = config[:shell].base.options
        @logger = Fluent::Logger::FluentLogger.new(nil, host: @global_options['host'], port: @global_options['port'])
        @core = Core.new
      end

      desc '--post', 'fluentd_client.rb --post sometag --data id:1 name:toyama'
      option :data, type: :hash, desc: 'config file', required: true
      option :time_key, type: :string, default: nil, desc: 'config file'
      def post(tag)
        data = options['data']
        if options['time_key'].nil?
          @logger.post(tag, data)
        else
          @logger.post_with_time(tag, options['data'], data[options['time_key']].to_time)
        end
      end

      desc '-j [tag]', %(echo '{"hoge":"fuga"}' | fluentd_client.rb -j sometag)
      def post_json(tag)
        results = parse_json(STDIN.read)
        results.each do |result|
          @logger.post(tag, result)
        end
      end

      desc '-i', 'echo -n hoge | fluentd_client.rb -i sometag'
      def stdin(tag)
        @logger.post(tag, message: STDIN.read)
      end

      desc '-l', 'cat somefile | fluentd_client.rb -l sometag'
      def stdin_line(tag)
        STDIN.read.lines.each do |line|
          @logger.post(tag, message: line)
        end
      end

      desc 'validate_parse [tag]',
           'echo "2014-01-01 localhost test" | fluentd_client.rb validate_parse --format "/^(?<log_date>\d{4}-\d{2}-\d{2}) (?<host>[^ ]*) (?<huga>[^ ]*)$/"'
      option :format, type: :string, default: nil, desc: 'format regexp', required: true
      option :time_format, type: :string, default: nil, desc: 'time format'
      option :keys, type: :string, default: nil, desc: 'time format'
      def validate_parse
        @core.parse_text(options['format'], options['time_format'], options['keys'])
      end

      desc 'post_parse_text [tag]',
           'echo "2014-01-01 localhost test" | fluent-client post_parse_text sometag --format "/^(?<log_date>\d{4}-\d{2}-\d{2}) (?<host>[^ ]*) (?<huga>[^ ]*)$/"'
      option :format, type: :string, default: nil, desc: 'format regexp', required: true
      option :time_format, type: :string, default: nil, desc: 'time format'
      option :keys, type: :string, default: nil, desc: 'time format'
      def post_parse_text(tag)
        results = @core.parse_text(options['format'], options['time_format'], options['keys'])
        results.each do |result|
          @logger.post(tag, result)
        end
      end

      private

      def parse_json(buffer)
        begin
          data = Yajl.load(buffer)
        rescue => e
          data = []
          buffer.lines.each do |line|
            data << Yajl.load(line)
          end
        end
        data.class == Array ? data : [data]
      end
    end
  end
end
