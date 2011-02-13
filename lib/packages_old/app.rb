%w(
  support
  fake_gems
  users
  bag
).each{|f| require "packages/app/#{f}"}