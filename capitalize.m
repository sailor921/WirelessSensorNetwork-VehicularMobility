function [str] = capitalize(str)
%CAPITALIZE Capitalize each word in a sentence
%   This function is used to capitalize each word passed into it. It
%   receives only type 'str' and it returns type 'str'.

str=lower(str);
expression = '(^|[\. ])\s*.';
replace = '${upper($0)}';
str = regexprep(str,expression,replace);

end

