module SecretSantasHelper
  def secret_santa_status_badge(secret_santa)
    case secret_santa.status
    when 'draft'
      status_badge('Draft', '#ffc107', '#000')
    when 'active'
      status_badge('Active', '#28a745', '#fff')
    when 'completed'
      status_badge('Completed', '#6c757d', '#fff')
    end
  end

  def format_budget(amount)
    return 'No limit' unless amount
    "$#{amount}"
  end

  private

  def status_badge(text, bg_color, text_color)
    content_tag :span, text, 
      style: "background: #{bg_color}; color: #{text_color}; padding: 0.2rem 0.5rem; border-radius: 0.3rem; font-size: 0.7rem;"
  end
end