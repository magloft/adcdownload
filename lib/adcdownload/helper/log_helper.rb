module ADCDownload
  module Helper
    module LogHelper
      @@logger = nil

      def info(message)
        logger.send(:info, message)
      end
    
      def debug(message)
        logger.send(:debug, message)
      end

      def error(message)
        logger.send(:error, message)
      end

      def error!(message)
        logger.send(:fatal, message)
        Kernel.exit
      end

      def logger
        # reset logger on task change
        if @@logger.nil?
          Logging.color_scheme("bright",
            levels: { debug: :blue, info: :green, warn: :yellow, error: :red, fatal: [:white, :on_red] },
            date: :blue,
            mdc: :cyan,
            logger: :cyan,
            message: :black
          )
          Logging.appenders.stdout("stdout", layout: Logging.layouts.pattern( pattern: '[%d] %-5l %-16X{command} %x %m\n', color_scheme: 'bright' ))
          @@logger = Logging::Logger.new(self.class.name)
          @@logger.level = :info
          @@logger.add_appenders('stdout')
        end
        @@logger
      end
    end
  end
end
