module ApplicationHelper
  def page_breadcrumbs(*breadcrumbs)
    breadcrumbs.map.with_index do |crumb, index|
      if index == breadcrumbs.length - 1
        { name: crumb, current: true }
      else
        { name: crumb, current: false }
      end
    end
  end

  def newsletter_unsubscribe_url(email)
    Rails.application.routes.url_helpers.newsletter_subscribers_unsubscribe_url(email: email, host: Rails.application.config.action_mailer.default_url_options[:host] || 'localhost:3001')
  end
end
