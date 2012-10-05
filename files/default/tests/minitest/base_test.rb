require 'minitest/spec'


describe_recipe 'sites-docs::base' do

  # It's often convenient to load these includes in a separate
  # helper along with
  # your own helper methods, but here we just include them directly:
  include MiniTest::Chef::Assertions
  include MiniTest::Chef::Context
  include MiniTest::Chef::Resources

  it "create a lunch file" do
    file("/var/www/vhosts/docs.typo3.orgs").must_exist
  end
end
