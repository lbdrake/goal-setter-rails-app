require 'rails_helper'

describe Goal do
  it { should validate_presence_of :title }
  it { should validate_inclusion_of(:goal_type).in_array(["Private","Public"]) }
  it { should validate_presence_of :user_id }
end
