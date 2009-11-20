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
    hash_match = var_name.match /(\S+)\[(\S+)\]/
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
