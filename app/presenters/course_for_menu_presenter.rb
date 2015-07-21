class CourseForMenuPresenter
  include I18nUtilities
  include Rails.application.routes.url_helpers

  DASHBOARD_CARD_TABS = [
    Course::TAB_DISCUSSIONS, Course::TAB_ASSIGNMENTS,
    Course::TAB_ANNOUNCEMENTS, Course::TAB_FILES
  ].freeze

  def initialize(course, available_section_tabs)
    @course = course
    @available_section_tabs = available_section_tabs.select do |tab|
      DASHBOARD_CARD_TABS.include?(tab[:id])
    end
  end
  attr_reader :course, :available_section_tabs

  def to_h
    {
      longName: "#{course.name} - #{course.short_name}",
      shortName: course.name,
      courseCode: course.course_code,
      href: course_path(course, :invitation => course.read_attribute(:invitation)),
      term: term || nil,
      subtitle: subtitle,
      id: course.id,
      links: available_section_tabs.map do |tab|
        presenter = SectionTabPresenter.new(tab, course)
        presenter.to_h
      end
    }
  end

  private
  def role
    Role.get_role_by_id(course.primary_enrollment_role_id) ||
      Enrollment.get_built_in_role_for_type(course.primary_enrollment_type)
  end

  def subtitle
    args = if course.primary_enrollment_state == 'invited'
      ['#shared.menu_enrollment.labels.invited_as', 'invited as']
    else
      ['#shared.menu_enrollment.labels.enrolled_as', 'enrolled as']
    end
    [ before_label(*args), role.try(:label) ].join(' ')
  end

  def term
    course.enrollment_term.name unless course.enrollment_term.default_term?
  end
end
