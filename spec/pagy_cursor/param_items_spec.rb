require "spec_helper"

RSpec.describe "Pagy::Backend params items" do
  let(:controller) { TestController.new }

  before do
    allow(controller).to receive(:params).and_return({ items: 30 })
  end

  it "uses items from params as limit" do
    # Mock collection
    collection = double("collection")
    allow(collection).to receive(:arel_table).and_return(double("arel_table"))
    allow(collection).to receive(:primary_key).and_return(:id)
    allow(collection).to receive(:reorder).and_return(collection)
    allow(collection).to receive(:limit).and_return(collection)
    allow(collection).to receive(:count).and_return(100)
    allow(collection).to receive(:last).and_return({id: 100})
    allow(collection).to receive(:empty?).and_return(false) 
    
    # Mock Active Record relation behavior roughly if needed, 
    # but pagy_cursor_get_items calls collection.full_stuff
    # We just need to check the pagy object returned.
    
    # Actually, let's use the real User model from dummy app if possible.
    # The dummy app has User model.
    # spec_helper requires dummy/config/environment
    
    User.create!(name: "Test") 
    
    pagy, _ = controller.send(:pagy_cursor, User.all, {})
    expect(pagy.limit).to eq(30)
  end
end
