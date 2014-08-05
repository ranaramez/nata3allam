module ApplicationHelper

  def nav_link(link_text, link_path, classes)
    class_name = current_page?(link_path) ? 'active ' : ''

    content_tag(:li, class: class_name) do
      link_to link_path, class: classes do
        content_tag(:i, "", nil).concat(link_text)
      end
    end
  end
  
  def format_number(numbers)
    numbers = numbers.to_s
    results = numbers.chars.map { |char| translate char }.join
  end

  def format_date(date)
    month = translate(date.strftime("%B").downcase)
    number = format_number(date.strftime("%d").to_i)
    "#{number} #{month}"
  end

  def format_grade(grade, total_grade)
    if grade == 0 && total_grade==0
      return '-'
    else
    "#{format_number(total_grade)} /  #{format_number(grade)}"
    end
  end

  def format_arr(arr)
    arr.join(', ').to_s
  end

  def format_month(month_no)
    translate(Date::MONTHNAMES[month_no].downcase)
  end

  def translate(text)
 	  begin
  	  I18n.translate!(text, :raise => true) 
    rescue I18n::MissingTranslationData
      text
    end
  end

  def get_student_grades lessons, evaluation_record
    evaluation_record.get_student_grades lessons
  end
end
