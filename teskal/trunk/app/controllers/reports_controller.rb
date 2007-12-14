class ReportsController < ApplicationController
  before_filter :require_login, :require_coach

  # example action to return the contents # of a table in CSV format
  def export
    answer = Answer.find_by_sql("select * from answers where answers.user_id in (select users.id from users where users.managed_by=#{session[:user_id]}) order by answers.quest_id,answers.created_on ASC")
    stream_csv do |csv|
      csv << [l(:label_quest) ,"user",l(:label_date),"#1","#2","#3","#4","#5","#6","#7","#8","#9","#10","#11","#12","#13","#14","#15","#16","#17","#18","#19","#20","#21","#22","#23","#24","#25","#26","#27","#28","#29","#30","#31","#32","#33","#34","#35","#36","#37","#38","#39","#40","#41","#42","#43","#44","#45","#46","#47","#48","#49","#50","#51","#52","#53","#54","#55","#56","#57","#58","#59","#60","#61","#62","#63","#64","#65","#66","#67","#68","#69","#70","#71","#72","#73","#74","#75","#76","#77",l(:field_notes),l(:label_competition)]
      answer.each do |a|
        user = User.find(a.user_id)
        nombre=user.name
        case a.quest_id
        when 1:
          csv << [a.quest_id,nombre,l_date(a.created_on),a.answ1,a.answ2 ,a.answ3 ,a.answ4 ,a.answ5 ,a.answ6 ,a.answ7 ,a.answ8 ,a.answ9 ,a.answ10 ,a.answ11 ,a.answ12 ,a.answ13,a.answ14 ,a.answ15 ,a.answ16 ,a.answ17 ,a.answ18 ,a.answ19 ,a.answ20 ,a.answ21 ,a.answ22 ,a.answ23 ,a.answ24,a.answ25 ,a.answ26 ,a.answ27 ,a.answ28 ,a.answ29 ,a.answ30 ,a.answ31 ,a.answ32 ,a.answ33 ,a.answ34 ,a.answ35,a.answ36 ,a.answ37 ,a.answ38 ,a.answ39 ,a.answ40 ,a.answ41 ,a.answ42 ,a.answ43 ,a.answ44 ,a.answ45 ,a.answ46,a.answ47 ,a.answ48 ,a.answ49 ,a.answ50 ,a.answ51 ,a.answ52 ,a.note1 ,a.answ66, a.answ67, a.note2 ,a.answ68, a.answ69, a.note3 ,a.answ70, a.answ71, a.note4 ,a.answ72, a.answ73, a.answ53 ,a.answ54 ,a.answ55 ,a.answ56 ,a.answ57,a.answ58 ,a.answ59 ,a.answ60 ,a.answ61 ,a.answ62 ,a.answ63 ,a.answ64 ,a.answ65 ,a.note5,a.competition]
        when 4:
          csv << [a.quest_id,nombre,l_date(a.created_on),a.answ1,a.answ2 ,a.answ3 ,a.answ4 ,a.answ5 ,a.answ6 ,a.answ7 ,a.answ8 ,a.answ9 ,a.answ10 ,a.answ11 ,a.answ12 ,a.answ13,a.answ14 ,a.answ15 ,a.note1 ,a.answ17 ,a.answ18 ,a.answ19 ,a.answ20 ,a.answ21 ,a.answ22 ,a.answ23 ,a.answ24,a.answ25 ,a.answ26 ,a.answ27 ,a.answ28 ,a.answ29 ,a.answ30 ,a.answ31 ,a.answ32 ,a.answ33 ,a.answ34 ,a.answ35,a.answ36 ,a.answ37 ,a.answ38 ,a.answ39 ,a.answ40 ,a.answ41 ,a.answ42 ,a.answ43 ,a.answ44 ,a.answ45 ,a.answ46,a.answ47 ,a.answ48 ,a.answ49 ,a.answ50 ,a.answ51 ,a.answ52 ,a.answ53 ,a.answ54 ,a.answ55 ,a.answ56 ,a.answ57,a.answ58 ,a.answ59 ,a.answ60 ,a.answ61 ,a.answ62 ,a.answ63 ,a.answ64 ,a.answ65 ,a.answ66 ,a.answ67 ,a.answ68,a.answ69 ,a.answ70 ,a.answ71 ,a.answ72 ,a.answ73 ,a.answ74 ,a.answ75 ,a.answ76 ,a.answ77,a.note2,a.competition]
        else
          csv << [a.quest_id,nombre,l_date(a.created_on),a.answ1,a.answ2 ,a.answ3 ,a.answ4 ,a.answ5 ,a.answ6 ,a.answ7 ,a.answ8 ,a.answ9 ,a.answ10 ,a.answ11 ,a.answ12 ,a.answ13,a.answ14 ,a.answ15 ,a.answ16 ,a.answ17 ,a.answ18 ,a.answ19 ,a.answ20 ,a.answ21 ,a.answ22 ,a.answ23 ,a.answ24,a.answ25 ,a.answ26 ,a.answ27 ,a.answ28 ,a.answ29 ,a.answ30 ,a.answ31 ,a.answ32 ,a.answ33 ,a.answ34 ,a.answ35,a.answ36 ,a.answ37 ,a.answ38 ,a.answ39 ,a.answ40 ,a.answ41 ,a.answ42 ,a.answ43 ,a.answ44 ,a.answ45 ,a.answ46,a.answ47 ,a.answ48 ,a.answ49 ,a.answ50 ,a.answ51 ,a.answ52 ,a.answ53 ,a.answ54 ,a.answ55 ,a.answ56 ,a.answ57,a.answ58 ,a.answ59 ,a.answ60 ,a.answ61 ,a.answ62 ,a.answ63 ,a.answ64 ,a.answ65 ,a.answ66 ,a.answ67 ,a.answ68,a.answ69 ,a.answ70 ,a.answ71 ,a.answ72 ,a.answ73 ,a.answ74 ,a.answ75 ,a.answ76 ,a.answ77,a.note1,a.competition]
        end
      end
    end
  end

  private
  def stream_csv
    filename = params[:action] + ".csv"

    #this is required if you want this to work with IE
    if request.env['HTTP_USER_AGENT'] =~ /msie/i
      headers['Pragma'] = 'public'
      headers["Content-type"] = "text/plain"
      headers['Cache-Control'] = 'no-cache, must-revalidate, post-check=0, pre-check=0'
      headers['Content-Disposition'] = "attachment; filename=\"#{filename}\""
      headers['Expires'] = "0"
    else
      headers["Content-Type"] ||= 'text/csv'
      headers["Content-Disposition"] = "attachment; filename=\"#{filename}\""
    end

    render :text => Proc.new { |response, output|
      csv = FasterCSV.new(output, :row_sep => "\r\n",:col_sep => ";")
      yield csv
    }
  end
end
