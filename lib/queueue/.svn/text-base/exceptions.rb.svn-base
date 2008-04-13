module Queueue
  %w(
    InvalidParameterValue
    NonEmptyQueue
    NonExistentQueue
    MissingParameter
    MessageNotFound
  ).each {|e| module_eval "class #{e} < Exception; end"}
end