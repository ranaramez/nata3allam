#!/bin/env ruby
# encoding: utf-8
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

  def format_time(time)
    t = Time.at(time)
    t.strftime "%d/%m [%H:%M]"
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

  def request_text(closed)
    closed ? "الطلب مغلق" : "الطلب مفتوح" 
  end

  def request_link(closed)
    closed ? "إضغط هنا لفتحه" : "إضغط هنا لغلقه"
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

  def get_month_names
    arr = ["january", "february","march", "april", "may", "june",
      "july", "august", "september","october", "november", "december"]
    arr.map { |m| translate(m) }
  end

  def class_options
    [translate('NA'), nil] + NClass.all.map{ |i| [i.name, i._id]}
  end
end
