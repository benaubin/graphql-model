require 'active_support/core_ext/string/inflections'
require 'graphql/model/core_ext/to_query_arg'

class Array
  def to_query_string(indent: '  ', level: 0)
    total_indent = (indent * level)
    indented_line = "\n" + total_indent

    str = (level == 0) ? '{' : ' {'
    each do |part|
      str += part.to_query_string(indent: indent, level: level + 1)
    end
    str += indented_line + '}'
    str += "\n" if level == 0
    str
  end
end

class Object
  def to_query_string(indent: '  ', level: 0)
    total_indent = (indent * level)
    indented_line = "\n" + total_indent

    indented_line + to_s
  end
end

class Hash
  def to_query_string(indent: '  ', level: 0)
    "(" + map do |k, v|
      "#{k.to_s.camelize(:lower)}: #{v.to_query_arg}"
    end.join(", ") + ")"
  end
end