require 'spec_helper.rb'
require 'rails_helper.rb'

describe 'ArchivalObject', js: true do
  before(:all) do
    @repo = create(:repo, repo_code: "archival_object_test_#{Time.now.to_i}")
    set_repo(@repo)
    @resource = create(:resource)
    @ao = create(:json_archival_object,
           :resource => {'ref' => @resource.uri})

    $index.run_index_round
  end

  before(:each) do
    login_admin
    select_repository(@repo)
    edit_resource(@resource)
  end

  context 'Export', js: true do

    it 'has MARC export button' do
      visit "resources/#{@resource.id}#tree::archival_object_#{@ao.id}"
      page.has_xpath? "//div/a[contains(text(),'Export')]"

      within('.record-toolbar') do
        click_link('Export')
        expect(page).to have_text 'Download MARCXML'
        page.find('.download-marc-action').hover
        expect(page).to have_text 'Include unpublished'
      end
    end

  end

end