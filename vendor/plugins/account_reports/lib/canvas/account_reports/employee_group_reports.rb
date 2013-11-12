#
# Copyright (C) 2012 - 2013 Instructure, Inc.
#
# This file is part of Canvas.
#
# Canvas is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, version 3 of the License.
#
# Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.
#

module Canvas::AccountReports

  class EmployeeGroupReports
    include Api
    include Canvas::AccountReports::ReportHelper

    def initialize(account_report)
      grade = 0
      letter_grade = 'NC'
      enrollments = Array.new
      report_course = account_report.parameters["report_course"].presence
      report_association = account_report.parameters["report_association"].presence
      result = CSV.generate do |csv|
        csv << ['EIN', 'Employee Name', 'Location Code', 'Location Name', 'Union/ Affiliation', 'Department/ Job Title', 'P=Pass, F=Fail, NC=Not Complete', 'Grade']
        courses = Course.find(:all, :conditions => ["course_code LIKE ?", "#{report_course}%"])
        if courses != nil
          courses.each do |course|
            quiz = course.quizzes.find(:first)
            if quiz != nil
              points_possible = quiz.points_possible
              enrollments = course.all_student_enrollments
              if enrollments != nil
                enrollments.each do |enrollment|
                  user = User.find(enrollment.user_id)
                  if user != nil
                    if user.phone != nil and user.phone == report_association
                      user_sis_user_id = 'Unknown'
                      user_sortable_name = 'Unknown'
                      user_phone = 'Unknown'
                      user_school_position = 'Unknown'
                      user_location_code = 'Unknown'
                      user_location_name = 'Unknown'
                      grade = 0
                      letter_grade = 'NC'
                      submission = QuizSubmission.find_by_quiz_id_and_user_id(quiz.id, user.id)
                      if submission != nil
                        if submission.kept_score != nil
                          grade = submission.kept_score
                        else # we have no kept score
                          grade = 0
                        end
                        if (grade/points_possible)*100 >= 80
                          letter_grade = 'P'
                        elsif (grade/points_possible)*100 < 80
                          letter_grade = 'F'
                        else
                          letter_grade = 'NC'
                        end
                      else  # we have no submission
                        grade = 0
                        letter_grade = 'NC'
                      end
                      if user.primary_pseudonym.sis_user_id       != nil then user_sis_user_id = user.primary_pseudonym.sis_user_id end
                      if user.sortable_name     != nil then user_sortable_name = user.sortable_name end
                      if user.phone             != nil then user_phone = user.phone end
                      if user.school_position   != nil then user_school_position = user.school_position end
                      if user.school_name       != nil then user_location_code = user.school_name[(user.school_name.index('(')+1)..(user.school_name.index(')')-1)] end
                      if user.school_name       != nil then user_location_name = user.school_name[0..(user.school_name.index('(')-2)] end
                      arr = []
                      arr << user_sis_user_id
                      arr << user_sortable_name
                      arr << user_location_code
                      arr << user_location_name
                      arr << user_phone
                      arr << user_school_position
                      arr << letter_grade
                      arr << grade
                      csv << arr
                    end # end if user in assoc
                  else # we have no user
                    arr = []
                    arr << 'error - no user'
                    arr << 'error - no user'
                    arr << 'error - no user'
                    arr << 'error - no user'
                    arr << 'error - no user'
                    arr << 'error - no user'
                    arr << 'error - no user'
                    arr << 'error - no user'
                    csv << arr
                  end # end if we have user
                end # end enrollments do
              else # we have no enrollments for this course
                csv << ['No enrollments found for at least one course']
              end 
            else # we have no quiz
              csv << ['No quiz found for at least one course']
            end
          end # end courses do
        else # we have no courses
          csv << ['No courses found']
        end
      end # end of csv do
      Canvas::AccountReports.message_recipient(account_report, I18n.t('account_reports.default.outcome.message',"Employee Group Report successfully generated for %{account_name}", :account_name => account_report.account.name), result)
      result
    end
  end
end
