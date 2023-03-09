require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  describe '新規作成機能' do
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示される' do
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
        task = FactoryBot.create(:task, title: 'task')
        visit tasks_path
        expect(page).to have_content 'task'
      end
    end

    context 'タスクが作成日時の降順に並んでいる場合' do
      it '新しいタスクが一番上に表示される' do
        task1 = FactoryBot.create(:task, title: 'task1', content: 'content1', created_at: Time.zone.now)
        task2 = FactoryBot.create(:task, title: 'task2', content: 'content2', created_at: Time.zone.now - 1.day)
        visit tasks_path
        task_list = all('.task_list') 
        expect(task_list[0]).to have_content 'task1'
        expect(task_list[1]).to have_content 'task2'
      end
    end
  end

  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      it '該当タスクの内容が表示される' do
        task = FactoryBot.create(:task, title: 'task', content: 'content')
        visit task_path(task)
        expect(page).to have_content 'task'
        expect(page).to have_content 'content'
      end
    end
  end

  describe '終了期限ソート機能' do
    context 'タスクが終了期限の降順に並んでいる場合' do
      it '期限が先のタスクが一番上に表示される' do
        task1 = FactoryBot.create(:task, title: 'task1', content: 'content1', limit: Time.current + 5.days)
        task2 = FactoryBot.create(:task, title: 'task2', content: 'content2', limit: Time.current + 10.days)
        visit tasks_path
        click_on '終了期限でソートする'
        sleep(0.5)
        task_list = all('.task_list') 
        expect(task_list[0]).to have_content 'task2'
        expect(task_list[1]).to have_content 'task1'
      end
    end
  end

  describe '検索機能' do
    describe 'タイトルで検索する場合' do
      it '検索結果に該当するタスクが表示される' do
      task1 = FactoryBot.create(:task, title: 'task1', status: '未着手')
      task2 = FactoryBot.create(:task, title: 'task2', status: '着手中')
      task3 = FactoryBot.create(:task, title: 'task3', status: '完了')
      visit tasks_path
      fill_in 'keyword', with: 'task1'
      click_on '検索'
      sleep(0.5)
      
      expect(page).to have_content 'task1'
      end
    end

    describe 'ステータスで検索する場合' do
      before do
        visit tasks_path
        select '着手中', from: 'ステータス'
        click_on '検索'
        sleep(0.5)
      end
  
      it '検索結果に該当するタスクが表示される' do
        expect(page).to have_content 'example'
      end
    end
  
  #   describe 'タイトルとステータスで検索する場合' do
  #     before do
  #       visit tasks_path
  #       fill_in 'タイトル', with: 'test'
  #       select '未着手', from: 'ステータス'
  #       click_on '検索'
  #       sleep(0.5)
  #     end
  
  #     it '検索結果に該当するタスクが表示される' do
  #       expect(page).to have_content 'test title'
  #     end
  #   end
  end
end