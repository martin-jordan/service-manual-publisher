require 'rails_helper'
require 'capybara/rails'

RSpec.describe "discarding guides", type: :feature do
  before do
    allow_any_instance_of(Publisher).to receive(:discard_draft)
      .and_return(Publisher::Response.new(success: true))
  end

  it "makes the user confirm discarding the draft", js: true do
    guide = create(:guide, :with_draft_edition)
    visit edit_guide_path(guide)
    click_first_button "Discard draft"
    expect(page.driver.browser.modal_message).to include "Are you sure you want to discard this draft?"
  end

  context "when the latest edition is published" do
    it "does not allow discarding" do
      guide = create(:published_guide)
      visit edit_guide_path(guide)
      expect(page).to_not have_button "Discard draft"
    end
  end

  context "with a successful discard_draft" do
    it "discards the draft in the publishing api" do
      guide = create(:guide, :with_draft_edition)

      fake_publisher = double(:publisher)
      expect(Publisher).to receive(:new)
        .with(content_model: guide)
        .and_return(fake_publisher)
      expect(fake_publisher).to receive(:discard_draft)
        .and_return(Publisher::Response.new(success: true))

      visit edit_guide_path(guide)
      click_first_button "Discard draft"
      within ".alert" do
        expect(page).to have_content "Draft has been discarded"
      end
    end
  end

  context "with an unsuccessful discard_draft" do
    it "does not discard the draft" do
      guide = create(:guide, :with_draft_edition)
      discard_draft_response = Publisher::Response.new(
        success: false,
        error: "An error occurred",
      )
      expect_any_instance_of(Publisher).to receive(:discard_draft)
        .and_return(discard_draft_response)

      visit edit_guide_path(guide)
      click_first_button "Discard draft"
      within ".alert" do
        expect(page).to have_content "An error occurred"
      end
    end
  end
end