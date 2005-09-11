require File.dirname(__FILE__) + '/../abstract_unit'

class JavaScriptMacrosHelperTest < Test::Unit::TestCase
  include ActionView::Helpers::JavaScriptHelper
  include ActionView::Helpers::JavaScriptMacrosHelper
  
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TagHelper
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::CaptureHelper
  
  def setup
    @controller = Class.new do
      def url_for(options, *parameters_for_method_reference)
        url =  "http://www.example.com/"
        url << options[:action].to_s if options and options[:action]
        url
      end
    end
    @controller = @controller.new
  end


  def test_auto_complete_field
    assert_equal %(<script type=\"text/javascript\">new Ajax.Autocompleter('some_input', 'some_input_auto_complete', 'http://www.example.com/autocomplete', {})</script>),
      auto_complete_field("some_input", :url => { :action => "autocomplete" });
    assert_equal %(<script type=\"text/javascript\">new Ajax.Autocompleter('some_input', 'some_input_auto_complete', 'http://www.example.com/autocomplete', {tokens:','})</script>),
      auto_complete_field("some_input", :url => { :action => "autocomplete" }, :tokens => ',');
    assert_equal %(<script type=\"text/javascript\">new Ajax.Autocompleter('some_input', 'some_input_auto_complete', 'http://www.example.com/autocomplete', {tokens:[',']})</script>),
      auto_complete_field("some_input", :url => { :action => "autocomplete" }, :tokens => [',']);  
  end
  
  def test_auto_complete_result
    result = [ { :title => 'test1'  }, { :title => 'test2'  } ]
    assert_equal %(<ul><li>test1</li><li>test2</li></ul>), 
      auto_complete_result(result, :title)
    assert_equal %(<ul><li>t<strong class=\"highlight\">est</strong>1</li><li>t<strong class=\"highlight\">est</strong>2</li></ul>), 
      auto_complete_result(result, :title, "est")
    
    resultuniq = [ { :title => 'test1'  }, { :title => 'test1'  } ]
    assert_equal %(<ul><li>t<strong class=\"highlight\">est</strong>1</li></ul>), 
      auto_complete_result(resultuniq, :title, "est")
  end
  
  def test_text_field_with_auto_complete
    assert_match "<style>",
      text_field_with_auto_complete(:message, :recipient)
    assert_equal %(<input autocomplete=\"off\" id=\"message_recipient\" name=\"message[recipient]\" size=\"30\" type=\"text\" /><div class=\"auto_complete\" id=\"message_recipient_auto_complete\"></div><script type=\"text/javascript\">new Ajax.Autocompleter('message_recipient', 'message_recipient_auto_complete', 'http://www.example.com/auto_complete_for_message_recipient', {})</script>),
      text_field_with_auto_complete(:message, :recipient, {}, :skip_style => true)
  end
end
