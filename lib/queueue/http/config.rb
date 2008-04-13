module Queueue::Http
  QUEUE_PREFIX = 'A23E9WXPHGOG29' unless defined? QUEUE_PREFIX

  config_file = 'queueue.yml'
  if File.file?(config_file)
    require "yaml"
    config = YAML.load_file(config_file)
  end

  defaults = {
    :host => '127.0.0.1',
    :port => 2323,
    :access_key_id => 'queueue',
    :secret_access_key => 'queueue',
    :log_file => 'queueue.log'
  }

  for k_sym, v in defaults
    k = k_sym.to_s
    unless const_defined? k.upcase
      val = (config[k] if config) || v
      const_set(k.upcase, val)
    end
  end
end