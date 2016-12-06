module UsersHelper
  def humanize_role(role)
    case role
    when 'manager' then t('users.roles.manager')
    when 'employee' then t('users.roles.employee')
    end
  end
end
