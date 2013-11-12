namespace :wrdsb do

  desc "Run New Employee Group Report"
  task :new_employee_group_reports => [:environment] do
    sws_courses = [
      'ANA2013-',
      'VH2013-',
      'WHMISG2013-',
      'WHMISC2013-',
      'WHMISS2013-'
    ]

    # Generate the list of associations
    users = User.find(:all, :group => 'phone')
    sws_associations = Array.new
    users.each do |user|
      if user.phone != nil
        association = user.phone
        sws_associations << association
      end
    end

    sws_courses.each do |sws_course|
      sws_associations.each do |sws_association|
        result = CSV.generate do |csv|
          csv << ['EIN', 'Employee Name', 'Location Code', 'Location Name', 'Union/ Affiliation', 'Department/ Job Title', 'P=Pass, F=Fail, NC=Not Complete', 'Grade']
          User.find_all_by_phone(sws_association).each do |user|
            grade = 0
            letter_grade = 'NC'
            user_sis_user_id = 'Unknown'
            user_sortable_name = 'Unknown'
            user_phone = 'Unknown'
            user_school_position = 'Unknown'
            user_location_code = 'Unknown'
            user_location_name = 'Unknown'
            if user.primary_pseudonym.sis_user_id       != nil then user_sis_user_id = user.primary_pseudonym.sis_user_id end
            if user.sortable_name     != nil then user_sortable_name = user.sortable_name end
            if user.phone             != nil then user_phone = user.phone end
            if user.school_position   != nil then user_school_position = user.school_position end
            if user.school_name       != nil then user_location_code = user.school_name[(user.school_name.index('(')+1)..(user.school_name.index(')')-1)] end
            if user.school_name       != nil then user_location_name = user.school_name[0..(user.school_name.index('(')-2)] end
            user_for_csv = Hash.new
            user_for_csv['include'] = false
            user_for_csv['ein'] = user_sis_user_id
            user_for_csv['employee_name'] = user_sortable_name
            user_for_csv['location_code'] = user_location_code
            user_for_csv['location_name'] = user_location_name
            user_for_csv['affiliation'] = user_phone
            user_for_csv['department'] = user_school_position
            user_for_csv['letter_grade'] = letter_grade
            user_for_csv['grade'] = grade
            Enrollment.find_all_by_user_id(user.id).each do |enrollment|
              course = enrollment.course
              if course.course_code.include? sws_course
                user_for_csv['include'] = true
                course.quizzes.each do |quiz|
                  if quiz != nil
                    points_possible = quiz.points_possible
                    submission = QuizSubmission.find_by_quiz_id_and_user_id(quiz.id, user.id)
                    if submission != nil
                      if submission.kept_score != nil
                        grade = submission.kept_score
                      else
                        grade = 0
                      end
                      if (grade/points_possible)*100 >= 80
                        letter_grade = 'P'
                      elsif (grade/points_possible)*100 < 80
                        letter_grade = 'F'
                      else
                        letter_grade = 'NC'
                      end
                      if grade.to_i > user_for_csv['grade'].to_i
                        user_for_csv['letter_grade'] = letter_grade
                        user_for_csv['grade'] = grade
                      end
                    end  # end if submission != nil
                  end  # end if quiz != nil
                end  # course.quizzes.each do |quiz|
              end  # end if course.course_code.include? sws_course
            end  # Enrollment.find_all_by_user_id(user.id).each do |enrollment|
            if user_for_csv['include'] == true
              user_csv_array = Array.new
              user_csv_array << user_for_csv['ein']
              user_csv_array << user_for_csv['employee_name']
              user_csv_array << user_for_csv['location_code']
              user_csv_array << user_for_csv['location_name']
              user_csv_array << user_for_csv['affiliation']
              user_csv_array << user_for_csv['department']
              user_csv_array << user_for_csv['letter_grade']
              user_csv_array << user_for_csv['grade']
              csv << user_csv_array
            end  # end if user_for_csv['include'] == true
          end  # end User.each
        end  # end result = csv do
        puts "Writing file #{sws_course}#{sws_association}_employee_group_report_report.csv"
        File.open("/home/wrdsb/canvas_reporting/#{sws_course}#{sws_association}_employee_group_report_report.csv", 'w') do |f|
          f.write(result)
        end
      end  # end sws_associations.each
    end  # end sws_courses.each
  end  # end task
end  # end namespace

