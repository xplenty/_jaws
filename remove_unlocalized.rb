#!/usr/bin/env ruby
require 'fileutils'

d = Dir["_site/jp/*"]

needed = ['_site/jp/assets']
localized = ['_site/jp/index.html','_site/jp/is']
ignored = [needed, localized].flatten

d.each do |x| 
   if ignored.any? { |ignored_page| ignored_page == x }
      puts "Left #{x}"
   else
      FileUtils.rm_rf(x)
      puts "Deleted #{x}"
   end
end