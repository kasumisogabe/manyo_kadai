require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:task) { FactoryBot.create(:task, user: user) }
  let!(:second_task) { FactoryBot.create(:second_task, user: user) }

  describe '新規作成機能' do
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示される' do
        visit new_session_path
        fill_in 'session[email]', with: 'ippan@gmail.com'
        fill_in 'session[password]', with: '12345678'
        click_button 'Log in'
        visit new_task_path
        fill_in 'タスク名', with: 'test title'
        fill_in 'コメント', with: 'test description'
        fill_in "終了期限", with: '2023-03-10'
        select '着手中', from: 'ステータス'
        click_on '登録'
        expect(page).to have_content 'test title'
        expect(page).to have_content 'test description'
        expect(page).to have_content '2023-03-10'
        expect(page).to have_content '着手中'
      end
    end
  end

  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do
        visit new_session_path
        fill_in 'session[email]', with: 'ippan@gmail.com'
        fill_in 'session[password]', with: '12345678'
        click_button 'Log in'
        visit tasks_path
        expect(page).to have_content 'test'
      end
    end

    context 'タスクが作成日時の降順に並んでいる場合' do
      it '新しいタスクが一番上に表示される' do
        visit new_session_path
        fill_in 'session[email]', with: 'ippan@gmail.com'
        fill_in 'session[password]', with: '12345678'
        click_button 'Log in'
        visit tasks_path
        task_list = all('.task_list') 
        expect(task_list[0]).to have_content 'テスト2'
        expect(task_list[1]).to have_content 'test_title'
      end
    end
  end

  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      it '該当タスクの内容が表示される' do
        visit new_session_path
        fill_in 'session[email]', with: 'ippan@gmail.com'
        fill_in 'session[password]', with: '12345678'
        click_button 'Log in'
        visit task_path(task)
        expect(page).to have_content 'test_title'
        expect(page).to have_content 'test_content'
      end
    end
  end

  describe '終了期限ソート機能' do
    context 'タスクが終了期限の降順に並んでいる場合' do
      it '期限が先のタスクが一番上に表示される' do
        visit new_session_path
        fill_in 'session[email]', with: 'ippan@gmail.com'
        fill_in 'session[password]', with: '12345678'
        click_button 'Log in'
        visit tasks_path
        click_on '終了期限'
        sleep(0.5)
        task_list = all('.task_list') 
        expect(task_list[0]).to have_content 'test_title'
        expect(task_list[1]).to have_content 'テスト2'
      end
    end
  end

  describe '検索機能' do
    describe 'タイトルで検索する場合' do
      it '検索結果に該当するタスクが表示される' do
      visit new_session_path
      fill_in 'session[email]', with: 'ippan@gmail.com'
      fill_in 'session[password]', with: '12345678'
      click_button 'Log in'
      visit tasks_path
      fill_in 'keyword', with: 'test'
      click_on '検索'
      sleep(0.5)
      
      expect(page).to have_content 'test_title'
      end
    end

    describe 'ステータスで検索する場合' do
      before do
        visit new_session_path
        fill_in 'session[email]', with: 'ippan@gmail.com'
        fill_in 'session[password]', with: '12345678'
        click_button 'Log in'
        visit tasks_path
        select '着手中', from: 'status'
        click_on '検索'
        sleep(0.5)
      end
  
      it '検索結果に該当するタスクが表示される' do
        expect(page).to have_content 'test_title'
      end
    end
  
    describe 'タイトルとステータスで検索する場合' do
      before do
        visit new_session_path
        fill_in 'session[email]', with: 'ippan@gmail.com'
        fill_in 'session[password]', with: '12345678'
        click_button 'Log in'
        visit tasks_path
        fill_in 'keyword', with: 'test'
        select '着手中', from: 'status'
        click_on '検索'
        sleep(0.5)
      end
  
      it '検索結果に該当するタスクが表示される' do
        expect(page).to have_content 'test_title'
      end
    end
  end
end