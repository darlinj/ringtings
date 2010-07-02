# Allow storage of variables between steps
def feature_vars
  @feature_vars
end

# Interpolate the values of variables stored in _feature_vars_, which are given
# in angle brackets, eg "foo<bar>" => "foo#{feature_vars['bar']}"
# Supports storing a hash as a value in _feature_vars, for example
# "foo<bar[wibble]>" => "foo#{feature_vars[bar][wibble]}"
# 
# Also allows evaluation of code in braces, eg "{2+2}" => "4".
# 
# TODO: tidy this up a bit.
def interpolate_vars str
  return nil unless str
  result = str.gsub(/<.*?>/) do |match|
    var_name = match.gsub(/[<>]/, '')
    hash_match = var_name.match(/(\S+)\[(\S+)\]/)
    if hash_match
      name = hash_match.to_a[1]
      value = hash_match.to_a[2]
      feature_vars[name][value]
    else
      feature_vars[var_name]
    end
  end
    
  result.gsub!(/\{.*?\}/) do |match|
    eval(match.gsub(/[{}]/, ''))
  end
  return result
end

# Returns an array of the contents (ie text of an element or the
# value of an attribute) of each element matching the specified path
def xml_node_values xml, xpath, strip=false
  begin
    doc = REXML::Document.new(xml).root
    REXML::XPath.match(doc, xpath).map do |node|
      if strip
        (node.respond_to?(:value) ? node.value.strip : node.text.strip)
      else
        (node.respond_to?(:value) ? node.value : node.text)
      end
    end
  rescue
    raise "No #{xpath} found in response body (#{xml})"
  end
end



# Returns the contents (ie text of an element or the
# value of an attribute) of the element specified. Returns nil if there are
# multiple matches.
def xml_node_value xml, xpath
  matches = xml_node_values xml, xpath
  matches.size == 1 ? matches.first : nil
end

# Returns the contents (ie text of an element or the
# value of an attribute) of the element specified. Returns the last
# entry if there are multiple matches.
def last_xml_node_value xml, xpath
 matches = xml_node_values xml, xpath
 matches.size == 1 ? matches.first : matches.last
end
