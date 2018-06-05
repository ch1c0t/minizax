def h2 string
  RbNaCl::Hash.sha256 RbNaCl::Hash.sha256 "\0" * 64 + string
end
