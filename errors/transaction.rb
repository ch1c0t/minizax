module Errors
  class TransactionError < ZAXError
    def http_fail
      @response_code = :internal_server_error
      warn "#{INFO_NEG} Redis transaction error, hpk #{MAGENTA}#{dumpHex @data[:hpk]}#{ENDCLR}"
      super
    end
  end
end
