$("#ajax").append "<%= escape_javascript(render(:partial => 'ajax', :locals => {:record => @comment})) %>"

