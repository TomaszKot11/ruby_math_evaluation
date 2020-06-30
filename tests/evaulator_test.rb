require 'minitest/autorun'
require '../main'

class EvaluatorTest < Minitest::Test 
    # tests for proceduraly written code 

    # -----
    # parse_input!
    # -----
    def test_parse_input_parses_without_brackets
       # when
       result =  parse_input!('1+1')
       # then
       assert_equal ["1", "+", "1"], result 
    end

    def test_parse_input_with_brackets 
        # when 
        result = parse_input!('2*(1+(2+3)+4)')        
        # then
        assert_equal ["2", "*", "(", "1", "+", "(", "2", "+","3", ")", "+", "4", ")"], result
    end

    def test_parse_input_with_whitespaces
        # when 
        result = parse_input!('1    + 1')
        # then
        assert_equal ["1", "+", "1"], result
    end

    ['*', '/', '-', '+'].each do |op|
        expression = "12#{op}-3"

        define_method("test_parse_input_with_negation_after_#{op}_operator") do 
            # when 
            result = parse_input!(expression)
            # then 
            assert_equal ["12", "#{op}-", "3"], result
        end
    end

    def test_negation_of_number_inside_of_a_bracket
        # when 
        result = parse_input!('12*123 / (-5+2)')
        # then 
        assert_equal ["12", "*", "123", "/", "(", "-5", "+", "2", ")"], result
    end

    # -----
    # calc
    # mainly examples from the challenge - tests useful while development
    # -----
    challenge_test_suite = [
                                # ['1+1', 2],
                                # ['1 -1', 0],
                                # ['1* 1', 1],
                                # ['1 /1', 1],
                                # ['-123', -123],
                                # ['123', 123],
                                # ['2 / 2 + 3 * 4.75- - 6', 21.25],
                                # ['2 / (2 + 3) * 4.33 - -6', 7.732],
                                # ['12*-1', -12],
                                # ['12* 123/-(-5 + 2)', 492],
                                ['((80 - (19)))', 61],
                                # ['1 - -(-(-(-4)))', -3]
                            ]
    
    challenge_test_suite.each do |pair|
        define_method("test_'#{pair[0]}'_should_equal_to_#{pair[1]}") do 
            # when 
            result = calc(pair[0])
            # then 
            assert_equal pair[1], result
        end
    end
end