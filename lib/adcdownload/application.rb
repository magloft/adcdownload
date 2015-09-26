module ADCDownload
  class Application
    include Commander::Methods
    
    def run
      program :version, ADCDownload::VERSION
      program :description, 'Apple Developer Center Downloader'
      program :help, 'Author', 'Tobias Strebitzer <tobias.strebitzer@magloft.com>'
      program :help, 'Website', 'http://www.magloft.com'
      program :help_formatter, Commander::HelpFormatter::TerminalCompact
      global_option '-x', '--verbose' do
        logger.level = :debug
      end
      global_option '--verbosity LEVEL', 'Specify verbosity level (*info*, debug, warn, error)' do |verbosity|
        verbosity = "info" if !["info", "debug", "warn", "error"].include?(verbosity.to_s)
        logger.level = verbosity.to_sym
      end
      global_option '--production'
      default_command :help
      
      logger.level = ENV["LOG_LEVEL"].to_sym if ENV["LOG_LEVEL"]
      
      ADCDownload::Command::Get.new.run
      
      # allow colons
      ARGV[0] = ARGV[0].gsub(":", "-") if ARGV[0]
      
      # merge first two commands
      if ARGV.length > 1 and defined_commands.keys.include?("#{ARGV[0]}-#{ARGV[1]}")
        ARGV[0] = "#{ARGV[0]}-#{ARGV[1]}"
        ARGV.slice!(1)
      end
      
      run!
    end
    
  end
end
