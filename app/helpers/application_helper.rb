module ApplicationHelper

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
