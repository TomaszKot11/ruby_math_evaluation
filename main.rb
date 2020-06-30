FLOATING_POINT_REGEXP_MINUS = /([-]?(?:0|[1-9]\d*)(?:\.(?:\d*[1-9]|0))?)/
FLOATING_POINT_REGEXP = /((?:0|[1-9]\d*)(?:\.(?:\d*[1-9]|0))?)/

 def numeric?(char)
    char =~ /[[:digit:]]/
end
  
def accepted_arithmetic_exp?(char)
    char =~ /[*+-\/]/
end

  def evaluate_stack(operator_stack, value_stack, op: nil)
    op = operator_stack.pop() unless op

    arg1 = value_stack.pop().to_f
    arg2 = value_stack.pop().to_f
    # check if operator is in *- /- then we have to first negate the second operator
    if op =~ /[*\/+-]-/
        arg1 *= (-1)
        op = op[0]
    end
  
    result = arg2.public_send(op, arg1)

    2.times { p '******' }
    p "Operation: #{arg2} #{op} #{arg1}"
    p operator_stack
    p value_stack
    2.times { p '*******' }
    
    value_stack.push(result)
  end
  
  def evaluate_stack_till_right_bracket(operator_stack, value_stack)
    op = operator_stack.pop()
    p 'evaluate_stack_till_right_bracket'
    p operator_stack
    p op
    p value_stack
    p 'evaluate_stack_till_right_bracket'
    while op != '('
      p 'while'
      evaluate_stack(operator_stack, value_stack, op: op)
      op = operator_stack.pop()
    end
 end
  
#   def parse_input!(exp)
#     # replace whitespaces
#     exp.gsub!(/\s+/, '')
#     regexp = exp.scan(/-\s*-|[*+-\/]-/).empty?  ? FLOATING_POINT_REGEXP : FLOATING_POINT_REGEXP_MINUS
#     # extract each float and use to_f
#     floating_point_num = exp.scan(regexp)
#     floating_point_num.map! { |el| el.first.to_f }
#     # parse constructions in *- style
#     helper = []
#     exp.scan(/[*+-\/]-/) do |c|
#         helper << [c, $~.offset(0)[0]]
#     end
#     helper.each do |el|
#         exp.slice!(el[1] + 1)
#     end
#     # replace double -- signs
#     exp.gsub!(/-{2}/, '-')
#     # scan for operators
#     operators = []
#     exp.scan(/[-\/*+()]/) do |c|
#       operators << [c, $~.offset(0)[0]]
#     end

#     operators.each do |el| 
#       floating_point_num.insert(el[1], el[0])
#     end

#     floating_point_num
#   end

def parse_input!(exp)
    s = exp
    new_string = s.gsub(" ", "").split(/(\d+\.?\d*)/).reject(&:empty?)
    # indices = new_string.each_index.select { |el| new_string[el] =~ /^[*+-\/]\(-$/ }

    # p 'new_strign'
    # p new_string
    # p 'new_string'
    # # correct constructions in \(- next_number ... form
    # indices.each do |idx|
    #   p 'correcting'
    #   temp = new_string[idx]
    #   next_num = new_string[idx+1]
    #   new_string[idx] = "#{temp[0]}"
    #   new_string.insert(idx+1, "#{temp[1]}")
    #   new_string[idx+2] = "#{temp[2]}#{next_num}"
    #   # new_string[idx+2] = "#{temp[2]}#{temp[idx+2]}"
    #   # new_string.insert(idx+1, "#{new_string[2]}#{new_string[idx+1]}")
    # end

    # # correct constructions in style /-(-...
    # indices = new_string.each_index.select { |el| new_string[el] =~ /^[*+-\/]\(-$/ }


   
    new_str_arr = new_string.map { |str| str.split(/([\(\)])/) }.flatten.reject(&:empty?)
    # correct double -- signs

    # correct negations
    arr_length = new_str_arr.length - 3
    i = 0 
    while i < arr_length do 
      frist_el = new_str_arr[i]
      second_el = new_str_arr[i+1]
      third_el = new_str_arr[i+2]

      p "Checking: #{frist_el} #{second_el} #{third_el}"

      # e.g "(", "-", "5" -> "(", "-5"
      if !numeric?(frist_el) && second_el == '-' && numeric?(third_el)
        p 'correcting now'
        new_str_arr[i+1] = "#{second_el}#{third_el}"
        new_str_arr[i+2] = nil
        new_str_arr.compact!
      end

      i = i + 1
    end


    p new_str_arr
    p 'papa'
    # indices = new_str_arr.each_index.select { |el| new_str_arr[el] =~ /--/ }
    # indices.each do |idx| 
    #     new_str_arr[idx] = '-'
    #     new_str_arr[idx+1] = "-#{new_str_arr[idx+1]}"
    # end
    # correct constructions such as /- *- etc
    # p new_str_arr
    # indices = new_str_arr.each_index.select { |el| new_str_arr[el] =~ /^[\/*+]-/ }
    # indices.each do |idx|
    #     temp = new_str_arr[idx] 
    #     new_str_arr[idx] = temp.chars[0].to_s
    #     new_str_arr.insert(idx+1, temp.chars[1].to_s)
    # end
    new_str_arr
end

def prefix_number?(exp)
    exp =~ /^[-+]?\d+$/
end

def calc(expression)
    should_be_evaluated = false
    bracket_occured = false
    was_previous_set = false
    value_stack = []
    operator_stack = []
  
    return expression.to_f if prefix_number?(expression) 
    expression_arr = parse_input!(expression)

    p 'calc'
    p expression_arr
    p 'calc'

    expression_arr.each do |token|
     if token == '('
        bracket_occured = true
        operator_stack.push('(')
     elsif token == ')'
        bracket_occured = false
        evaluate_stack_till_right_bracket(operator_stack, value_stack)
        if should_be_evaluated
            evaluate_stack(operator_stack, value_stack)
        end
     elsif numeric?(token.to_s)
        value_stack.push(token)
        if should_be_evaluated && !bracket_occured 
            should_be_evaluated = false
            evaluate_stack(operator_stack, value_stack)
        end
      elsif accepted_arithmetic_exp?(token)
        should_be_evaluated = true if (token == '*' || token == '/')
        operator_stack.push(token)
      end
    end     
  
    while !operator_stack.empty? do 
      evaluate_stack(operator_stack, value_stack)
    end
    value_stack.first
end
  
#   p calc '1+1'
#   p calc '1 -1'
#   p calc '1* 1'
#   p calc '1 /1'
#   p calc '-123'
#   p calc '123'
#   p calc '2 / 2 + 3 * 4.75- - 6'
#   p calc '2 / (2 + 3) * 4.33 - -6'

#   p calc '12*-1'
# p calc '12* 123/-(-5 + 2)' # 492
# p calc ['12', '*', '123', '/', '-', '(', '-', '+', '2', ')']
# s = "2 /(2+3) * 4.75- -6",
#   rex = /-\d|\d*\.\d+|\d+|[+\-*/()]/g,
#   res = [];
# res = s.match(rex);
# console.log(res); // <- ["2", "/", "(", "2", "+", "3", ")", "*", "4.75", "-", "-6"]

# def witam(exp)
#     s = exp
#     new_string = s.gsub(" ", "").split(/(\d+\.?\d*)/).reject(&:empty?)
#     new_str_arr = new_string.map { |str| str.split(/([\(\)])/) }.flatten.reject(&:empty?)
#     # correct double -- signs
#     indices = new_str_arr.each_index.select { |el| new_str_arr[el] =~ /--/ }
#     indices.each do |idx| 
#         new_str_arr[idx] = '-'
#         new_str_arr[idx+1] = "-#{new_str_arr[idx+1]}"
#     end
#     # correct constructions such as /- *- etc
#     indices = new_str_arr.each_index.select { |el| new_str_arr[el] =~ /^[\/*+]-/ }
#     indices.each do |idx|
#         temp = new_str_arr[idx] 
#         new_str_arr[idx] = temp.chars[0].to_s
#         new_str_arr.insert(idx+1, temp.chars[1].to_s)
#     end
#     new_str_arr
# end

# witam("( 2 / 2 ) +3 * 4.75- -6")
# witam("12* 123/-(-5 + 2)")
# witam("12*-1")