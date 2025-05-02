# == Schema Information
#
# Table name: transactions
#
#  id          :integer          not null, primary key
#  unit_amount :float
#  quantity    :integer
#  date        :date
#  description :string
#  invoice_id  :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'test_helper'

class TransactionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
