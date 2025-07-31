SitemapGenerator::Sitemap.default_host = "http://www.wizzle.gifts"

SitemapGenerator::Sitemap.sitemaps_host = "http://blog.wizzle.gifts"
SitemapGenerator::Sitemap.create do
  add '/', priority: 1.0, changefreq: 'daily'
  add '/about', priority: 0.8, changefreq: 'monthly'
  add '/how_it_works', priority: 0.8, changefreq: 'monthly'
  add '/feature_requests', priority: 0.7, changefreq: 'monthly'
  add '/roadmap', priority: 0.7, changefreq: 'monthly'

  add 'http://blog.wizzle.gifts/', priority: 0.9, changefreq: 'daily'

  BlogPost.where(published: true).find_each do |post|
    add "http://blog.wizzle.gifts/posts/#{post.id}", lastmod: post.updated_at, priority: 0.9, changefreq: 'weekly'
  end

  # Exclude: admin pages, private wishlists, and any page requiring sign-in
  # (Do NOT add those paths here)
end