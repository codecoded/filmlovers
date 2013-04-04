require 'rubygems'
require 'sitemap_generator'

SitemapGenerator::Sitemap.default_host = 'http://www.filmlovers.co.uk'
SitemapGenerator::Sitemap.create do
  add '/', :changefreq => 'daily', :priority => 0.9
  add '/films/trends/now_playing', :changefreq => 'daily'
  add '/films/trends/upcoming', :changefreq => 'daily'
  add '/films/trends/popular', :changefreq => 'daily'
  add '/films/genres/action', :changefreq => 'weekly'
  add '/films/genres/adventure', :changefreq => 'weekly'
  add '/films/genres/comedy', :changefreq => 'weekly'
  add '/films/genres/science_fiction', :changefreq => 'weekly' 
  add '/films/genres/drama', :changefreq => 'weekly'
  add '/films/genres/animation', :changefreq => 'weekly'
  add '/films/genres/eastern', :changefreq => 'weekly'
  add '/films/genres/horror', :changefreq => 'weekly'
  add '/films/genres/foreign', :changefreq => 'weekly'
  add '/films/genres/indie', :changefreq => 'weekly'
  add '/films/genres/suspense', :changefreq => 'weekly'
  add '/films/genres/romance', :changefreq => 'weekly'

end
SitemapGenerator::Sitemap.ping_search_engines # called for you when you use the rake task