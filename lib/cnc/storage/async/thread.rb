# frozen_string_literal: true

# unashamedly copied from Rollbar :D
# The way threads are done there makes a lot of sense
module Cnc
  module Storage
    module Async
      class Thread
        EXIT_SIGNAL  = :exit
        EXIT_TIMEOUT = 6

        Error = Class.new(StandardError)
        TimeoutError = Class.new(Error)

        class << self
          attr_reader :reaper

          def call(client, params, options)
            spawn_threads_reaper

            thread = new.call(client, params, options)
            threads << thread
            thread
          end

          private

          def threads
            @threads ||= Queue.new
          end

          def spawn_threads_reaper
            return if @spawned

            @spawned = true

            @reaper ||= build_reaper_thread
            configure_exit_handler
          end

          def build_reaper_thread
            ::Thread.start do
              loop do
                thread = threads.pop

                break if thread == EXIT_SIGNAL

                thread.join
              end
            end
          end

          def configure_exit_handler
            at_exit do
              Timeout.timeout(EXIT_TIMEOUT) do
                threads << EXIT_SIGNAL
                reaper.join
              end
            rescue Timeout::Error
              raise TimeoutError, "unable to reap all threads within #{EXIT_TIMEOUT} seconds"
            end
          end
        end

        def call(client, params, options)
          ::Thread.new do
            client.put_object(params, options)
          rescue StandardError => e
            puts 'An error occured here'
            puts e.message
          end
        end
      end
    end
  end
end
