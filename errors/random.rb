# Copyright (c) 2015 Vault12, Inc.
# MIT License https://opensource.org/licenses/MIT
module Errors
  class SevereRandomError < ZAXError
    def http_fail
      @response_code = :internal_server_error
      super
      severe_error 'NaCl error - random(32)'
    end
  end
end
