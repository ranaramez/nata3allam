module ApplicationHelper
  
  def format_number(numbers)
    numbers = numbers.to_s if numbers.is_a? Integer
    results = numbers.chars.map { |char| translate char }.join
  end

  def format_date(date)
    month = translate(date.strftime("%B").downcase)
    number = format_number(date.strftime("%d").to_i)
    "#{number} #{month}"
  end

  def format_arr(arr)
    arr.join(', ').to_s
  end

  def translate(text)
 	  begin
  	  I18n.translate!(text, :raise => true) 
    rescue I18n::MissingTranslationData
      text
    end
  end

end
