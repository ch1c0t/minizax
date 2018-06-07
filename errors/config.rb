# Copyright (c) 2015 Vault12, Inc.
# MIT License https://opensource.org/licenses/MIT
module Errors
  class ConfigError < ZAXError
    def http_fail
      return unless @controller
      super
      severe_error 'Configuration error'
    end
  end
end
