$('#students-list').html("<%= escape_javascript(render partial: 'students_list', locals: {students: @students, pages_count: @pages_count, page: @page}) %>")