module ApplicationHelper

  def sleek_card_classes
    "background: #fff; border-radius: 1rem; border: 1px solid #eee; padding: 1.5rem; box-shadow: 0 2px 12px rgba(0,0,0,0.03);"
  end

  def member_display_name(user)
    user.name.presence || user.email.split('@').first.humanize
  end

  def button_link(text, url, variant: 'primary', size: 'normal', **options)
    render 'shared/button', text: text, url: url, variant: variant, size: size, html_options: options
  end

  def markdown(text)
    renderer = Redcarpet::Render::HTML.new(filter_html: true, hard_wrap: true)
    extensions = {
      autolink: true,
      fenced_code_blocks: true,
      tables: true,
      strikethrough: true,
      underline: true,
      highlight: true,
      quote: true,
      footnotes: true
    }
    markdown = Redcarpet::Markdown.new(renderer, extensions)
    markdown.render(text || "")
  end
end
