require 'active_support/json'
require 'active_support/core_ext/object/json'
require 'active_support/core_ext/string/inflections'

class String
  def to_query_arg
    to_json
  end
end

class Integer
  def to_query_arg
    to_json
  end
end

class Float
  def to_query_arg
    to_json
  end
end

class TrueClass
  def to_query_arg
    to_json
  end
end

class FalseClass
  def to_query_arg
    to_json
  end
end

# ruby doesn't have enums, the closest things are symbols
class Symbol
  def to_query_arg
    str = to_s
    if str =~ /(.+)!$/
      $1
    else
      str.camelize(:lower)
    end
  end
end

class NilClass
  def to_query_arg
    to_json
  end
end

class Array
  def to_query_arg
    "[" + map(&:to_query_arg).join(", ") + "]"
  end
end

class Hash
  def to_query_arg
    "{" + map do |k, v|
      key = k.to_s.camelize(:lower)

      s = key.include?(" ") ? key.to_json : key.camelize(:lower)
      s + ": " + v.to_query_arg
    end.join(", ") + "}"
  end
end