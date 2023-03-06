require 'rails_helper'
RSpec.describe 'タスク管理機能', type: :system do
  describe '新規作成機能' do
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示される' do
        visit new_task_path
        fill_in 'タスク名', with: 'test title'
        fill_in 'コメント', with: 'test description'
        click_on '登録'
        expect(page).to have_content 'test title'
        expect(page).to have_content 'test description'
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
end