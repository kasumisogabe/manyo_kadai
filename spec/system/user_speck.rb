require 'rails_helper'
RSpec.describe 'ユーザ機能', type: :system do
  describe 'ユーザ登録のテスト' do
    context 'ユーザを新規作成した場合' do
      it 'ユーザの新規登録がされる' do
        visit new_user_path
        fill_in 'user[name]', with: 'test'
        fill_in 'user[email]', with: 'test@example.com'
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
        click_button 'Create my account'
        expect(page).to have_content 'test'
      end

      it 'ログインしていない場合、タスク一覧画面にアクセスできない' do
        visit tasks_path
        expect(page).to have_content 'Log in'
      end
    end
  end
end