require "net/imap"
require "fileutils"
require "yaml"

module Mair
  class Gmail
    def initialize
      @imap = Net::IMAP.new("imap.gmail.com", 993, true)
      @logined = false
    end

    def login
      result = imap.login(config[:user], config[:pass])
      @logined = true if result && result.name == "OK"
    end

    def logined?
      @logined = !imap.disconnected?
    end

    def mailboxes
      imap.list("", "*").each {|box| puts box.name}
    end

    def select(box)
      imap.select(box)
    end

    private

      def config
        @config ||= YAML.safe_load(File.read(File.expand_path("~/.mair/config.yml")), symbolize_names: true)[:gmail]
      end

      def imap
        @imap
      end
  end
end
