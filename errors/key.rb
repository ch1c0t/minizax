# Copyright (c) 2015 Vault12, Inc.
# MIT License https://opensource.org/licenses/MIT
module Errors
  class SevereKeyError < ZAXError
    def http_fail
      super
      severe_error 'NaCl key generation error'
    end
  end
end
